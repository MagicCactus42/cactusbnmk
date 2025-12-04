#!/bin/bash
# =============================================================================
# CactusBNMK - Utility Functions Module
# =============================================================================
# Common utility functions used across the application
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_UTILS_SH_LOADED:-}" ]] && return 0
readonly _UTILS_SH_LOADED=1

# Get script directory
_UTILS_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source colors if not already loaded
source "${_UTILS_SCRIPT_DIR}/lib/colors.sh"

# =============================================================================
# Logging Functions
# =============================================================================

# Log levels
readonly LOG_DEBUG=0
readonly LOG_INFO=1
readonly LOG_WARN=2
readonly LOG_ERROR=3

# Current log level (can be overridden)
LOG_LEVEL="${LOG_LEVEL:-$LOG_INFO}"

# Log a debug message
log_debug() {
    [[ "$LOG_LEVEL" -le "$LOG_DEBUG" ]] && echo -e "${CLR_DIM}[DEBUG] $*${CLR_RESET}" >&2
}

# Log an info message
log_info() {
    [[ "$LOG_LEVEL" -le "$LOG_INFO" ]] && echo -e "${CLR_CYAN}[INFO]${CLR_RESET} $*" >&2
}

# Log a warning message
log_warn() {
    [[ "$LOG_LEVEL" -le "$LOG_WARN" ]] && echo -e "${CLR_YELLOW}[WARN]${CLR_RESET} $*" >&2
}

# Log an error message
log_error() {
    [[ "$LOG_LEVEL" -le "$LOG_ERROR" ]] && echo -e "${CLR_RED}[ERROR]${CLR_RESET} $*" >&2
}

# Log a success message
log_success() {
    echo -e "${CLR_GREEN}[OK]${CLR_RESET} $*" >&2
}

# =============================================================================
# Validation Functions
# =============================================================================

# Check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Validate GitHub username format
validate_github_username() {
    local username="$1"
    # GitHub usernames: alphanumeric, hyphens, 1-39 chars, no leading hyphen
    [[ "$username" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]{0,37}[a-zA-Z0-9])?$ ]]
}

# Check if string is a positive integer
is_positive_integer() {
    [[ "$1" =~ ^[1-9][0-9]*$ ]]
}

# Check if string is a valid percentage (0-100)
is_valid_percentage() {
    [[ "$1" =~ ^(100|[0-9]{1,2})$ ]]
}

# =============================================================================
# String Functions
# =============================================================================

# Trim whitespace from string
trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

# Convert string to uppercase
to_upper() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Convert string to lowercase
to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Pad string to specified length
pad_string() {
    local str="$1"
    local length="$2"
    local char="${3:- }"
    local side="${4:-right}"

    local current_len=${#str}
    local padding=$((length - current_len))

    if (( padding <= 0 )); then
        echo "$str"
        return
    fi

    local pad=""
    for ((i = 0; i < padding; i++)); do
        pad+="$char"
    done

    if [[ "$side" == "left" ]]; then
        echo "${pad}${str}"
    else
        echo "${str}${pad}"
    fi
}

# Center string in given width
center_string() {
    local str="$1"
    local width="$2"
    local str_len=${#str}

    if (( str_len >= width )); then
        echo "$str"
        return
    fi

    local padding=$(( (width - str_len) / 2 ))
    local left_pad=""
    local right_pad=""

    for ((i = 0; i < padding; i++)); do
        left_pad+=" "
    done

    local remaining=$((width - str_len - padding))
    for ((i = 0; i < remaining; i++)); do
        right_pad+=" "
    done

    echo "${left_pad}${str}${right_pad}"
}

# Truncate string with ellipsis
truncate() {
    local str="$1"
    local max_len="$2"

    if (( ${#str} > max_len )); then
        echo "${str:0:$((max_len-3))}..."
    else
        echo "$str"
    fi
}

# =============================================================================
# Array Functions
# =============================================================================

# Check if array contains element
array_contains() {
    local element="$1"
    shift
    local arr=("$@")

    for item in "${arr[@]}"; do
        [[ "$item" == "$element" ]] && return 0
    done
    return 1
}

# Join array elements with delimiter
array_join() {
    local delimiter="$1"
    shift
    local first="$1"
    shift

    printf '%s' "$first"
    printf '%s' "${@/#/$delimiter}"
}

# =============================================================================
# File Functions
# =============================================================================

# Ensure directory exists
ensure_dir() {
    local dir="$1"
    [[ -d "$dir" ]] || mkdir -p "$dir"
}

# Get file size in human-readable format
file_size_human() {
    local file="$1"
    if [[ -f "$file" ]]; then
        ls -lh "$file" | awk '{print $5}'
    else
        echo "0"
    fi
}

# =============================================================================
# Date/Time Functions
# =============================================================================

# Get current timestamp
timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

# Get date N days ago in ISO format
date_days_ago() {
    local days="$1"
    date -d "$days days ago" +"%Y-%m-%d" 2>/dev/null || \
    date -v-"${days}"d +"%Y-%m-%d" 2>/dev/null
}

# Get year ago date
year_ago() {
    date -d "1 year ago" +"%Y-%m-%d" 2>/dev/null || \
    date -v-1y +"%Y-%m-%d" 2>/dev/null
}

# =============================================================================
# Progress Functions
# =============================================================================

# Show a spinner while a process runs
# Usage: show_spinner <pid> <message>
show_spinner() {
    local pid="$1"
    local message="${2:-Processing...}"
    local spinchars='|/-\'

    while kill -0 "$pid" 2>/dev/null; do
        for (( i=0; i<${#spinchars}; i++ )); do
            echo -ne "\r${CLR_CYAN}${spinchars:$i:1}${CLR_RESET} $message"
            sleep 0.1
        done
    done
    echo -ne "\r"
}

# Show progress bar
# Usage: progress_bar <current> <total> <width>
progress_bar() {
    local current="$1"
    local total="$2"
    local width="${3:-50}"

    local percent=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    local bar=""
    for ((i = 0; i < filled; i++)); do bar+="█"; done
    for ((i = 0; i < empty; i++)); do bar+="░"; done

    printf "\r${CLR_CYAN}[%s]${CLR_RESET} %3d%%" "$bar" "$percent"
}

# =============================================================================
# Dependency Checking
# =============================================================================

# Check required dependencies
check_dependencies() {
    local missing=()
    local deps=("curl" "jq" "sed" "awk")

    for dep in "${deps[@]}"; do
        if ! command_exists "$dep"; then
            missing+=("$dep")
        fi
    done

    if (( ${#missing[@]} > 0 )); then
        log_error "Missing required dependencies: ${missing[*]}"
        log_info "Please install them before running CactusBNMK"
        return 1
    fi

    return 0
}

# =============================================================================
# Terminal Functions
# =============================================================================

# Get terminal width
get_terminal_width() {
    tput cols 2>/dev/null || echo 80
}

# Get terminal height
get_terminal_height() {
    tput lines 2>/dev/null || echo 24
}

# Clear screen
clear_screen() {
    printf '\033[2J\033[H'
}

# Move cursor
move_cursor() {
    local row="$1"
    local col="$2"
    printf '\033[%d;%dH' "$row" "$col"
}

# Hide cursor
hide_cursor() {
    printf '\033[?25l'
}

# Show cursor
show_cursor() {
    printf '\033[?25h'
}
