#!/bin/bash
# =============================================================================
# CactusBNMK - Color Definitions Module
# =============================================================================
# Provides ANSI color codes and color manipulation functions
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_COLORS_SH_LOADED:-}" ]] && return 0
readonly _COLORS_SH_LOADED=1

# =============================================================================
# ANSI Color Codes
# =============================================================================

# Reset
readonly CLR_RESET='\033[0m'

# Regular Colors
readonly CLR_BLACK='\033[0;30m'
readonly CLR_RED='\033[0;31m'
readonly CLR_GREEN='\033[0;32m'
readonly CLR_YELLOW='\033[0;33m'
readonly CLR_BLUE='\033[0;34m'
readonly CLR_PURPLE='\033[0;35m'
readonly CLR_CYAN='\033[0;36m'
readonly CLR_WHITE='\033[0;37m'

# Bold Colors
readonly CLR_BOLD_BLACK='\033[1;30m'
readonly CLR_BOLD_RED='\033[1;31m'
readonly CLR_BOLD_GREEN='\033[1;32m'
readonly CLR_BOLD_YELLOW='\033[1;33m'
readonly CLR_BOLD_BLUE='\033[1;34m'
readonly CLR_BOLD_PURPLE='\033[1;35m'
readonly CLR_BOLD_CYAN='\033[1;36m'
readonly CLR_BOLD_WHITE='\033[1;37m'

# High Intensity Colors
readonly CLR_HI_BLACK='\033[0;90m'
readonly CLR_HI_RED='\033[0;91m'
readonly CLR_HI_GREEN='\033[0;92m'
readonly CLR_HI_YELLOW='\033[0;93m'
readonly CLR_HI_BLUE='\033[0;94m'
readonly CLR_HI_PURPLE='\033[0;95m'
readonly CLR_HI_CYAN='\033[0;96m'
readonly CLR_HI_WHITE='\033[0;97m'

# Background Colors
readonly CLR_BG_BLACK='\033[40m'
readonly CLR_BG_RED='\033[41m'
readonly CLR_BG_GREEN='\033[42m'
readonly CLR_BG_YELLOW='\033[43m'
readonly CLR_BG_BLUE='\033[44m'
readonly CLR_BG_PURPLE='\033[45m'
readonly CLR_BG_CYAN='\033[46m'
readonly CLR_BG_WHITE='\033[47m'

# Text Styles
readonly CLR_BOLD='\033[1m'
readonly CLR_DIM='\033[2m'
readonly CLR_ITALIC='\033[3m'
readonly CLR_UNDERLINE='\033[4m'
readonly CLR_BLINK='\033[5m'
readonly CLR_REVERSE='\033[7m'

# =============================================================================
# Color Functions
# =============================================================================

# Print colored text
# Usage: color_print "COLOR_NAME" "text"
color_print() {
    local color="$1"
    local text="$2"
    local color_code=""

    case "$color" in
        "red")     color_code="$CLR_RED" ;;
        "green")   color_code="$CLR_GREEN" ;;
        "yellow")  color_code="$CLR_YELLOW" ;;
        "blue")    color_code="$CLR_BLUE" ;;
        "purple")  color_code="$CLR_PURPLE" ;;
        "cyan")    color_code="$CLR_CYAN" ;;
        "white")   color_code="$CLR_WHITE" ;;
        "bold")    color_code="$CLR_BOLD" ;;
        *)         color_code="$CLR_RESET" ;;
    esac

    echo -e "${color_code}${text}${CLR_RESET}"
}

# Generate 256-color ANSI code
# Usage: color_256 <0-255>
color_256() {
    local code="$1"
    echo -e "\033[38;5;${code}m"
}

# Generate 256-color background ANSI code
# Usage: bg_color_256 <0-255>
bg_color_256() {
    local code="$1"
    echo -e "\033[48;5;${code}m"
}

# Generate RGB color (true color terminals)
# Usage: color_rgb <r> <g> <b>
color_rgb() {
    local r="$1" g="$2" b="$3"
    echo -e "\033[38;2;${r};${g};${b}m"
}

# Generate RGB background color
# Usage: bg_color_rgb <r> <g> <b>
bg_color_rgb() {
    local r="$1" g="$2" b="$3"
    echo -e "\033[48;2;${r};${g};${b}m"
}

# Interpolate between two colors based on intensity (0-100)
# Usage: interpolate_color <r1> <g1> <b1> <r2> <g2> <b2> <intensity>
interpolate_color() {
    local r1="$1" g1="$2" b1="$3"
    local r2="$4" g2="$5" b2="$6"
    local intensity="$7"

    local r=$(( r1 + (r2 - r1) * intensity / 100 ))
    local g=$(( g1 + (g2 - g1) * intensity / 100 ))
    local b=$(( b1 + (b2 - b1) * intensity / 100 ))

    echo "$r $g $b"
}

# Get brightness-adjusted color
# Usage: adjust_brightness <r> <g> <b> <brightness_percent>
adjust_brightness() {
    local r="$1" g="$2" b="$3"
    local brightness="$4"

    r=$(( r * brightness / 100 ))
    g=$(( g * brightness / 100 ))
    b=$(( b * brightness / 100 ))

    # Clamp values
    (( r > 255 )) && r=255
    (( g > 255 )) && g=255
    (( b > 255 )) && b=255
    (( r < 0 )) && r=0
    (( g < 0 )) && g=0
    (( b < 0 )) && b=0

    echo "$r $g $b"
}
