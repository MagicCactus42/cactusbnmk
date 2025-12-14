#!/bin/bash
# =============================================================================
# CactusBNMK - GitHub API Module
# =============================================================================
# Functions for interacting with GitHub API to analyze user activity
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_GITHUB_API_SH_LOADED:-}" ]] && return 0
readonly _GITHUB_API_SH_LOADED=1

# Get script directory
_GITHUB_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source dependencies
source "${_GITHUB_SCRIPT_DIR}/lib/colors.sh"
source "${_GITHUB_SCRIPT_DIR}/lib/utils.sh"
source "${_GITHUB_SCRIPT_DIR}/lib/config.sh"

# =============================================================================
# API Request Functions
# =============================================================================

# Make a GitHub API request
# Usage: github_api_request <endpoint> [token]
github_api_request() {
    local endpoint="$1"
    local token="${2:-}"

    local headers=(-H "Accept: application/vnd.github+json")
    headers+=(-H "X-GitHub-Api-Version: ${GITHUB_API_VERSION}")

    if [[ -n "$token" ]]; then
        headers+=(-H "Authorization: Bearer ${token}")
    fi

    local response
    response=$(curl -s -w "\n%{http_code}" "${headers[@]}" "${GITHUB_API_BASE}${endpoint}")

    local http_code
    http_code=$(echo "$response" | tail -n1)
    local body
    body=$(echo "$response" | sed '$d')

    if [[ "$http_code" -ge 200 && "$http_code" -lt 300 ]]; then
        echo "$body"
        return 0
    else
        log_error "GitHub API error (HTTP $http_code): $body"
        return 1
    fi
}

# =============================================================================
# User Data Functions
# =============================================================================

# Check if GitHub user exists
# Usage: github_user_exists <username>
github_user_exists() {
    local username="$1"

    if ! validate_github_username "$username"; then
        log_error "Invalid GitHub username format: $username"
        return 1
    fi

    local response
    response=$(curl -s -o /dev/null -w "%{http_code}" "${GITHUB_API_BASE}/users/${username}")

    [[ "$response" == "200" ]]
}

# Get user profile information
# Usage: github_get_user <username> [token]
github_get_user() {
    local username="$1"
    local token="${2:-}"

    github_api_request "/users/${username}" "$token"
}

# Get user's public repositories
# Usage: github_get_repos <username> [token]
github_get_repos() {
    local username="$1"
    local token="${2:-}"

    github_api_request "/users/${username}/repos?per_page=100&sort=updated" "$token"
}

# =============================================================================
# Commit Analysis Functions
# =============================================================================

# Get commit count for a repository in the last year
# Usage: get_repo_commits_count <username> <repo> [token]
get_repo_commits_count() {
    local username="$1"
    local repo="$2"
    local token="${3:-}"

    local since
    since=$(year_ago)

    local response
    response=$(github_api_request "/repos/${username}/${repo}/commits?author=${username}&since=${since}T00:00:00Z&per_page=1" "$token" 2>/dev/null)

    if [[ $? -ne 0 ]]; then
        echo "0"
        return
    fi

    # Try to get the total count from Link header or count the commits
    local count
    count=$(echo "$response" | jq -r 'length' 2>/dev/null)

    if [[ "$count" == "null" || -z "$count" ]]; then
        echo "0"
    else
        echo "$count"
    fi
}

# Analyze user's commit activity over the last year
# Usage: analyze_user_commits <username> [token]
analyze_user_commits() {
    local username="$1"
    local token="${2:-}"

    log_info "Analyzing GitHub activity for: $username"

    # Check cache first
    local cache_file="${CACHE_DIR}/${username}_commits.json"
    if [[ -f "$cache_file" ]]; then
        local cache_age=$(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null)))
        if (( cache_age < CACHE_EXPIRY )); then
            log_debug "Using cached commit data"
            cat "$cache_file"
            return 0
        fi
    fi

    # Get user info
    local user_data
    user_data=$(github_get_user "$username" "$token")

    if [[ $? -ne 0 ]]; then
        log_error "Failed to fetch user data"
        return 1
    fi

    local public_repos
    public_repos=$(echo "$user_data" | jq -r '.public_repos // 0')

    # Get repositories
    local repos_data
    repos_data=$(github_get_repos "$username" "$token")

    if [[ $? -ne 0 ]]; then
        log_error "Failed to fetch repositories"
        return 1
    fi

    local total_commits=0
    local repo_count=0
    local repos_analyzed=()

    # Parse repository names
    local repo_names
    repo_names=$(echo "$repos_data" | jq -r '.[].name' 2>/dev/null)

    if [[ -z "$repo_names" ]]; then
        log_warn "No repositories found or unable to parse response"
        total_commits=0
    else
        # Analyze each repository (limit to 20 to avoid rate limiting)
        local max_repos=20
        while IFS= read -r repo; do
            if (( repo_count >= max_repos )); then
                break
            fi

            log_debug "Checking repository: $repo"

            # Get participation stats (more efficient than counting commits)
            local stats
            stats=$(github_api_request "/repos/${username}/${repo}/stats/participation" "$token" 2>/dev/null)

            if [[ $? -eq 0 && -n "$stats" ]]; then
                local owner_commits
                owner_commits=$(echo "$stats" | jq '[.owner[]] | add // 0' 2>/dev/null)

                if [[ "$owner_commits" != "null" && -n "$owner_commits" ]]; then
                    total_commits=$((total_commits + owner_commits))
                    repos_analyzed+=("$repo:$owner_commits")
                fi
            fi

            ((repo_count++))
            sleep "$API_RATE_LIMIT_PAUSE"
        done <<< "$repo_names"
    fi

    # Create result JSON
    local result
    result=$(jq -n \
        --arg username "$username" \
        --arg total_commits "$total_commits" \
        --arg repos_analyzed "$repo_count" \
        --arg public_repos "$public_repos" \
        --arg brightness "$(get_brightness_from_commits "$total_commits")" \
        '{
            username: $username,
            total_commits: ($total_commits | tonumber),
            repos_analyzed: ($repos_analyzed | tonumber),
            public_repos: ($public_repos | tonumber),
            brightness: ($brightness | tonumber),
            analyzed_at: now | todate
        }')

    # Cache the result
    ensure_dir "$CACHE_DIR"
    echo "$result" > "$cache_file"

    echo "$result"
}

# Get estimated commits using events API (faster alternative)
# Usage: estimate_commits_from_events <username> [token]
estimate_commits_from_events() {
    local username="$1"
    local token="${2:-}"

    log_info "Estimating activity from recent events..."

    local events
    events=$(github_api_request "/users/${username}/events/public?per_page=100" "$token")

    if [[ $? -ne 0 ]]; then
        echo "0"
        return 1
    fi

    # Count PushEvents and estimate commits
    local push_events
    push_events=$(echo "$events" | jq '[.[] | select(.type == "PushEvent")] | length' 2>/dev/null)

    local commit_count
    commit_count=$(echo "$events" | jq '[.[] | select(.type == "PushEvent") | .payload.commits | length] | add // 0' 2>/dev/null)

    # Extrapolate to yearly estimate (events API only returns recent activity)
    local yearly_estimate=$((commit_count * 12))

    echo "$yearly_estimate"
}

# Quick analysis using events API (no rate limiting issues)
# Usage: quick_analyze_user <username> [token]
quick_analyze_user() {
    local username="$1"
    local token="${2:-}"

    # Check cache first
    local cache_file="${CACHE_DIR}/${username}_quick.json"
    if [[ -f "$cache_file" ]]; then
        local cache_age=$(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null || echo 0)))
        if (( cache_age < CACHE_EXPIRY )); then
            log_debug "Using cached quick analysis"
            cat "$cache_file"
            return 0
        fi
    fi

    log_info "Fetching GitHub profile for: $username"

    # Get user info
    local user_data
    user_data=$(github_get_user "$username" "$token")

    if [[ $? -ne 0 ]]; then
        return 1
    fi

    local public_repos followers following
    public_repos=$(echo "$user_data" | jq -r '.public_repos // 0')
    followers=$(echo "$user_data" | jq -r '.followers // 0')
    following=$(echo "$user_data" | jq -r '.following // 0')
    local name
    name=$(echo "$user_data" | jq -r '.name // .login')
    local bio
    bio=$(echo "$user_data" | jq -r '.bio // ""')

    # Estimate commits from events
    local estimated_commits
    estimated_commits=$(estimate_commits_from_events "$username" "$token")

    # Calculate brightness
    local brightness
    brightness=$(get_brightness_from_commits "$estimated_commits")

    # Create result JSON
    local result
    result=$(jq -n \
        --arg username "$username" \
        --arg name "$name" \
        --arg bio "$bio" \
        --arg estimated_commits "$estimated_commits" \
        --arg public_repos "$public_repos" \
        --arg followers "$followers" \
        --arg following "$following" \
        --arg brightness "$brightness" \
        '{
            username: $username,
            name: $name,
            bio: $bio,
            estimated_commits: ($estimated_commits | tonumber),
            public_repos: ($public_repos | tonumber),
            followers: ($followers | tonumber),
            following: ($following | tonumber),
            brightness: ($brightness | tonumber),
            brightness_description: "",
            analyzed_at: now | todate
        }')

    # Add brightness description
    local brightness_desc
    brightness_desc=$(get_brightness_description "$brightness")
    result=$(echo "$result" | jq --arg desc "$brightness_desc" '.brightness_description = $desc')

    # Cache the result
    ensure_dir "$CACHE_DIR"
    echo "$result" > "$cache_file"

    echo "$result"
}

# Display user analysis summary
# Usage: display_analysis_summary <json_data>
display_analysis_summary() {
    local data="$1"

    local username name estimated_commits public_repos followers brightness brightness_desc

    username=$(echo "$data" | jq -r '.username')
    name=$(echo "$data" | jq -r '.name // .username')
    estimated_commits=$(echo "$data" | jq -r '.estimated_commits // .total_commits // 0')
    public_repos=$(echo "$data" | jq -r '.public_repos // 0')
    followers=$(echo "$data" | jq -r '.followers // 0')
    brightness=$(echo "$data" | jq -r '.brightness // 70')
    brightness_desc=$(echo "$data" | jq -r '.brightness_description // "Medium"')

    echo ""
    echo -e "${CLR_BOLD}${CLR_CYAN}GitHub Profile Analysis${CLR_RESET}"
    echo -e "${CLR_DIM}────────────────────────────────────${CLR_RESET}"
    echo -e "  ${CLR_BOLD}User:${CLR_RESET}        $name (@$username)"
    echo -e "  ${CLR_BOLD}Repos:${CLR_RESET}       $public_repos public repositories"
    echo -e "  ${CLR_BOLD}Followers:${CLR_RESET}   $followers"
    echo -e "  ${CLR_BOLD}Activity:${CLR_RESET}    ~$estimated_commits commits (estimated yearly)"
    echo -e "  ${CLR_BOLD}Brightness:${CLR_RESET}  ${brightness}% - $brightness_desc"
    echo -e "${CLR_DIM}────────────────────────────────────${CLR_RESET}"
    echo ""
}
