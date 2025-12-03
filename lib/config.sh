#!/bin/bash
# =============================================================================
# CactusBNMK - Configuration Module
# =============================================================================
# Application configuration and settings
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_CONFIG_SH_LOADED:-}" ]] && return 0
readonly _CONFIG_SH_LOADED=1

# =============================================================================
# Application Info
# =============================================================================

readonly APP_NAME="CACTUS"
readonly APP_VERSION="1.0.0"
readonly APP_DESCRIPTION="GitHub Contribution Graph Painter"
readonly APP_AUTHOR="CACTUS Team"

# =============================================================================
# Banner Configuration
# =============================================================================

# Banner dimensions (characters)
readonly BANNER_WIDTH=52
readonly BANNER_HEIGHT=7

# Custom text limits
readonly CUSTOM_TEXT_MAX_LENGTH=30
readonly CUSTOM_TEXT_MIN_LENGTH=1

# ASCII Art Font Settings
# Text length recommendations for optimal display:
#   - Large font (7 lines):  1-6 characters
#   - Medium font (5 lines): 1-10 characters
#   - Small font (3 lines):  1-20 characters
readonly ASCII_ART_LARGE_MAX_CHARS=6
readonly ASCII_ART_MEDIUM_MAX_CHARS=10
readonly ASCII_ART_SMALL_MAX_CHARS=20

# =============================================================================
# GitHub API Configuration
# =============================================================================

readonly GITHUB_API_BASE="https://api.github.com"
readonly GITHUB_API_VERSION="2022-11-28"

# Rate limiting
readonly API_RATE_LIMIT_PAUSE=2  # seconds between requests

# =============================================================================
# Output Configuration
# =============================================================================

# Get script directory for output paths
_CONFIG_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Default output directory
OUTPUT_DIR="${OUTPUT_DIR:-${_CONFIG_SCRIPT_DIR}/output}"

# Output formats
readonly OUTPUT_FORMAT_ANSI="ansi"
readonly OUTPUT_FORMAT_HTML="html"
readonly OUTPUT_FORMAT_SVG="svg"
readonly OUTPUT_FORMAT_TXT="txt"

# Default format
DEFAULT_OUTPUT_FORMAT="${DEFAULT_OUTPUT_FORMAT:-$OUTPUT_FORMAT_ANSI}"

# =============================================================================
# Brightness Configuration
# =============================================================================

# Brightness levels based on commit activity
readonly BRIGHTNESS_VERY_LOW=40      # 0-50 commits
readonly BRIGHTNESS_LOW=55           # 51-150 commits
readonly BRIGHTNESS_MEDIUM=70        # 151-300 commits
readonly BRIGHTNESS_HIGH=85          # 301-500 commits
readonly BRIGHTNESS_VERY_HIGH=100    # 500+ commits

# Commit thresholds
readonly COMMIT_THRESHOLD_VERY_LOW=50
readonly COMMIT_THRESHOLD_LOW=150
readonly COMMIT_THRESHOLD_MEDIUM=300
readonly COMMIT_THRESHOLD_HIGH=500

# =============================================================================
# Theme Configuration
# =============================================================================

# Theme categories
readonly THEME_CATEGORY_NATURE="Nature"
readonly THEME_CATEGORY_SPACE="Space"
readonly THEME_CATEGORY_TECH="Tech"
readonly THEME_CATEGORY_ABSTRACT="Abstract"
readonly THEME_CATEGORY_SEASONAL="Seasonal"
readonly THEME_CATEGORY_CUSTOM="Custom"

# =============================================================================
# Cache Configuration
# =============================================================================

# Cache directory
CACHE_DIR="${CACHE_DIR:-${_CONFIG_SCRIPT_DIR}/.cache}"

# Cache expiry (in seconds) - 1 hour
readonly CACHE_EXPIRY=3600

# =============================================================================
# Functions
# =============================================================================

# Initialize configuration directories
config_init() {
    mkdir -p "$OUTPUT_DIR" 2>/dev/null
    mkdir -p "$CACHE_DIR" 2>/dev/null
}

# Get brightness level from commit count
get_brightness_from_commits() {
    local commits="$1"

    if (( commits <= COMMIT_THRESHOLD_VERY_LOW )); then
        echo "$BRIGHTNESS_VERY_LOW"
    elif (( commits <= COMMIT_THRESHOLD_LOW )); then
        echo "$BRIGHTNESS_LOW"
    elif (( commits <= COMMIT_THRESHOLD_MEDIUM )); then
        echo "$BRIGHTNESS_MEDIUM"
    elif (( commits <= COMMIT_THRESHOLD_HIGH )); then
        echo "$BRIGHTNESS_HIGH"
    else
        echo "$BRIGHTNESS_VERY_HIGH"
    fi
}

# Get brightness description
get_brightness_description() {
    local brightness="$1"

    if (( brightness <= BRIGHTNESS_VERY_LOW )); then
        echo "Very Dim (sparse activity)"
    elif (( brightness <= BRIGHTNESS_LOW )); then
        echo "Dim (light activity)"
    elif (( brightness <= BRIGHTNESS_MEDIUM )); then
        echo "Medium (moderate activity)"
    elif (( brightness <= BRIGHTNESS_HIGH )); then
        echo "Bright (active contributor)"
    else
        echo "Very Bright (highly active)"
    fi
}

# Print application banner
print_app_banner() {
    echo ""
    echo -e "\033[1;32m"
    cat << 'EOF'
      ██████╗ █████╗  ██████╗████████╗██╗   ██╗███████╗
     ██╔════╝██╔══██╗██╔════╝╚══██╔══╝██║   ██║██╔════╝
     ██║     ███████║██║        ██║   ██║   ██║███████╗
     ██║     ██╔══██║██║        ██║   ██║   ██║╚════██║
     ╚██████╗██║  ██║╚██████╗   ██║   ╚██████╔╝███████║
      ╚═════╝╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚══════╝
EOF
    echo -e "\033[0m"
    echo -e "  \033[1;36m${APP_DESCRIPTION}\033[0m"
    echo -e "  \033[0;90mVersion ${APP_VERSION}\033[0m"
    echo ""
}
