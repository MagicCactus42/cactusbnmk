#!/bin/bash
# =============================================================================
# CactusBNMK - Themes Module
# =============================================================================
# Defines all available banner themes with their visual properties
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_THEMES_SH_LOADED:-}" ]] && return 0
readonly _THEMES_SH_LOADED=1

# Get script directory
_THEMES_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source dependencies
source "${_THEMES_SCRIPT_DIR}/lib/colors.sh"
source "${_THEMES_SCRIPT_DIR}/lib/config.sh"

# =============================================================================
# Theme Registry
# =============================================================================

# Declare associative arrays for theme data
declare -gA THEME_NAMES
declare -gA THEME_CATEGORIES
declare -gA THEME_DESCRIPTIONS
declare -gA THEME_PRIMARY_COLORS
declare -gA THEME_SECONDARY_COLORS
declare -gA THEME_ACCENT_COLORS
declare -gA THEME_PATTERNS
declare -gA THEME_CHARACTERS

# =============================================================================
# Theme Registration Function
# =============================================================================

# Register a theme
# Usage: register_theme <id> <name> <category> <desc> <primary_rgb> <secondary_rgb> <accent_rgb> <pattern> <chars>
register_theme() {
    local id="$1"
    local name="$2"
    local category="$3"
    local description="$4"
    local primary="$5"      # RGB: "r,g,b"
    local secondary="$6"    # RGB: "r,g,b"
    local accent="$7"       # RGB: "r,g,b"
    local pattern="$8"      # Pattern type
    local chars="$9"        # Character set

    THEME_NAMES["$id"]="$name"
    THEME_CATEGORIES["$id"]="$category"
    THEME_DESCRIPTIONS["$id"]="$description"
    THEME_PRIMARY_COLORS["$id"]="$primary"
    THEME_SECONDARY_COLORS["$id"]="$secondary"
    THEME_ACCENT_COLORS["$id"]="$accent"
    THEME_PATTERNS["$id"]="$pattern"
    THEME_CHARACTERS["$id"]="$chars"
}

# =============================================================================
# Nature Themes (1-5)
# =============================================================================

register_theme "forest" \
    "Forest" \
    "$THEME_CATEGORY_NATURE" \
    "Deep green woodland with layered trees" \
    "34,139,34" \
    "0,100,0" \
    "144,238,144" \
    "trees" \
    "/\\|YTtf"

register_theme "ocean" \
    "Ocean" \
    "$THEME_CATEGORY_NATURE" \
    "Calming blue ocean waves" \
    "0,105,148" \
    "0,191,255" \
    "173,216,230" \
    "waves" \
    "~-=_"

register_theme "desert" \
    "Desert" \
    "$THEME_CATEGORY_NATURE" \
    "Warm sand dunes under golden sun" \
    "210,180,140" \
    "244,164,96" \
    "255,215,0" \
    "dunes" \
    ".:~^"

register_theme "mountain" \
    "Mountain" \
    "$THEME_CATEGORY_NATURE" \
    "Majestic snow-capped peaks" \
    "105,105,105" \
    "169,169,169" \
    "255,250,250" \
    "peaks" \
    "/\\^Mm"

register_theme "jungle" \
    "Jungle" \
    "$THEME_CATEGORY_NATURE" \
    "Dense tropical rainforest" \
    "0,128,0" \
    "50,205,50" \
    "154,205,50" \
    "dense" \
    "@#%&WM"

# =============================================================================
# Space Themes (6-10)
# =============================================================================

register_theme "galaxy" \
    "Galaxy" \
    "$THEME_CATEGORY_SPACE" \
    "Swirling spiral galaxy with stars" \
    "75,0,130" \
    "138,43,226" \
    "255,255,255" \
    "spiral" \
    "*+.o@"

register_theme "nebula" \
    "Nebula" \
    "$THEME_CATEGORY_SPACE" \
    "Colorful cosmic cloud formation" \
    "255,20,147" \
    "138,43,226" \
    "0,255,255" \
    "cloud" \
    ".:+*#"

register_theme "aurora" \
    "Aurora" \
    "$THEME_CATEGORY_SPACE" \
    "Northern lights dancing across sky" \
    "0,255,127" \
    "0,191,255" \
    "138,43,226" \
    "curtain" \
    "|/\\~-"

register_theme "starfield" \
    "Starfield" \
    "$THEME_CATEGORY_SPACE" \
    "Infinite field of twinkling stars" \
    "25,25,112" \
    "0,0,139" \
    "255,255,255" \
    "scatter" \
    ".*+'"

register_theme "cosmic" \
    "Cosmic" \
    "$THEME_CATEGORY_SPACE" \
    "Deep space with cosmic rays" \
    "0,0,80" \
    "72,61,139" \
    "255,215,0" \
    "rays" \
    "-=|/\\"

# =============================================================================
# Tech Themes (11-15)
# =============================================================================

register_theme "matrix" \
    "Matrix" \
    "$THEME_CATEGORY_TECH" \
    "Digital rain of cascading code" \
    "0,255,0" \
    "0,128,0" \
    "144,238,144" \
    "rain" \
    "01|!:"

register_theme "cyberpunk" \
    "Cyberpunk" \
    "$THEME_CATEGORY_TECH" \
    "Neon-lit futuristic cityscape" \
    "255,0,255" \
    "0,255,255" \
    "255,105,180" \
    "city" \
    "[]{}|_"

register_theme "circuit" \
    "Circuit" \
    "$THEME_CATEGORY_TECH" \
    "Electronic circuit board traces" \
    "0,128,0" \
    "255,215,0" \
    "192,192,192" \
    "grid" \
    "+-|oO"

register_theme "neon" \
    "Neon" \
    "$THEME_CATEGORY_TECH" \
    "Glowing neon signs in darkness" \
    "255,0,127" \
    "0,255,255" \
    "255,255,0" \
    "glow" \
    "()[]<>"

register_theme "retro" \
    "Retro" \
    "$THEME_CATEGORY_TECH" \
    "80s style retro computing aesthetic" \
    "255,105,180" \
    "0,255,255" \
    "255,255,0" \
    "grid" \
    "=#-+"

# =============================================================================
# Abstract Themes (16-20)
# =============================================================================

register_theme "gradient" \
    "Gradient" \
    "$THEME_CATEGORY_ABSTRACT" \
    "Smooth color transitions" \
    "255,0,128" \
    "128,0,255" \
    "0,128,255" \
    "smooth" \
    ".:+#@"

register_theme "flames" \
    "Flames" \
    "$THEME_CATEGORY_ABSTRACT" \
    "Rising fire and embers" \
    "255,69,0" \
    "255,140,0" \
    "255,215,0" \
    "rise" \
    "^/\\|W"

register_theme "waves" \
    "Waves" \
    "$THEME_CATEGORY_ABSTRACT" \
    "Flowing sine wave patterns" \
    "65,105,225" \
    "100,149,237" \
    "135,206,250" \
    "sine" \
    "~-=_"

register_theme "geometric" \
    "Geometric" \
    "$THEME_CATEGORY_ABSTRACT" \
    "Sharp angles and shapes" \
    "255,255,255" \
    "128,128,128" \
    "64,64,64" \
    "shapes" \
    "/\\<>[]"

register_theme "minimal" \
    "Minimal" \
    "$THEME_CATEGORY_ABSTRACT" \
    "Clean minimalist design" \
    "200,200,200" \
    "150,150,150" \
    "100,100,100" \
    "clean" \
    ".-_|"

# =============================================================================
# Seasonal Themes (21-24)
# =============================================================================

register_theme "sunset" \
    "Sunset" \
    "$THEME_CATEGORY_SEASONAL" \
    "Warm sunset with sun on horizon" \
    "255,99,71" \
    "255,165,0" \
    "255,215,0" \
    "sun" \
    "O*-~"

register_theme "midnight" \
    "Midnight" \
    "$THEME_CATEGORY_SEASONAL" \
    "Deep blue midnight sky" \
    "25,25,112" \
    "0,0,139" \
    "70,130,180" \
    "night" \
    ".*+o"

register_theme "snowfall" \
    "Snowfall" \
    "$THEME_CATEGORY_SEASONAL" \
    "Gentle falling snowflakes" \
    "240,248,255" \
    "176,224,230" \
    "255,255,255" \
    "fall" \
    "*+.o"

register_theme "autumn" \
    "Autumn" \
    "$THEME_CATEGORY_SEASONAL" \
    "Warm fall foliage colors" \
    "205,92,0" \
    "210,105,30" \
    "255,140,0" \
    "leaves" \
    "@#%&*"

# =============================================================================
# Theme Query Functions
# =============================================================================

# Get list of all theme IDs
get_all_theme_ids() {
    echo "${!THEME_NAMES[@]}" | tr ' ' '\n' | sort
}

# Get theme count
get_theme_count() {
    echo "${#THEME_NAMES[@]}"
}

# Check if theme exists
theme_exists() {
    local id="$1"
    [[ -n "${THEME_NAMES[$id]:-}" ]]
}

# Get theme property
get_theme_property() {
    local id="$1"
    local property="$2"

    case "$property" in
        "name")        echo "${THEME_NAMES[$id]:-}" ;;
        "category")    echo "${THEME_CATEGORIES[$id]:-}" ;;
        "description") echo "${THEME_DESCRIPTIONS[$id]:-}" ;;
        "primary")     echo "${THEME_PRIMARY_COLORS[$id]:-}" ;;
        "secondary")   echo "${THEME_SECONDARY_COLORS[$id]:-}" ;;
        "accent")      echo "${THEME_ACCENT_COLORS[$id]:-}" ;;
        "pattern")     echo "${THEME_PATTERNS[$id]:-}" ;;
        "characters")  echo "${THEME_CHARACTERS[$id]:-}" ;;
        *)             return 1 ;;
    esac
}

# Get themes by category
get_themes_by_category() {
    local category="$1"
    local themes=()

    for id in "${!THEME_CATEGORIES[@]}"; do
        if [[ "${THEME_CATEGORIES[$id]}" == "$category" ]]; then
            themes+=("$id")
        fi
    done

    printf '%s\n' "${themes[@]}" | sort
}

# Parse RGB string to components
parse_rgb() {
    local rgb="$1"
    echo "$rgb" | tr ',' ' '
}

# =============================================================================
# Theme Display Functions
# =============================================================================

# Display theme preview card
display_theme_card() {
    local id="$1"
    local index="${2:-}"

    local name="${THEME_NAMES[$id]}"
    local category="${THEME_CATEGORIES[$id]}"
    local description="${THEME_DESCRIPTIONS[$id]}"
    local primary="${THEME_PRIMARY_COLORS[$id]}"

    # Parse primary color
    local r g b
    read -r r g b <<< "$(parse_rgb "$primary")"

    # Create color preview
    local color_preview
    color_preview=$(color_rgb "$r" "$g" "$b")

    local prefix=""
    [[ -n "$index" ]] && prefix="${CLR_BOLD}${index}.${CLR_RESET} "

    echo -e "${prefix}${color_preview}██${CLR_RESET} ${CLR_BOLD}$name${CLR_RESET} ${CLR_DIM}[$category]${CLR_RESET}"
    echo -e "   ${CLR_DIM}$description${CLR_RESET}"
}

# Display all themes organized by category
display_all_themes() {
    local categories=(
        "$THEME_CATEGORY_NATURE"
        "$THEME_CATEGORY_SPACE"
        "$THEME_CATEGORY_TECH"
        "$THEME_CATEGORY_ABSTRACT"
        "$THEME_CATEGORY_SEASONAL"
    )

    local index=1

    for category in "${categories[@]}"; do
        echo -e "\n${CLR_BOLD}${CLR_CYAN}$category Themes${CLR_RESET}"
        echo -e "${CLR_DIM}$(printf '─%.0s' {1..40})${CLR_RESET}"

        while IFS= read -r id; do
            [[ -z "$id" ]] && continue
            display_theme_card "$id" "$index"
            ((index++))
        done < <(get_themes_by_category "$category")
    done

    echo -e "\n${CLR_BOLD}${CLR_YELLOW}$index.${CLR_RESET} ${CLR_BOLD}Custom${CLR_RESET} ${CLR_DIM}[Custom]${CLR_RESET}"
    echo -e "   ${CLR_DIM}Create your own banner with custom text${CLR_RESET}"
}

# Get theme ID by index number
get_theme_by_index() {
    local target_index="$1"
    local categories=(
        "$THEME_CATEGORY_NATURE"
        "$THEME_CATEGORY_SPACE"
        "$THEME_CATEGORY_TECH"
        "$THEME_CATEGORY_ABSTRACT"
        "$THEME_CATEGORY_SEASONAL"
    )

    local index=1

    for category in "${categories[@]}"; do
        while IFS= read -r id; do
            [[ -z "$id" ]] && continue
            if (( index == target_index )); then
                echo "$id"
                return 0
            fi
            ((index++))
        done < <(get_themes_by_category "$category")
    done

    # Check if it's the custom option
    if (( target_index == index )); then
        echo "custom"
        return 0
    fi

    return 1
}

# Get total menu options (themes + custom)
get_total_menu_options() {
    echo $(( $(get_theme_count) + 1 ))
}
