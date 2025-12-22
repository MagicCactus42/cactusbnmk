#!/bin/bash
# =============================================================================
# CactusBNMK - GitHub Contribution Graph Painter
# =============================================================================
# Creates backdated commits to paint on your GitHub contribution graph
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_COMMIT_PAINTER_SH_LOADED:-}" ]] && return 0
readonly _COMMIT_PAINTER_SH_LOADED=1

# Contribution graph dimensions (52 weeks x 7 days)
readonly GRAPH_WIDTH=52
readonly GRAPH_HEIGHT=7

# =============================================================================
# Pattern Generation for Contribution Graph
# =============================================================================

# Generate a 52x7 pattern array for the contribution graph
# Usage: generate_graph_pattern <theme_id>
# Returns lines of 0s, 1s, 2s (0=no commit, 1=normal, 2=bright)
generate_graph_pattern() {
    local theme_id="$1"

    # Use theme_id directly as pattern name
    local pattern="$theme_id"

    local y x
    for ((y = 0; y < GRAPH_HEIGHT; y++)); do
        local line=""
        for ((x = 0; x < GRAPH_WIDTH; x++)); do
            local show=0

            case "$pattern" in
                "sunset")
                    # Half-circle sun rising from bottom center
                    local sun_cx=$((GRAPH_WIDTH / 2))
                    local sun_cy=$((GRAPH_HEIGHT + 1))
                    local dx=$((x - sun_cx))
                    local dy=$((y - sun_cy))
                    local dist_sq=$((dx * dx + dy * dy))
                    if ((dist_sq <= 25)); then
                        show=2
                    elif ((dist_sq <= 50)); then
                        show=1
                    fi
                    ;;

                "saturn")
                    # Saturn with tilted horizontal ring and stars
                    local cx=$((GRAPH_WIDTH / 2))
                    local dx=$((x - cx))
                    local abs_dx=$(( dx < 0 ? -dx : dx ))

                    # Planet body (rows 1-5, oval shape)
                    if ((y == 1 && abs_dx <= 2)); then
                        show=2
                    elif ((y == 2 && abs_dx <= 3)); then
                        show=2
                    elif ((y == 3 && abs_dx <= 4)); then
                        show=2
                    elif ((y == 4 && abs_dx <= 3)); then
                        show=2
                    elif ((y == 5 && abs_dx <= 2)); then
                        show=2
                    # Ring: left part (tilts down at far left)
                    elif ((y == 4 && dx >= -12 && dx <= -10)); then
                        show=1
                    elif ((y == 3 && dx >= -9 && dx <= -5)); then
                        show=1
                    # Ring: right part (tilts up at far right)
                    elif ((y == 3 && dx >= 5 && dx <= 9)); then
                        show=1
                    elif ((y == 2 && dx >= 10 && dx <= 12)); then
                        show=1
                    # Stars in empty space
                    elif (( (x * 17 + y * 31) % 23 == 0 )); then
                        show=1
                    fi
                    ;;

                "heart")
                    # Heart shape centered
                    local cx=$((GRAPH_WIDTH / 2))
                    # Heart pattern using math
                    local hx=$((x - cx))
                    # Normalize to heart coordinates
                    if ((y == 0)); then
                        show=$(( (hx >= -4 && hx <= -2) || (hx >= 2 && hx <= 4) ? 1 : 0 ))
                    elif ((y == 1)); then
                        show=$(( (hx >= -5 && hx <= -1) || (hx >= 1 && hx <= 5) ? 2 : 0 ))
                    elif ((y == 2)); then
                        show=$(( (hx >= -6 && hx <= 6) ? 2 : 0 ))
                    elif ((y == 3)); then
                        show=$(( (hx >= -5 && hx <= 5) ? 2 : 0 ))
                    elif ((y == 4)); then
                        show=$(( (hx >= -4 && hx <= 4) ? 1 : 0 ))
                    elif ((y == 5)); then
                        show=$(( (hx >= -2 && hx <= 2) ? 1 : 0 ))
                    elif ((y == 6)); then
                        show=$(( (hx >= -1 && hx <= 1) ? 1 : 0 ))
                    fi
                    ;;

                "pacman")
                    # Pacman on left eating dots
                    local pac_cx=8
                    local pac_cy=3
                    local dx=$((x - pac_cx))
                    local dy=$((y - pac_cy))
                    local dist_sq=$((dx * dx + dy * dy))

                    # Pacman body (circle with mouth)
                    if ((dist_sq <= 9)); then
                        # Mouth opening (wedge on right side)
                        if ((dx > 0 && dy >= -1 && dy <= 1)); then
                            show=0  # Mouth
                        else
                            show=2  # Body
                        fi
                    fi

                    # Dots being eaten (to the right of pacman)
                    if ((y == 3 && x > 14 && (x % 4) == 0)); then
                        show=1
                    fi
                    ;;

                "wave")
                    # Smooth sine wave
                    # sin approximation: peaks at x%12 == 0, troughs at x%12 == 6
                    local phase=$((x % 12))
                    local wave_y
                    if ((phase <= 3)); then
                        wave_y=$((3 - phase))
                    elif ((phase <= 9)); then
                        wave_y=$((phase - 3))
                    else
                        wave_y=$((15 - phase))
                    fi

                    if ((y == wave_y)); then
                        show=2
                    elif ((y == wave_y + 1 || y == wave_y - 1)); then
                        show=1
                    fi
                    ;;

                "lightning")
                    # Zigzag lightning bolt from top-left to bottom-right
                    local bolt_x=$((y * 7 + (y % 2) * 3))
                    if ((x >= bolt_x && x <= bolt_x + 2)); then
                        show=2
                    elif ((x >= bolt_x - 1 && x <= bolt_x + 3)); then
                        show=1
                    fi
                    ;;

                "galaxy")
                    # Spiral galaxy with center and arms
                    local cx=$((GRAPH_WIDTH / 2))
                    local cy=3
                    local dx=$((x - cx))
                    local dy=$((y - cy))
                    local dist_sq=$((dx * dx + dy * dy))

                    # Bright center
                    if ((dist_sq <= 4)); then
                        show=2
                    # Spiral arms (approximated)
                    elif ((dist_sq <= 100)); then
                        local angle_approx=$(( (dx + dy * 3) ))
                        local spiral=$(( (angle_approx + dist_sq / 3) % 8 ))
                        if ((spiral <= 2)); then
                            show=1
                        fi
                    fi
                    # Random stars
                    local noise=$(( (x * 374761 + y * 668265) % 100 ))
                    if ((noise > 92 && show == 0)); then
                        show=1
                    fi
                    ;;

                "matrix")
                    # Falling code - vertical streams
                    local col_active=$(( (x * 2654435761) % 100 ))
                    if ((col_active > 60)); then
                        local drop_pos=$(( (x * 123 + 456) % 7 ))
                        if ((y <= drop_pos)); then
                            show=$(( y == drop_pos ? 2 : 1 ))
                        fi
                    fi
                    ;;

                "cactus")
                    # Cactus shape - fitting for the app!
                    local cx=$((GRAPH_WIDTH / 2))
                    local dx=$((x - cx))

                    # Main stem
                    if ((dx >= -1 && dx <= 1)); then
                        show=$(( y >= 1 ? 2 : 0 ))
                    fi
                    # Left arm
                    if ((y >= 2 && y <= 4 && dx >= -5 && dx <= -2)); then
                        show=1
                    fi
                    if ((y >= 1 && y <= 2 && dx == -5)); then
                        show=1
                    fi
                    # Right arm
                    if ((y >= 3 && y <= 5 && dx >= 2 && dx <= 4)); then
                        show=1
                    fi
                    if ((y >= 2 && y <= 3 && dx == 4)); then
                        show=1
                    fi
                    ;;

                "diamond")
                    # Diamond shape in center
                    local cx=$((GRAPH_WIDTH / 2))
                    local cy=3
                    local dx=$((x - cx))
                    local dy=$((y - cy))
                    # Diamond: |dx| + |dy| <= radius
                    local abs_dx=$(( dx < 0 ? -dx : dx ))
                    local abs_dy=$(( dy < 0 ? -dy : dy ))
                    local manhattan=$((abs_dx + abs_dy * 2))

                    if ((manhattan <= 4)); then
                        show=2
                    elif ((manhattan <= 8)); then
                        show=1
                    fi
                    ;;

                "chess")
                    # Checkerboard pattern
                    show=$(( (x + y) % 2 ))
                    ;;

                "invaders")
                    # Space invader alien shape
                    local cx=$((GRAPH_WIDTH / 2))
                    local dx=$((x - cx))
                    local abs_dx=$(( dx < 0 ? -dx : dx ))

                    case $y in
                        0) show=$(( abs_dx == 2 || abs_dx == 3 ? 1 : 0 )) ;;
                        1) show=$(( abs_dx <= 5 ? 2 : 0 )) ;;
                        2) show=$(( abs_dx <= 6 && abs_dx != 2 ? 2 : 0 )) ;;
                        3) show=$(( abs_dx <= 6 ? 1 : 0 )) ;;
                        4) show=$(( abs_dx == 1 || abs_dx == 3 || abs_dx == 5 ? 1 : 0 )) ;;
                        5) show=$(( abs_dx == 2 || abs_dx == 4 ? 1 : 0 )) ;;
                        6) show=$(( abs_dx == 1 || abs_dx == 2 ? 1 : 0 )) ;;
                    esac
                    ;;

                *)
                    # Default: random scatter
                    local noise=$(( (x * 374761393 + y * 668265263) % 100 ))
                    show=$(( noise > 60 ? 1 : 0 ))
                    ;;
            esac

            line+="$show"
        done
        echo "$line"
    done
}

# =============================================================================
# GitHub Activity Analysis
# =============================================================================

# Analyze GitHub user's contribution activity to determine optimal brightness
# Returns recommended commits per cell
analyze_github_activity() {
    local username="$1"

    if [[ -z "$username" ]]; then
        echo "5"  # Default
        return
    fi

    echo "Analyzing @${username}'s GitHub activity..." >&2

    local commits_per_cell=5
    local auto_detected=0

    # Try using gh CLI first (most reliable)
    if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
        # Get user's contribution stats from the last year
        local contrib_data
        contrib_data=$(gh api graphql -f query='
            query($username: String!) {
                user(login: $username) {
                    contributionsCollection {
                        contributionCalendar {
                            totalContributions
                            weeks {
                                contributionDays {
                                    contributionCount
                                }
                            }
                        }
                    }
                }
            }
        ' -f username="$username" 2>/dev/null)

        if [[ -n "$contrib_data" ]]; then
            local total
            total=$(echo "$contrib_data" | grep -o '"totalContributions":[0-9]*' | grep -o '[0-9]*')

            if [[ -n "$total" && "$total" -gt 0 ]]; then
                auto_detected=1

                # Find max contribution day for intensity reference
                local max_day=0
                local counts
                counts=$(echo "$contrib_data" | grep -o '"contributionCount":[0-9]*' | grep -o '[0-9]*')
                for count in $counts; do
                    ((count > max_day)) && max_day=$count
                done

                echo "  Total contributions (last year): $total" >&2
                echo "  Max in single day: $max_day" >&2

                # Calculate commits per cell to make art visible
                # We want our art to be at ~70% of their max intensity
                if ((max_day > 0)); then
                    commits_per_cell=$(( (max_day * 7) / 10 ))
                    ((commits_per_cell < 3)) && commits_per_cell=3
                    ((commits_per_cell > 50)) && commits_per_cell=50
                fi
            fi
        fi
    fi

    # Fallback: ask user directly
    if ((auto_detected == 0)); then
        echo "" >&2
        echo "  Could not auto-detect activity (install 'gh' CLI for auto-detection)" >&2
        echo "" >&2
        echo "  How active are you on GitHub?" >&2
        echo "    1) Light    - Few commits per week" >&2
        echo "    2) Moderate - Several commits per week" >&2
        echo "    3) Active   - Daily commits" >&2
        echo "    4) Heavy    - Many commits daily" >&2
        echo "" >&2

        local activity_level
        read -p "  Select (1-4) [2]: " activity_level
        activity_level="${activity_level:-2}"

        case "$activity_level" in
            1) commits_per_cell=3 ;;
            2) commits_per_cell=8 ;;
            3) commits_per_cell=15 ;;
            4) commits_per_cell=25 ;;
            *) commits_per_cell=8 ;;
        esac
    fi

    echo "  Brightness: $commits_per_cell commits per cell" >&2
    echo "" >&2
    echo "$commits_per_cell"
}

# Fetch user's existing contribution data for each day
# Populates global associative array EXISTING_CONTRIBUTIONS with date -> count
declare -gA EXISTING_CONTRIBUTIONS

fetch_existing_contributions() {
    local username="$1"

    # Clear existing data
    EXISTING_CONTRIBUTIONS=()

    if [[ -z "$username" ]]; then
        return 1
    fi

    if ! command -v gh &>/dev/null || ! gh auth status &>/dev/null 2>&1; then
        return 1
    fi

    echo "Fetching existing contribution data for @${username}..."

    # Get detailed contribution data with dates
    local contrib_data
    contrib_data=$(gh api graphql -f query='
        query($username: String!) {
            user(login: $username) {
                contributionsCollection {
                    contributionCalendar {
                        weeks {
                            contributionDays {
                                date
                                contributionCount
                            }
                        }
                    }
                }
            }
        }
    ' -f username="$username" 2>/dev/null)

    if [[ -z "$contrib_data" ]]; then
        echo "  Could not fetch contribution data"
        return 1
    fi

    # Parse the JSON and populate the array
    # Extract date and count pairs
    local dates counts
    dates=$(echo "$contrib_data" | grep -o '"date":"[0-9-]*"' | grep -o '[0-9-]*')
    counts=$(echo "$contrib_data" | grep -o '"contributionCount":[0-9]*' | grep -o '[0-9]*$')

    # Convert to arrays
    local -a date_arr count_arr
    readarray -t date_arr <<< "$dates"
    readarray -t count_arr <<< "$counts"

    # Populate associative array
    local i
    for ((i = 0; i < ${#date_arr[@]}; i++)); do
        if [[ -n "${date_arr[$i]}" ]]; then
            EXISTING_CONTRIBUTIONS["${date_arr[$i]}"]="${count_arr[$i]:-0}"
        fi
    done

    local total_days=${#EXISTING_CONTRIBUTIONS[@]}
    echo "  Loaded $total_days days of contribution history"

    return 0
}

# Get existing contribution count for a specific date
get_existing_count() {
    local date="$1"
    # Extract just the date part (YYYY-MM-DD) from the full datetime
    local date_only="${date%% *}"
    echo "${EXISTING_CONTRIBUTIONS[$date_only]:-0}"
}

# =============================================================================
# Date Calculations
# =============================================================================

# Get the date for a specific cell in the contribution graph
# For "current" mode: last 52 weeks from today
# For "previous" mode: 52 weeks of a specific year
# x = week (0-51, 0 is oldest)
# y = day of week (0=Sunday, 6=Saturday)
get_cell_date() {
    local x="$1"
    local y="$2"
    local mode="${3:-current}"
    local target_year="${4:-}"

    local target_ts

    if [[ "$mode" == "previous" && -n "$target_year" ]]; then
        # For previous mode: calculate date within the target year
        # Start from Dec 31 of target year, go back
        local dec31_ts
        if date -d "${target_year}-12-31" +%s 2>/dev/null; then
            dec31_ts=$(date -d "${target_year}-12-31" +%s 2>/dev/null)
        elif date -j -f "%Y-%m-%d" "${target_year}-12-31" +%s 2>/dev/null; then
            dec31_ts=$(date -j -f "%Y-%m-%d" "${target_year}-12-31" +%s 2>/dev/null)
        else
            # Fallback calculation
            dec31_ts=$(( (target_year - 1970) * 31536000 + 31536000 - 86400 ))
        fi

        # Get day of week for Dec 31
        local dec31_dow
        if date -d "${target_year}-12-31" +%w 2>/dev/null; then
            dec31_dow=$(date -d "${target_year}-12-31" +%w 2>/dev/null)
        elif date -j -f "%Y-%m-%d" "${target_year}-12-31" +%w 2>/dev/null; then
            dec31_dow=$(date -j -f "%Y-%m-%d" "${target_year}-12-31" +%w 2>/dev/null)
        else
            dec31_dow=0
        fi

        local weeks_ago=$((GRAPH_WIDTH - 1 - x))
        local days_back=$((weeks_ago * 7 + (dec31_dow - y)))

        if ((days_back < 0)); then
            days_back=0
        fi

        target_ts=$((dec31_ts - days_back * 86400))
    else
        # Current mode: last 52 weeks from today
        local today
        today=$(date +%s)
        local day_of_week
        day_of_week=$(date +%w)  # 0=Sunday

        local weeks_ago=$((GRAPH_WIDTH - 1 - x))
        local days_back=$((weeks_ago * 7 + (day_of_week - y)))

        if ((days_back < 0)); then
            days_back=0
        fi

        target_ts=$((today - days_back * 86400))
    fi

    # Return in git-compatible format
    if date -d "@$target_ts" "+%Y-%m-%d 12:00:00" 2>/dev/null; then
        return 0
    elif date -r "$target_ts" "+%Y-%m-%d 12:00:00" 2>/dev/null; then
        return 0
    else
        # Fallback: calculate manually
        local days_since_epoch=$((target_ts / 86400))
        local year=$((1970 + days_since_epoch / 365))
        local remaining=$((days_since_epoch % 365))
        local month=$(( (remaining / 30) + 1 ))
        ((month > 12)) && month=12
        local day=$(( (remaining % 30) + 1 ))
        ((day > 28)) && day=28

        printf "%04d-%02d-%02d 12:00:00" "$year" "$month" "$day"
    fi
}

# Get today's position in the contribution graph
get_today_position() {
    local day_of_week
    day_of_week=$(date +%w)  # 0=Sunday, 6=Saturday

    # Today is at x=51 (last week), y=day_of_week
    echo "$((GRAPH_WIDTH - 1)) $day_of_week"
}

# =============================================================================
# Commit Generation
# =============================================================================

# Initialize a new repository for the contribution graph
init_paint_repo() {
    local repo_dir="$1"

    if [[ -d "$repo_dir" ]]; then
        echo "Directory $repo_dir already exists!"
        return 1
    fi

    mkdir -p "$repo_dir"
    cd "$repo_dir" || return 1
    git init --quiet
    git config core.autocrlf false  # Suppress CRLF warnings
    echo "# Contribution Graph Art" > README.md
    echo "Generated by CACTUS" >> README.md
    git add README.md
    git commit -m "Initial commit" --quiet

    echo "Repository initialized at: $repo_dir"
}

# Create commits for a specific pattern
# Usage: paint_commits <repo_dir> <theme_id> <mode> [target_year] [commits_per_cell] [github_username]
paint_commits() {
    local repo_dir="$1"
    local theme_id="$2"
    local mode="${3:-current}"
    local target_year="${4:-}"
    local commits_per_cell="${5:-5}"
    local github_username="${6:-}"

    if [[ ! -d "$repo_dir/.git" ]]; then
        echo "Error: $repo_dir is not a git repository"
        return 1
    fi

    cd "$repo_dir" || return 1

    # Calculate background and foreground commits
    local bg_target=$((commits_per_cell / 2))
    local fg_commits=$((commits_per_cell - bg_target))
    ((bg_target < 1)) && bg_target=1

    # Try to fetch existing contributions for smooth background
    local has_existing_data=0
    if [[ -n "$github_username" && "$mode" == "current" ]]; then
        if fetch_existing_contributions "$github_username"; then
            has_existing_data=1
        fi
    fi

    echo ""
    echo "Theme: $theme_id"
    echo "Mode: $mode"
    [[ "$mode" == "previous" ]] && echo "Target year: $target_year"
    echo ""
    echo "Background target: $bg_target commits per cell"
    if ((has_existing_data)); then
        echo "  (adjusting for existing contributions to create smooth background)"
    fi
    echo "Foreground: +$fg_commits commits per cell (pattern only)"
    echo "Total for pattern cells: $commits_per_cell commits"
    echo ""

    # Generate the pattern
    local -a pattern_lines
    while IFS= read -r line; do
        pattern_lines+=("$line")
    done < <(generate_graph_pattern "$theme_id")

    local total_commits=0
    local skipped_commits=0
    local y x

    # === PASS 1: Background layer (all cells) ===
    echo "Pass 1/2: Creating background layer..."
    for ((y = 0; y < GRAPH_HEIGHT; y++)); do
        for ((x = 0; x < GRAPH_WIDTH; x++)); do
            local commit_date
            commit_date=$(get_cell_date "$x" "$y" "$mode" "$target_year")

            if [[ -z "$commit_date" ]]; then
                continue
            fi

            # Calculate how many background commits to add
            local bg_commits_needed=$bg_target

            if ((has_existing_data)); then
                local existing_count
                existing_count=$(get_existing_count "$commit_date")

                if ((existing_count >= bg_target)); then
                    # Already at or above target, skip this cell
                    skipped_commits=$((skipped_commits + bg_target))
                    continue
                else
                    # Only add enough to reach target
                    bg_commits_needed=$((bg_target - existing_count))
                fi
            fi

            for ((c = 0; c < bg_commits_needed; c++)); do
                echo "$commit_date - bg $c" >> data.txt
                git add data.txt
                GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" \
                    git commit -m "bg: $x,$y ($c)" --quiet
                total_commits=$((total_commits + 1))
            done
        done
        echo "  Background row $((y+1))/$GRAPH_HEIGHT"
    done

    if ((skipped_commits > 0)); then
        echo "  (skipped $skipped_commits commits - cells already at target level)"
    fi

    # === PASS 2: Foreground layer (pattern cells only) ===
    echo ""
    echo "Pass 2/2: Creating pattern layer..."
    for ((y = 0; y < GRAPH_HEIGHT; y++)); do
        local line="${pattern_lines[$y]}"
        for ((x = 0; x < GRAPH_WIDTH; x++)); do
            local cell="${line:$x:1}"

            if [[ "$cell" != "0" ]]; then
                local commit_date
                commit_date=$(get_cell_date "$x" "$y" "$mode" "$target_year")

                if [[ -z "$commit_date" ]]; then
                    continue
                fi

                # Extra commits for pattern - more for bright cells
                local num_commits=$fg_commits
                ((cell == 2)) && num_commits=$((fg_commits * 2))

                for ((c = 0; c < num_commits; c++)); do
                    echo "$commit_date - fg $c" >> data.txt
                    git add data.txt
                    GIT_AUTHOR_DATE="$commit_date" GIT_COMMITTER_DATE="$commit_date" \
                        git commit -m "fg: $x,$y ($c)" --quiet
                    total_commits=$((total_commits + 1))
                done
            fi
        done
        echo "  Pattern row $((y+1))/$GRAPH_HEIGHT"
    done

    echo ""
    echo "Total commits created: $total_commits"
}

# Add daily commit if pattern requires it (for cronjob)
# Usage: daily_commit <repo_dir> <theme_id> [commits_per_cell]
daily_commit() {
    local repo_dir="$1"
    local theme_id="$2"
    local commits_per_cell="${3:-5}"

    if [[ ! -d "$repo_dir/.git" ]]; then
        echo "Error: $repo_dir is not a git repository"
        return 1
    fi

    cd "$repo_dir" || return 1

    # Get today's position
    local today_pos
    today_pos=$(get_today_position)
    local x="${today_pos% *}"
    local y="${today_pos#* }"

    # Generate pattern and check today's cell
    local -a pattern_lines
    while IFS= read -r line; do
        pattern_lines+=("$line")
    done < <(generate_graph_pattern "$theme_id")

    local line="${pattern_lines[$y]}"
    local cell="${line:$x:1}"

    if [[ "$cell" == "0" ]]; then
        echo "No commit needed for today (pattern has no activity for this day)"
        return 0
    fi

    local commit_date
    commit_date=$(date "+%Y-%m-%d 12:00:00")

    local num_commits=$commits_per_cell
    ((cell == 2)) && num_commits=$((commits_per_cell * 2))

    echo "Adding $num_commits commit(s) for today..."

    for ((c = 0; c < num_commits; c++)); do
        echo "$commit_date - daily commit $c" >> data.txt
        git add data.txt
        git commit -m "daily: $(date +%Y-%m-%d) ($c)" --quiet
    done

    echo "Done! Push to GitHub: git push"
}

# Preview what the pattern will look like
preview_graph_pattern() {
    local theme_id="$1"

    echo ""
    echo "Preview for theme: $theme_id"
    echo "$(printf '═%.0s' {1..52})"

    local -a pattern_lines
    while IFS= read -r line; do
        pattern_lines+=("$line")
    done < <(generate_graph_pattern "$theme_id")

    for ((y = 0; y < GRAPH_HEIGHT; y++)); do
        local line="${pattern_lines[$y]}"
        local display=""
        for ((x = 0; x < GRAPH_WIDTH; x++)); do
            local cell="${line:$x:1}"
            if [[ "$cell" == "0" ]]; then
                display+=" "
            elif [[ "$cell" == "2" ]]; then
                display+="█"
            else
                display+="▓"
            fi
        done
        echo "$display"
    done

    echo "$(printf '═%.0s' {1..52})"
    echo ""
}

# =============================================================================
# Main Paint Command
# =============================================================================

# Full paint workflow
# Usage: run_paint_workflow <theme_id> <mode> [year_for_previous|brightness] [brightness]
run_paint_workflow() {
    local theme_id="$1"
    local mode="${2:-}"
    local arg3="${3:-}"
    local arg4="${4:-}"

    echo ""
    echo "=== GitHub Contribution Graph Painter ==="
    echo ""

    if [[ -z "$theme_id" ]]; then
        echo "Usage: paint <theme> <mode> [brightness]"
        echo ""
        echo "Modes:"
        echo "  current   - Paint on the last 365 days (visible now)"
        echo "  previous  - Paint on a past year (e.g., 2022)"
        echo ""
        echo "Brightness levels:"
        echo "  light     - Few commits (3 per cell)"
        echo "  medium    - Moderate (8 per cell)"
        echo "  high      - Visible (15 per cell)"
        echo "  heavy     - Very bright (25 per cell)"
        echo ""
        echo "Examples:"
        echo "  paint sunset current"
        echo "  paint pacman current heavy"
        echo "  paint galaxy previous 2022"
        echo "  paint heart previous 2023 high"
        echo ""
        return 1
    fi

    # Parse arguments based on mode
    local target_year=""
    local brightness_arg=""

    if [[ "$mode" == "previous" ]]; then
        target_year="$arg3"
        brightness_arg="$arg4"
    else
        brightness_arg="$arg3"
    fi

    # GitHub username for smooth background (will be set if user provides it)
    local github_username=""

    # Determine commits per cell from brightness argument or ask
    local commits_per_cell=0

    case "$brightness_arg" in
        light|low|1)
            commits_per_cell=3
            echo "Brightness: light (3 commits per cell)"
            ;;
        medium|moderate|med|2)
            commits_per_cell=8
            echo "Brightness: medium (8 commits per cell)"
            ;;
        high|active|3)
            commits_per_cell=15
            echo "Brightness: high (15 commits per cell)"
            ;;
        heavy|max|bright|4)
            commits_per_cell=25
            echo "Brightness: heavy (25 commits per cell)"
            ;;
        "")
            # No brightness specified - ask for username or activity level
            echo "To make your art visible, we'll analyze your GitHub activity."
            echo "(Or specify brightness: paint $theme_id $mode light|medium|high|heavy)"
            echo ""
            read -p "Enter your GitHub username (or press Enter to choose manually): " github_username

            if [[ -n "$github_username" ]]; then
                commits_per_cell=$(analyze_github_activity "$github_username")
            else
                commits_per_cell=$(analyze_github_activity "")
            fi
            ;;
        *)
            echo "Unknown brightness level: $brightness_arg"
            echo "Use: light, medium, high, or heavy"
            return 1
            ;;
    esac

    # If brightness was specified directly but we don't have username yet, ask for it
    # This enables smooth background even with manual brightness
    if [[ -z "$github_username" && "$mode" == "current" ]]; then
        echo ""
        echo "For a smooth background, enter your GitHub username."
        echo "(This adjusts for your existing contributions)"
        read -p "GitHub username (or Enter to skip): " github_username
    fi

    if [[ -z "$mode" ]]; then
        echo ""
        echo "Please specify a mode: current or previous"
        echo ""
        echo "  current  - Last 365 days (visible on your profile now)"
        echo "  previous - A past year (specify year, e.g., 2022)"
        echo ""
        read -p "Mode (current/previous): " mode
    fi

    if [[ "$mode" != "current" && "$mode" != "previous" ]]; then
        echo "Invalid mode. Use 'current' or 'previous'"
        return 1
    fi

    if [[ "$mode" == "previous" && -z "$target_year" ]]; then
        read -p "Enter target year (e.g., 2022): " target_year
        if [[ ! "$target_year" =~ ^[0-9]{4}$ ]]; then
            echo "Invalid year format"
            return 1
        fi
    fi

    echo ""

    # Preview first
    preview_graph_pattern "$theme_id"

    local repo_name="github-banner"
    [[ "$mode" == "previous" ]] && repo_name="github-banner-${target_year}"

    echo "Mode: $mode"
    [[ "$mode" == "previous" ]] && echo "Target year: $target_year"
    echo "Commits per cell: $commits_per_cell"
    echo ""
    echo "This will create a repository '$repo_name' with backdated commits."
    echo "The commits will appear on your GitHub contribution graph."
    echo ""

    read -p "Continue? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Cancelled."
        return 0
    fi

    local repo_dir="${OUTPUT_DIR:-./output}/$repo_name"

    # Check if repo exists
    if [[ -d "$repo_dir" ]]; then
        echo ""
        echo "Repository already exists at: $repo_dir"
        read -p "Delete and recreate? (y/n): " delete_confirm
        if [[ "$delete_confirm" == "y" || "$delete_confirm" == "Y" ]]; then
            rm -rf "$repo_dir"
        else
            echo "Cancelled."
            return 0
        fi
    fi

    echo ""
    echo "Creating repository at: $repo_dir"

    init_paint_repo "$repo_dir"
    paint_commits "$repo_dir" "$theme_id" "$mode" "$target_year" "$commits_per_cell" "$github_username"

    echo ""
    echo "=== Commits Created! ==="
    echo ""

    # Check if gh CLI is available for auto-push
    if command -v gh &>/dev/null; then
        echo "GitHub CLI detected. Auto-pushing to GitHub..."
        echo ""

        cd "$repo_dir" || return 1

        # Create GitHub repo and push
        if gh repo create "$repo_name" --public --source=. --push 2>/dev/null; then
            echo ""
            echo "=== Success! ==="
            echo "Repository created and pushed to GitHub!"
            echo ""
            gh repo view --web 2>/dev/null || echo "Visit: https://github.com/$(gh api user -q .login)/$repo_name"
            echo ""
            if [[ "$mode" == "current" ]]; then
                echo "To keep the banner updated, set up a daily cronjob."
                echo "See README.md for instructions."
            fi
        else
            echo "Auto-push failed. The repo might already exist."
            echo ""
            echo "Try manually:"
            echo "  cd $repo_dir"
            echo "  gh repo create $repo_name --public --source=. --push"
        fi
    else
        echo "To use this on GitHub:"
        echo ""
        echo "Option 1: Install GitHub CLI (gh) for automatic setup"
        echo "  https://cli.github.com/"
        echo ""
        echo "Option 2: Manual setup:"
        echo "  1. Create a NEW public repository on GitHub named: $repo_name"
        echo "  2. Run these commands:"
        echo ""
        echo "     cd $repo_dir"
        echo "     git remote add origin https://github.com/YOUR_USERNAME/$repo_name.git"
        echo "     git branch -M main"
        echo "     git push -u origin main"
    fi
    echo ""
}

# Clean/remove banner from GitHub
# Deletes both local and remote repositories
run_clean_workflow() {
    local repo_name="${1:-github-banner}"

    echo ""
    echo "=== Clean Banner ==="
    echo ""
    echo "This will remove the banner from your GitHub contribution graph by"
    echo "deleting the repository '$repo_name'."
    echo ""

    local repo_dir="${OUTPUT_DIR:-./output}/$repo_name"
    local has_local=0
    local has_remote=0

    # Check what exists
    if [[ -d "$repo_dir" ]]; then
        has_local=1
        echo "Found local repo: $repo_dir"
    fi

    if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
        local gh_user
        gh_user=$(gh api user -q .login 2>/dev/null)
        if [[ -n "$gh_user" ]] && gh repo view "$gh_user/$repo_name" &>/dev/null 2>&1; then
            has_remote=1
            echo "Found remote repo: github.com/$gh_user/$repo_name"
        fi
    fi

    if ((has_local == 0 && has_remote == 0)); then
        echo "No banner repository found to clean."
        echo ""
        echo "Looking for: $repo_name"
        echo "  Local:  $repo_dir"
        if command -v gh &>/dev/null; then
            echo "  Remote: github.com/$(gh api user -q .login 2>/dev/null)/$repo_name"
        fi
        return 1
    fi

    echo ""
    echo "WARNING: This action cannot be undone!"
    echo "Your contribution graph will return to its original state."
    echo ""

    read -p "Delete '$repo_name' and restore contribution graph? (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        echo "Cancelled."
        return 0
    fi

    # Delete remote first (if exists)
    if ((has_remote == 1)); then
        echo ""
        echo "Deleting remote repository..."
        if gh repo delete "$repo_name" --yes 2>/dev/null; then
            echo "Remote repository deleted."
        else
            echo "Failed to delete remote. You may need to delete it manually on GitHub."
        fi
    fi

    # Delete local
    if ((has_local == 1)); then
        echo ""
        echo "Deleting local repository..."
        rm -rf "$repo_dir"
        echo "Local repository deleted."
    fi

    echo ""
    echo "=== Done! ==="
    echo ""
    echo "The banner has been removed. Your contribution graph will update"
    echo "within a few minutes to show your original activity."
    echo ""
}

# Daily maintenance workflow (for cronjob)
run_daily_workflow() {
    local repo_dir="${1:-}"
    local theme_id="${2:-}"

    if [[ -z "$repo_dir" || -z "$theme_id" ]]; then
        echo "Usage: cactusbnmk --daily <repo_dir> <theme>"
        echo ""
        echo "Example:"
        echo "  cactusbnmk --daily ./output/github-banner sunset"
        return 1
    fi

    if [[ ! -d "$repo_dir/.git" ]]; then
        echo "Error: $repo_dir is not a git repository"
        return 1
    fi

    daily_commit "$repo_dir" "$theme_id" 5

    # Auto-push if remote is configured
    cd "$repo_dir" || return 1
    if git remote get-url origin &>/dev/null; then
        echo "Pushing to remote..."
        git push --quiet
        echo "Done!"
    else
        echo "No remote configured. Push manually: cd $repo_dir && git push"
    fi
}
