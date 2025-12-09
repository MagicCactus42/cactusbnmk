#!/bin/bash
# =============================================================================
# CactusBNMK - Banner Generator Module
# =============================================================================
# Core banner generation logic with various pattern generators
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_BANNER_GENERATOR_SH_LOADED:-}" ]] && return 0
readonly _BANNER_GENERATOR_SH_LOADED=1

# Get script directory
_BANNER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source dependencies
source "${_BANNER_SCRIPT_DIR}/lib/colors.sh"
source "${_BANNER_SCRIPT_DIR}/lib/utils.sh"
source "${_BANNER_SCRIPT_DIR}/lib/config.sh"
source "${_BANNER_SCRIPT_DIR}/lib/themes.sh"
source "${_BANNER_SCRIPT_DIR}/lib/ascii_fonts.sh"

# =============================================================================
# Pattern Generation Functions
# =============================================================================

# Generate noise value (pseudo-random based on position)
_noise() {
    local x="$1" y="$2" seed="${3:-42}"
    echo $(( (x * 374761393 + y * 668265263 + seed) % 100 ))
}

# Generate tree pattern
_pattern_trees() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local tree_density=15
    local ground_level=$((height - 3))

    if (( y >= ground_level )); then
        echo "${chars:0:1}"
        return
    fi

    local noise=$(_noise "$x" "$y")
    local tree_pos=$(( x % tree_density ))

    if (( tree_pos == 0 && y > height / 3 )); then
        echo "${chars:1:1}"
    elif (( tree_pos >= 1 && tree_pos <= 2 && y > height / 2 )); then
        local idx=$(( noise % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate wave pattern
_pattern_waves() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local amplitude=$((height / 4))
    local wavelength=10
    local mid=$((height / 2))

    # Calculate sine-like wave
    local phase=$(( (x * 314 / wavelength) % 628 ))
    local sin_approx=$(( (phase < 314) ? (phase * (628 - phase) * 4 / 98596) : -((phase - 314) * (942 - phase) * 4 / 98596) ))
    local wave_y=$(( mid + sin_approx * amplitude / 100 ))

    local dist=$(( y - wave_y ))
    dist=${dist#-}  # Absolute value

    if (( dist <= 2 )); then
        local idx=$(( dist % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate dune pattern
_pattern_dunes() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local dune_height=$((height / 3))
    local wavelength=20

    local phase=$(( (x * 314 / wavelength) % 628 ))
    local sin_approx=$(( (phase < 314) ? (phase * (628 - phase) * 4 / 98596) : -((phase - 314) * (942 - phase) * 4 / 98596) ))
    local dune_y=$(( height - dune_height + sin_approx * dune_height / 200 ))

    if (( y >= dune_y )); then
        local noise=$(_noise "$x" "$y")
        local idx=$(( noise % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate peak pattern
_pattern_peaks() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local peak1=$(( width / 4 ))
    local peak2=$(( width / 2 ))
    local peak3=$(( 3 * width / 4 ))

    local base_y=$((height - 2))
    local dist1=$(( x - peak1 )); dist1=${dist1#-}
    local dist2=$(( x - peak2 )); dist2=${dist2#-}
    local dist3=$(( x - peak3 )); dist3=${dist3#-}

    local mountain_y=$base_y
    (( dist1 < height / 2 )) && mountain_y=$(( base_y - (height / 2 - dist1) * 2 / 3 ))
    (( dist2 < height )) && mountain_y=$(( (mountain_y < base_y - (height - dist2) / 2) ? mountain_y : base_y - (height - dist2) / 2 ))
    (( dist3 < height / 3 )) && mountain_y=$(( (mountain_y < base_y - (height / 3 - dist3)) ? mountain_y : base_y - (height / 3 - dist3) ))

    if (( y >= mountain_y )); then
        if (( y == mountain_y )); then
            echo "${chars:0:1}"
        else
            local idx=$(( (y - mountain_y) % ${#chars} ))
            echo "${chars:$idx:1}"
        fi
    else
        echo " "
    fi
}

# Generate dense pattern
_pattern_dense() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local noise=$(_noise "$x" "$y")
    if (( noise > 30 )); then
        local idx=$(( noise % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate spiral pattern
_pattern_spiral() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local cx=$((width / 2))
    local cy=$((height / 2))
    local dx=$((x - cx))
    local dy=$((y - cy))

    local dist=$(( dx * dx + dy * dy ))
    dist=$(echo "sqrt($dist)" | bc 2>/dev/null || echo "$((dx + dy))")

    local angle=$(( (dx * 100 / (dy + 1)) + dist * 10 ))

    if (( angle % 15 < 5 )); then
        local noise=$(_noise "$x" "$y")
        local idx=$(( noise % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate cloud pattern
_pattern_cloud() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local noise1=$(_noise "$x" "$y" 42)
    local noise2=$(_noise "$((x/2))" "$((y/2))" 13)
    local combined=$(( (noise1 + noise2) / 2 ))

    if (( combined > 40 )); then
        local idx=$(( combined % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate curtain pattern (aurora)
_pattern_curtain() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local wave=$(( (x * 5 + y * 3) % 20 ))

    if (( wave < 8 && y < height * 3 / 4 )); then
        local idx=$(( y % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate scatter pattern (stars)
_pattern_scatter() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local noise=$(_noise "$x" "$y")

    if (( noise > 92 )); then
        echo "${chars:0:1}"
    elif (( noise > 96 )); then
        echo "${chars:1:1}"
    else
        echo " "
    fi
}

# Generate rays pattern
_pattern_rays() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local cx=$((width / 2))
    local cy=$((height / 2))
    local dx=$((x - cx))
    local dy=$((y - cy))

    local angle=$(( (dx * 1000 / (dy + 1)) % 360 ))
    angle=${angle#-}

    if (( angle % 45 < 10 )); then
        local dist=$(( dx * dx + dy * dy ))
        local idx=$(( (dist / 50) % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate rain pattern (matrix)
_pattern_rain() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local stream=$(( x % 3 ))
    local drop=$(( (y + x * 7) % 8 ))

    if (( stream == 0 && drop < 4 )); then
        local noise=$(_noise "$x" "$y")
        local idx=$(( noise % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate city pattern
_pattern_city() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local building_width=5
    local building=$(( x / building_width ))
    local noise=$(_noise "$building" 0)
    local building_height=$(( height / 3 + noise % (height / 2) ))

    local ground=$((height - 1))
    local building_top=$((ground - building_height))

    if (( y >= building_top && y < ground )); then
        local in_building=$(( x % building_width ))
        if (( in_building == 0 || in_building == building_width - 1 )); then
            echo "${chars:0:1}"
        elif (( (y + x) % 3 == 0 )); then
            echo "${chars:2:1}"
        else
            echo " "
        fi
    elif (( y == ground )); then
        echo "${chars:3:1}"
    else
        echo " "
    fi
}

# Generate grid pattern
_pattern_grid() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local grid_size=4

    if (( x % grid_size == 0 || y % grid_size == 0 )); then
        if (( x % grid_size == 0 && y % grid_size == 0 )); then
            echo "${chars:0:1}"
        else
            echo "${chars:1:1}"
        fi
    else
        echo " "
    fi
}

# Generate glow pattern
_pattern_glow() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local cx=$((width / 2))
    local cy=$((height / 2))
    local dx=$((x - cx))
    local dy=$((y - cy))

    local dist=$(( (dx * dx + dy * dy) ))
    local max_dist=$(( (width * width + height * height) / 4 ))

    if (( dist < max_dist / 16 )); then
        echo "${chars:0:1}"
    elif (( dist < max_dist / 4 )); then
        local idx=$(( (dist * ${#chars} / max_dist) ))
        (( idx >= ${#chars} )) && idx=$(( ${#chars} - 1 ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate smooth gradient pattern
_pattern_smooth() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local progress=$(( x * ${#chars} / width ))
    (( progress >= ${#chars} )) && progress=$(( ${#chars} - 1 ))

    echo "${chars:$progress:1}"
}

# Generate rise pattern (flames)
_pattern_rise() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local base=$((height - 1))
    local noise=$(_noise "$x" "$y")
    local flame_height=$(( height / 2 + noise % (height / 3) ))

    if (( y > base - flame_height )); then
        local intensity=$(( (base - y) * 100 / flame_height ))
        local idx=$(( intensity * ${#chars} / 100 ))
        (( idx >= ${#chars} )) && idx=$(( ${#chars} - 1 ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate sine wave pattern
_pattern_sine() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    for offset in 0 2 4; do
        local amplitude=$(( height / 4 - offset ))
        local wavelength=$((15 + offset * 3))
        local mid=$((height / 2))

        local phase=$(( (x * 314 / wavelength) % 628 ))
        local sin_approx=$(( (phase < 314) ? (phase * (628 - phase) * 4 / 98596) : -((phase - 314) * (942 - phase) * 4 / 98596) ))
        local wave_y=$(( mid + sin_approx * amplitude / 100 ))

        if (( y == wave_y )); then
            local idx=$(( offset / 2 ))
            echo "${chars:$idx:1}"
            return
        fi
    done

    echo " "
}

# Generate shapes pattern
_pattern_shapes() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local shape=$(( (x / 10 + y / 5) % 3 ))
    local noise=$(_noise "$x" "$y")

    if (( noise > 70 )); then
        local idx=$(( shape % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate clean minimal pattern
_pattern_clean() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    if (( y == 0 || y == height - 1 )); then
        echo "${chars:0:1}"
    elif (( x == 0 || x == width - 1 )); then
        echo "${chars:3:1}"
    else
        echo " "
    fi
}

# Generate horizon pattern
_pattern_horizon() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local horizon=$((height * 2 / 3))

    if (( y == horizon )); then
        echo "${chars:0:1}"
    elif (( y > horizon )); then
        local below=$(( y - horizon ))
        if (( below % 2 == 0 )); then
            echo "${chars:1:1}"
        else
            echo " "
        fi
    else
        echo " "
    fi
}

# Generate night sky pattern
_pattern_night() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local noise=$(_noise "$x" "$y")

    if (( noise > 95 )); then
        echo "${chars:0:1}"
    elif (( noise > 90 )); then
        echo "${chars:1:1}"
    else
        echo " "
    fi
}

# Generate falling pattern
_pattern_fall() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local noise=$(_noise "$x" "$y")
    local fall=$(( (y + x * 3) % 12 ))

    if (( fall < 2 && noise > 60 )); then
        local idx=$(( noise % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# Generate leaves pattern
_pattern_leaves() {
    local x="$1" y="$2" width="$3" height="$4" chars="$5"

    local noise=$(_noise "$x" "$y")
    local drift=$(( (x + y * 2) % 8 ))

    if (( drift < 3 && noise > 50 )); then
        local idx=$(( noise % ${#chars} ))
        echo "${chars:$idx:1}"
    else
        echo " "
    fi
}

# =============================================================================
# Main Pattern Router
# =============================================================================

# Get character for position based on pattern type
get_pattern_char() {
    local pattern="$1"
    local x="$2" y="$3" width="$4" height="$5" chars="$6"

    case "$pattern" in
        "trees")    _pattern_trees "$x" "$y" "$width" "$height" "$chars" ;;
        "waves")    _pattern_waves "$x" "$y" "$width" "$height" "$chars" ;;
        "dunes")    _pattern_dunes "$x" "$y" "$width" "$height" "$chars" ;;
        "peaks")    _pattern_peaks "$x" "$y" "$width" "$height" "$chars" ;;
        "dense")    _pattern_dense "$x" "$y" "$width" "$height" "$chars" ;;
        "spiral")   _pattern_spiral "$x" "$y" "$width" "$height" "$chars" ;;
        "cloud")    _pattern_cloud "$x" "$y" "$width" "$height" "$chars" ;;
        "curtain")  _pattern_curtain "$x" "$y" "$width" "$height" "$chars" ;;
        "scatter")  _pattern_scatter "$x" "$y" "$width" "$height" "$chars" ;;
        "rays")     _pattern_rays "$x" "$y" "$width" "$height" "$chars" ;;
        "rain")     _pattern_rain "$x" "$y" "$width" "$height" "$chars" ;;
        "city")     _pattern_city "$x" "$y" "$width" "$height" "$chars" ;;
        "grid")     _pattern_grid "$x" "$y" "$width" "$height" "$chars" ;;
        "glow")     _pattern_glow "$x" "$y" "$width" "$height" "$chars" ;;
        "smooth")   _pattern_smooth "$x" "$y" "$width" "$height" "$chars" ;;
        "rise")     _pattern_rise "$x" "$y" "$width" "$height" "$chars" ;;
        "sine")     _pattern_sine "$x" "$y" "$width" "$height" "$chars" ;;
        "shapes")   _pattern_shapes "$x" "$y" "$width" "$height" "$chars" ;;
        "clean")    _pattern_clean "$x" "$y" "$width" "$height" "$chars" ;;
        "horizon")  _pattern_horizon "$x" "$y" "$width" "$height" "$chars" ;;
        "night")    _pattern_night "$x" "$y" "$width" "$height" "$chars" ;;
        "fall")     _pattern_fall "$x" "$y" "$width" "$height" "$chars" ;;
        "leaves")   _pattern_leaves "$x" "$y" "$width" "$height" "$chars" ;;
        *)          echo " " ;;
    esac
}

# =============================================================================
# Banner Generation
# =============================================================================

# Check if point is inside the sun (half-circle at bottom center)
_in_sun() {
    local x="$1" y="$2" width="$3" height="$4"
    local sun_cx=$((width / 2))
    local sun_cy=$height  # Center at bottom edge
    local sun_r=6         # Radius
    local dx=$((x - sun_cx))
    local dy=$((y - sun_cy))
    local dist_sq=$((dx * dx + dy * dy))
    local r_sq=$((sun_r * sun_r))

    if ((dist_sq <= r_sq)); then
        echo "2"  # Inside sun (bright)
    elif ((dist_sq <= r_sq + sun_r * 4)); then
        echo "1"  # Sun glow
    else
        echo "0"  # Outside
    fi
}

# Generate banner from theme (standardized version)
# Usage: generate_banner <theme_id> <brightness> [username] [custom_text] [use_ascii_art]
generate_banner() {
    local theme_id="$1"
    local brightness="${2:-70}"
    local username="${3:-}"
    local custom_text="${4:-}"
    local use_ascii_art="${5:-true}"

    local width="$BANNER_WIDTH"
    local height="$BANNER_HEIGHT"

    # Get theme properties
    local primary secondary accent pattern

    if [[ "$theme_id" == "custom" ]]; then
        primary="255,255,255"
        secondary="128,128,128"
        accent="200,200,200"
        pattern="solid"
    else
        primary=$(get_theme_property "$theme_id" "primary")
        secondary=$(get_theme_property "$theme_id" "secondary")
        accent=$(get_theme_property "$theme_id" "accent")
        pattern=$(get_theme_property "$theme_id" "pattern")
    fi

    # Parse colors once
    IFS=',' read -r pr pg pb <<< "$primary"
    IFS=',' read -r sr sg sb <<< "$secondary"
    IFS=',' read -r ar ag ab <<< "$accent"

    # Apply brightness
    pr=$(( pr * brightness / 100 ))
    pg=$(( pg * brightness / 100 ))
    pb=$(( pb * brightness / 100 ))
    sr=$(( sr * brightness / 100 ))
    sg=$(( sg * brightness / 100 ))
    sb=$(( sb * brightness / 100 ))

    # Prepare display text
    local display_text=""
    if [[ -n "$custom_text" ]]; then
        display_text="$custom_text"
    elif [[ -n "$username" ]]; then
        display_text="@$username"
    fi

    # Initialize ASCII art text overlay
    if [[ -n "$display_text" && "$use_ascii_art" == "true" ]]; then
        init_ascii_text_overlay "$display_text" "$width" "$height"
    else
        TEXT_GRID_HEIGHT=0
        TEXT_GRID_LINES=()
    fi

    # Colors
    local white_color="\033[1;38;2;255;255;255m"
    local bright_yellow="\033[1;38;2;255;255;100m"
    local reset="\033[0m"

    # Generate banner line by line
    local y x
    for ((y = 0; y < height; y++)); do
        local line=""

        for ((x = 0; x < width; x++)); do
            local char=""

            # Check for ASCII text overlay first
            if [[ ${TEXT_GRID_HEIGHT:-0} -gt 0 ]]; then
                if ((y >= TEXT_START_Y && y < TEXT_START_Y + TEXT_GRID_HEIGHT)); then
                    if ((x >= TEXT_START_X && x < TEXT_START_X + TEXT_GRID_WIDTH)); then
                        local text_y=$((y - TEXT_START_Y))
                        local text_x=$((x - TEXT_START_X))
                        local text_line="${TEXT_GRID_LINES[$text_y]:-}"
                        if ((text_x < ${#text_line})); then
                            local tc="${text_line:$text_x:1}"
                            if [[ "$tc" != " " ]]; then
                                char="${white_color}${tc}${reset}"
                            fi
                        fi
                    fi
                fi
            fi

            # If no text char, draw pattern
            if [[ -z "$char" ]]; then
                local show_x=1
                local use_bright=0

                # Pattern-specific logic
                case "$pattern" in
                    "sun")
                        # Sunset with half-circle sun at bottom
                        local sun_cx=$((width / 2))
                        local sun_cy=$((height + 2))
                        local dx=$((x - sun_cx))
                        local dy=$((y - sun_cy))
                        local dist_sq=$((dx * dx + dy * dy))

                        if ((dist_sq <= 20)); then
                            # Bright sun center
                            use_bright=2
                            show_x=1
                        elif ((dist_sq <= 45)); then
                            # Sun body
                            use_bright=1
                            show_x=1
                        else
                            # Sky - sparse
                            show_x=$(( (x + y) % 3 == 0 ? 1 : 0 ))
                        fi
                        ;;
                    "scatter"|"night"|"starfield")
                        # Sparse stars
                        local noise=$(( (x * 374761393 + y * 668265263) % 100 ))
                        show_x=$(( noise > 85 ? 1 : 0 ))
                        ;;
                    "dense"|"forest"|"jungle")
                        # Dense pattern
                        local noise=$(( (x * 374761393 + y * 668265263) % 100 ))
                        show_x=$(( noise > 30 ? 1 : 0 ))
                        ;;
                    "waves"|"ocean")
                        # Wave pattern
                        local wave=$(( (x + y * 2) % 6 ))
                        show_x=$(( wave < 3 ? 1 : 0 ))
                        ;;
                    "rain"|"matrix")
                        # Vertical rain
                        show_x=$(( x % 3 == 0 ? 1 : 0 ))
                        ;;
                    "grid"|"circuit")
                        # Grid pattern
                        show_x=$(( (x % 4 == 0 || y % 2 == 0) ? 1 : 0 ))
                        ;;
                    "gradient"|"smooth")
                        # Full gradient
                        show_x=1
                        ;;
                    "minimal"|"clean")
                        # Very sparse
                        show_x=$(( (x + y) % 4 == 0 ? 1 : 0 ))
                        ;;
                    *)
                        # Default: medium density
                        local noise=$(( (x * 374761393 + y * 668265263) % 100 ))
                        show_x=$(( noise > 50 ? 1 : 0 ))
                        ;;
                esac

                if ((show_x)); then
                    if ((use_bright == 2)); then
                        # Very bright (sun center)
                        char="${bright_yellow}x${reset}"
                    elif ((use_bright == 1)); then
                        # Bright (sun edge)
                        char="\033[38;2;255;200;100mx${reset}"
                    else
                        # Normal gradient color
                        local col_r=$(( pr + (sr - pr) * x / width ))
                        local col_g=$(( pg + (sg - pg) * x / width ))
                        local col_b=$(( pb + (sb - pb) * x / width ))
                        char="\033[38;2;${col_r};${col_g};${col_b}mx${reset}"
                    fi
                else
                    char=" "
                fi
            fi

            line+="$char"
        done

        echo -e "$line"
    done
}

# Generate and display banner with border
display_banner() {
    local theme_id="$1"
    local brightness="${2:-70}"
    local username="${3:-}"
    local custom_text="${4:-}"
    local use_ascii_art="${5:-true}"

    local theme_name
    if [[ "$theme_id" == "custom" ]]; then
        theme_name="Custom"
    else
        theme_name=$(get_theme_property "$theme_id" "name")
    fi

    echo ""
    echo -e "${CLR_BOLD}${CLR_CYAN}Theme: ${theme_name}${CLR_RESET} | ${CLR_DIM}Brightness: ${brightness}%${CLR_RESET}"
    echo -e "${CLR_DIM}════════════════════════════════════════════════════${CLR_RESET}"

    generate_banner "$theme_id" "$brightness" "$username" "$custom_text" "$use_ascii_art"

    echo -e "${CLR_DIM}════════════════════════════════════════════════════${CLR_RESET}"
    echo ""
}

# =============================================================================
# Export Functions
# =============================================================================

# Save banner to file
# Usage: save_banner <theme_id> <brightness> <username> <custom_text> <output_file> <format> [use_ascii_art]
save_banner() {
    local theme_id="$1"
    local brightness="$2"
    local username="$3"
    local custom_text="$4"
    local output_file="$5"
    local format="${6:-$OUTPUT_FORMAT_ANSI}"
    local use_ascii_art="${7:-true}"

    ensure_dir "$(dirname "$output_file")"

    case "$format" in
        "$OUTPUT_FORMAT_ANSI")
            generate_banner "$theme_id" "$brightness" "$username" "$custom_text" "$use_ascii_art" > "$output_file"
            ;;
        "$OUTPUT_FORMAT_TXT")
            # Strip ANSI codes
            generate_banner "$theme_id" "$brightness" "$username" "$custom_text" "$use_ascii_art" | \
                sed 's/\x1b\[[0-9;]*m//g' > "$output_file"
            ;;
        *)
            log_error "Unsupported format: $format"
            return 1
            ;;
    esac

    log_success "Banner saved to: $output_file"
}
