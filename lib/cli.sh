#!/bin/bash
# =============================================================================
# CactusBNMK - CLI Interface Module
# =============================================================================
# Simple command-line interface for GitHub Contribution Graph painting
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_CLI_SH_LOADED:-}" ]] && return 0
readonly _CLI_SH_LOADED=1

# Get script directory
_CLI_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Source dependencies
source "${_CLI_SCRIPT_DIR}/lib/colors.sh"
source "${_CLI_SCRIPT_DIR}/lib/config.sh"
source "${_CLI_SCRIPT_DIR}/lib/themes.sh"

# =============================================================================
# Global State
# =============================================================================

declare -g CURRENT_THEME=""

# =============================================================================
# Display Functions
# =============================================================================

# Show available commands
show_commands() {
    echo ""
    echo -e "${CLR_BOLD}Commands:${CLR_RESET}"
    echo -e "  ${CLR_CYAN}themes${CLR_RESET}                List all available themes"
    echo -e "  ${CLR_CYAN}preview <theme>${CLR_RESET}       Preview pattern (e.g., ${CLR_GREEN}preview sunset${CLR_RESET})"
    echo -e "  ${CLR_CYAN}paint <theme>${CLR_RESET}         Create commits to paint on GitHub"
    echo -e "  ${CLR_CYAN}help${CLR_RESET}                  Show this help"
    echo -e "  ${CLR_CYAN}exit${CLR_RESET}                  Exit (or Ctrl+C)"
    echo ""
}

# List themes in a compact format
list_themes_compact() {
    echo ""
    echo -e "${CLR_BOLD}Available Themes (12):${CLR_RESET}"
    echo -e "${CLR_DIM}$(printf '─%.0s' {1..52})${CLR_RESET}"
    echo ""
    echo -e "  ${CLR_YELLOW}sunset${CLR_RESET}      Rising sun at bottom"
    echo -e "  ${CLR_YELLOW}saturn${CLR_RESET}      Planet with ring"
    echo -e "  ${CLR_RED}heart${CLR_RESET}       Heart shape"
    echo -e "  ${CLR_YELLOW}pacman${CLR_RESET}      Pacman eating dots"
    echo -e "  ${CLR_CYAN}wave${CLR_RESET}        Smooth sine wave"
    echo -e "  ${CLR_YELLOW}lightning${CLR_RESET}   Zigzag bolt"
    echo -e "  ${CLR_PURPLE}galaxy${CLR_RESET}      Spiral with stars"
    echo -e "  ${CLR_GREEN}matrix${CLR_RESET}      Falling code"
    echo -e "  ${CLR_GREEN}cactus${CLR_RESET}      Cactus shape"
    echo -e "  ${CLR_CYAN}diamond${CLR_RESET}     Diamond gem"
    echo -e "  ${CLR_DIM}chess${CLR_RESET}       Checkerboard"
    echo -e "  ${CLR_GREEN}invaders${CLR_RESET}    Space invader"
    echo ""
    echo -e "${CLR_DIM}Usage: preview <theme>${CLR_RESET}"
    echo ""
}

# =============================================================================
# Command Handlers
# =============================================================================

# Handle preview command
handle_preview_command() {
    local theme="$1"

    if [[ -z "$theme" ]]; then
        echo -e "${CLR_RED}Error: Please specify a theme${CLR_RESET}"
        echo -e "Usage: ${CLR_CYAN}preview <theme>${CLR_RESET}"
        echo -e "Example: ${CLR_GREEN}preview sunset${CLR_RESET}"
        return 1
    fi

    CURRENT_THEME="$theme"
    preview_graph_pattern "$theme"
}

# Process a command
process_command() {
    local input="$1"

    # Parse command and arguments
    local cmd="${input%% *}"
    local args="${input#* }"
    [[ "$cmd" == "$args" ]] && args=""

    # Convert to lowercase
    cmd=$(echo "$cmd" | tr '[:upper:]' '[:lower:]')

    case "$cmd" in
        "preview"|"p")
            handle_preview_command $args
            ;;
        "themes"|"theme"|"t"|"list")
            list_themes_compact
            ;;
        "paint")
            run_paint_workflow $args
            ;;
        "help"|"h"|"?"|"commands")
            show_commands
            ;;
        "clear"|"cls")
            clear
            print_app_banner
            ;;
        "exit"|"quit"|"q")
            echo ""
            echo -e "${CLR_GREEN}Goodbye!${CLR_RESET}"
            echo ""
            exit 0
            ;;
        "")
            # Empty command, do nothing
            ;;
        *)
            echo -e "${CLR_RED}Unknown command: ${cmd}${CLR_RESET}"
            echo -e "Type ${CLR_CYAN}help${CLR_RESET} to see available commands"
            ;;
    esac
}

# =============================================================================
# Main Interactive CLI
# =============================================================================

run_interactive_cli() {
    # Initialize
    config_init

    # Trap for clean exit
    trap 'echo ""; echo -e "${CLR_GREEN}Goodbye!${CLR_RESET}"; echo ""; exit 0' INT TERM

    # Show banner and commands
    clear
    print_app_banner
    show_commands

    # Main command loop
    while true; do
        echo -ne "${CLR_BOLD}${CLR_CYAN}cactus>${CLR_RESET} "
        read -r input

        # Process the command
        process_command "$input"
    done
}

# =============================================================================
# Command Line Argument Handling
# =============================================================================

parse_arguments() {
    local args=("$@")
    local i=0

    while (( i < ${#args[@]} )); do
        local arg="${args[$i]}"

        case "$arg" in
            --theme|-t)
                ((i++))
                CURRENT_THEME="${args[$i]}"
                ;;
            --help|-h)
                print_app_banner
                echo "Usage: cactusbnmk [options]"
                echo ""
                echo "Options:"
                echo "  --theme, -t <theme>    Theme to use"
                echo "  --help, -h             Show this help"
                echo "  --version, -v          Show version"
                echo ""
                echo "Interactive mode: Run without arguments"
                echo ""
                echo "Commands in interactive mode:"
                echo "  themes      List all themes"
                echo "  preview     Preview a theme"
                echo "  paint       Create commits"
                echo "  exit        Exit"
                exit 0
                ;;
            --version|-v)
                echo "${APP_NAME} version ${APP_VERSION}"
                exit 0
                ;;
            *)
                echo "Unknown option: $arg"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac

        ((i++))
    done
}

run_cli_mode() {
    config_init

    if [[ -n "$CURRENT_THEME" ]]; then
        run_paint_workflow "$CURRENT_THEME"
    else
        echo "No theme specified. Use --theme or run in interactive mode."
        exit 1
    fi
}

# Legacy menu mode (for --menu flag compatibility)
run_menu_cli() {
    run_interactive_cli
}
