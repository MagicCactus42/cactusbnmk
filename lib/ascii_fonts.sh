#!/bin/bash
# =============================================================================
# CactusBNMK - ASCII Art Fonts Module
# =============================================================================
# Multi-size ASCII art font rendering with auto-sizing
# =============================================================================

# Prevent multiple sourcing
[[ -n "${_ASCII_FONTS_SH_LOADED:-}" ]] && return 0
readonly _ASCII_FONTS_SH_LOADED=1

# =============================================================================
# Font Size Constants
# =============================================================================

readonly FONT_SIZE_SMALL=3      # 3 lines tall
readonly FONT_SIZE_MEDIUM=5     # 5 lines tall
readonly FONT_SIZE_LARGE=7      # 7 lines tall

# =============================================================================
# Font Data Storage
# Using indexed approach for better compatibility
# Format: Character definitions stored in functions
# =============================================================================

# Get small font character (3 lines tall)
_get_small_char() {
    local char="$1"
    local line="$2"

    case "$char" in
        A|a) case $line in 0) echo " _ ";; 1) echo "|_|";; 2) echo "| |";; esac; echo "3" ;;
        B|b) case $line in 0) echo "__ ";; 1) echo "|_)";; 2) echo "|_)";; esac; echo "3" ;;
        C|c) case $line in 0) echo " _ ";; 1) echo "|  ";; 2) echo "|_ ";; esac; echo "3" ;;
        D|d) case $line in 0) echo "__ ";; 1) echo "| \\";; 2) echo "|_/";; esac; echo "3" ;;
        E|e) case $line in 0) echo " _ ";; 1) echo "|_ ";; 2) echo "|_ ";; esac; echo "3" ;;
        F|f) case $line in 0) echo " _ ";; 1) echo "|_ ";; 2) echo "|  ";; esac; echo "3" ;;
        G|g) case $line in 0) echo " _ ";; 1) echo "| '";; 2) echo "|_)";; esac; echo "3" ;;
        H|h) case $line in 0) echo "   ";; 1) echo "|_|";; 2) echo "| |";; esac; echo "3" ;;
        I|i) case $line in 0) echo "_";; 1) echo "|";; 2) echo "|";; esac; echo "1" ;;
        J|j) case $line in 0) echo " _";; 1) echo " |";; 2) echo "_|";; esac; echo "2" ;;
        K|k) case $line in 0) echo "   ";; 1) echo "|/ ";; 2) echo "|\\ ";; esac; echo "3" ;;
        L|l) case $line in 0) echo "   ";; 1) echo "|  ";; 2) echo "|_ ";; esac; echo "3" ;;
        M|m) case $line in 0) echo "    ";; 1) echo "|\\/|";; 2) echo "|  |";; esac; echo "4" ;;
        N|n) case $line in 0) echo "    ";; 1) echo "|\\ |";; 2) echo "| \\|";; esac; echo "4" ;;
        O|o) case $line in 0) echo " _ ";; 1) echo "| |";; 2) echo "|_|";; esac; echo "3" ;;
        P|p) case $line in 0) echo " _ ";; 1) echo "|_)";; 2) echo "|  ";; esac; echo "3" ;;
        Q|q) case $line in 0) echo " _ ";; 1) echo "| |";; 2) echo "|_\\";; esac; echo "3" ;;
        R|r) case $line in 0) echo " _ ";; 1) echo "|_)";; 2) echo "|\\ ";; esac; echo "3" ;;
        S|s) case $line in 0) echo " _ ";; 1) echo "(_ ";; 2) echo " _)";; esac; echo "3" ;;
        T|t) case $line in 0) echo "___";; 1) echo " | ";; 2) echo " | ";; esac; echo "3" ;;
        U|u) case $line in 0) echo "   ";; 1) echo "| |";; 2) echo "|_|";; esac; echo "3" ;;
        V|v) case $line in 0) echo "   ";; 1) echo "\\ /";; 2) echo " V ";; esac; echo "3" ;;
        W|w) case $line in 0) echo "    ";; 1) echo "|  |";; 2) echo "|/\\|";; esac; echo "4" ;;
        X|x) case $line in 0) echo "   ";; 1) echo "\\ /";; 2) echo "/ \\";; esac; echo "3" ;;
        Y|y) case $line in 0) echo "   ";; 1) echo "\\ /";; 2) echo " | ";; esac; echo "3" ;;
        Z|z) case $line in 0) echo "__";; 1) echo " /";; 2) echo "/_";; esac; echo "2" ;;
        0)   case $line in 0) echo " _ ";; 1) echo "|/|";; 2) echo "|_|";; esac; echo "3" ;;
        1)   case $line in 0) echo "  ";; 1) echo "/|";; 2) echo " |";; esac; echo "2" ;;
        2)   case $line in 0) echo " _ ";; 1) echo " _)";; 2) echo "|_ ";; esac; echo "3" ;;
        3)   case $line in 0) echo "__";; 1) echo "_)";; 2) echo "__)";; esac; echo "3" ;;
        4)   case $line in 0) echo "   ";; 1) echo "|_|";; 2) echo "  |";; esac; echo "3" ;;
        5)   case $line in 0) echo " _ ";; 1) echo "|_ ";; 2) echo " _)";; esac; echo "3" ;;
        6)   case $line in 0) echo " _ ";; 1) echo "|_ ";; 2) echo "|_)";; esac; echo "3" ;;
        7)   case $line in 0) echo "__";; 1) echo " /";; 2) echo "/ ";; esac; echo "2" ;;
        8)   case $line in 0) echo " _ ";; 1) echo "(_)";; 2) echo "(_)";; esac; echo "3" ;;
        9)   case $line in 0) echo " _ ";; 1) echo "(_|";; 2) echo " _|";; esac; echo "3" ;;
        " ") case $line in 0) echo "  ";; 1) echo "  ";; 2) echo "  ";; esac; echo "2" ;;
        ".") case $line in 0) echo " ";; 1) echo " ";; 2) echo ".";; esac; echo "1" ;;
        "-") case $line in 0) echo "  ";; 1) echo "__";; 2) echo "  ";; esac; echo "2" ;;
        "_") case $line in 0) echo "  ";; 1) echo "  ";; 2) echo "__";; esac; echo "2" ;;
        "@") case $line in 0) echo " __ ";; 1) echo "(o_)";; 2) echo " \\_'";; esac; echo "4" ;;
        *)   case $line in 0) echo "  ";; 1) echo "  ";; 2) echo "  ";; esac; echo "2" ;;
    esac
}

# Get medium font character (5 lines tall)
_get_medium_char() {
    local char="$1"
    local line="$2"

    case "$char" in
        A|a) case $line in 0) echo "  _   ";; 1) echo " / \\  ";; 2) echo "/___\\ ";; 3) echo "|   | ";; 4) echo "|   | ";; esac; echo "6" ;;
        B|b) case $line in 0) echo " ___  ";; 1) echo "|   ) ";; 2) echo "|___\\ ";; 3) echo "|   ) ";; 4) echo "|___/ ";; esac; echo "6" ;;
        C|c) case $line in 0) echo " ____ ";; 1) echo "/    \\";; 2) echo "|     ";; 3) echo "|     ";; 4) echo "\\____/";; esac; echo "6" ;;
        D|d) case $line in 0) echo " ___  ";; 1) echo "|   \\ ";; 2) echo "|    |";; 3) echo "|   / ";; 4) echo "|__/  ";; esac; echo "6" ;;
        E|e) case $line in 0) echo " ____ ";; 1) echo "|     ";; 2) echo "|___  ";; 3) echo "|     ";; 4) echo "|____ ";; esac; echo "6" ;;
        F|f) case $line in 0) echo " ____ ";; 1) echo "|     ";; 2) echo "|___  ";; 3) echo "|     ";; 4) echo "|     ";; esac; echo "6" ;;
        G|g) case $line in 0) echo " ____ ";; 1) echo "/     ";; 2) echo "|  __ ";; 3) echo "|   | ";; 4) echo "\\___/ ";; esac; echo "6" ;;
        H|h) case $line in 0) echo "|   | ";; 1) echo "|   | ";; 2) echo "|___| ";; 3) echo "|   | ";; 4) echo "|   | ";; esac; echo "6" ;;
        I|i) case $line in 0) echo " ___ ";; 1) echo "  |  ";; 2) echo "  |  ";; 3) echo "  |  ";; 4) echo " _|_ ";; esac; echo "5" ;;
        J|j) case $line in 0) echo "   __ ";; 1) echo "    | ";; 2) echo "    | ";; 3) echo "|   | ";; 4) echo " \\__/ ";; esac; echo "6" ;;
        K|k) case $line in 0) echo "|   / ";; 1) echo "|  /  ";; 2) echo "| <   ";; 3) echo "|  \\  ";; 4) echo "|   \\ ";; esac; echo "6" ;;
        L|l) case $line in 0) echo "|     ";; 1) echo "|     ";; 2) echo "|     ";; 3) echo "|     ";; 4) echo "|____ ";; esac; echo "6" ;;
        M|m) case $line in 0) echo "|\\   /|";; 1) echo "| \\ / |";; 2) echo "|  V  |";; 3) echo "|     |";; 4) echo "|     |";; esac; echo "7" ;;
        N|n) case $line in 0) echo "|\\    |";; 1) echo "| \\   |";; 2) echo "|  \\  |";; 3) echo "|   \\ |";; 4) echo "|    \\|";; esac; echo "7" ;;
        O|o) case $line in 0) echo " ___  ";; 1) echo "/   \\ ";; 2) echo "|   | ";; 3) echo "|   | ";; 4) echo "\\___/ ";; esac; echo "6" ;;
        P|p) case $line in 0) echo " ___  ";; 1) echo "|   | ";; 2) echo "|___/ ";; 3) echo "|     ";; 4) echo "|     ";; esac; echo "6" ;;
        Q|q) case $line in 0) echo " ___  ";; 1) echo "/   \\ ";; 2) echo "|   | ";; 3) echo "|  \\| ";; 4) echo "\\___\\ ";; esac; echo "6" ;;
        R|r) case $line in 0) echo " ___  ";; 1) echo "|   | ";; 2) echo "|___/ ";; 3) echo "|  \\  ";; 4) echo "|   \\ ";; esac; echo "6" ;;
        S|s) case $line in 0) echo " ____ ";; 1) echo "/     ";; 2) echo "\\___  ";; 3) echo "    | ";; 4) echo "\\___/ ";; esac; echo "6" ;;
        T|t) case $line in 0) echo " _____ ";; 1) echo "   |   ";; 2) echo "   |   ";; 3) echo "   |   ";; 4) echo "   |   ";; esac; echo "7" ;;
        U|u) case $line in 0) echo "|   | ";; 1) echo "|   | ";; 2) echo "|   | ";; 3) echo "|   | ";; 4) echo "\\___/ ";; esac; echo "6" ;;
        V|v) case $line in 0) echo "|   | ";; 1) echo "|   | ";; 2) echo " \\ /  ";; 3) echo "  V   ";; 4) echo "      ";; esac; echo "6" ;;
        W|w) case $line in 0) echo "|     |";; 1) echo "|     |";; 2) echo "|  _  |";; 3) echo "\\ / \\ /";; 4) echo " V   V ";; esac; echo "7" ;;
        X|x) case $line in 0) echo "\\   / ";; 1) echo " \\ /  ";; 2) echo "  X   ";; 3) echo " / \\  ";; 4) echo "/   \\ ";; esac; echo "6" ;;
        Y|y) case $line in 0) echo "\\   / ";; 1) echo " \\ /  ";; 2) echo "  |   ";; 3) echo "  |   ";; 4) echo "  |   ";; esac; echo "6" ;;
        Z|z) case $line in 0) echo "_____ ";; 1) echo "   /  ";; 2) echo "  /   ";; 3) echo " /    ";; 4) echo "_____ ";; esac; echo "6" ;;
        0)   case $line in 0) echo " ___  ";; 1) echo "|   | ";; 2) echo "| / | ";; 3) echo "|/  | ";; 4) echo "\\___/ ";; esac; echo "6" ;;
        1)   case $line in 0) echo "  /|  ";; 1) echo " / |  ";; 2) echo "   |  ";; 3) echo "   |  ";; 4) echo " __|_ ";; esac; echo "6" ;;
        2)   case $line in 0) echo " ___  ";; 1) echo "|   | ";; 2) echo "   /  ";; 3) echo "  /   ";; 4) echo "|____| ";; esac; echo "6" ;;
        3)   case $line in 0) echo " ___  ";; 1) echo "|   | ";; 2) echo "  __/ ";; 3) echo "|   | ";; 4) echo "\\___/ ";; esac; echo "6" ;;
        4)   case $line in 0) echo "|   | ";; 1) echo "|   | ";; 2) echo "|___| ";; 3) echo "    | ";; 4) echo "    | ";; esac; echo "6" ;;
        5)   case $line in 0) echo " ____ ";; 1) echo "|     ";; 2) echo "|___  ";; 3) echo "    | ";; 4) echo "\\___/ ";; esac; echo "6" ;;
        6)   case $line in 0) echo " ___  ";; 1) echo "/     ";; 2) echo "|___  ";; 3) echo "|   | ";; 4) echo "\\___/ ";; esac; echo "6" ;;
        7)   case $line in 0) echo "_____ ";; 1) echo "    / ";; 2) echo "   /  ";; 3) echo "  /   ";; 4) echo " /    ";; esac; echo "6" ;;
        8)   case $line in 0) echo " ___  ";; 1) echo "|   | ";; 2) echo " \\_/  ";; 3) echo "|   | ";; 4) echo "\\___/ ";; esac; echo "6" ;;
        9)   case $line in 0) echo " ___  ";; 1) echo "|   | ";; 2) echo "\\___| ";; 3) echo "    | ";; 4) echo "\\___/ ";; esac; echo "6" ;;
        " ") case $line in 0) echo "    ";; 1) echo "    ";; 2) echo "    ";; 3) echo "    ";; 4) echo "    ";; esac; echo "4" ;;
        ".") case $line in 0) echo "  ";; 1) echo "  ";; 2) echo "  ";; 3) echo "  ";; 4) echo " o";; esac; echo "2" ;;
        "-") case $line in 0) echo "     ";; 1) echo "     ";; 2) echo "-----";; 3) echo "     ";; 4) echo "     ";; esac; echo "5" ;;
        "_") case $line in 0) echo "     ";; 1) echo "     ";; 2) echo "     ";; 3) echo "     ";; 4) echo "_____";; esac; echo "5" ;;
        "@") case $line in 0) echo " ____ ";; 1) echo "/    \\";; 2) echo "| () |";; 3) echo "|\\__/|";; 4) echo " \\__/ ";; esac; echo "6" ;;
        *)   case $line in 0) echo "    ";; 1) echo "    ";; 2) echo "    ";; 3) echo "    ";; 4) echo "    ";; esac; echo "4" ;;
    esac
}

# Get large font character (7 lines tall)
_get_large_char() {
    local char="$1"
    local line="$2"

    case "$char" in
        A|a) case $line in 0) echo "   _    ";; 1) echo "  / \\   ";; 2) echo " / _ \\  ";; 3) echo "/ ___ \\ ";; 4) echo "|/   \\| ";; 5) echo "|     | ";; 6) echo "|     | ";; esac; echo "8" ;;
        B|b) case $line in 0) echo " ____  ";; 1) echo "|  _ \\ ";; 2) echo "| |_) |";; 3) echo "|  _ < ";; 4) echo "| |_) |";; 5) echo "|____/ ";; 6) echo "       ";; esac; echo "7" ;;
        C|c) case $line in 0) echo "  _____ ";; 1) echo " / ____|";; 2) echo "| |     ";; 3) echo "| |     ";; 4) echo "| |____ ";; 5) echo " \\_____|";; 6) echo "        ";; esac; echo "8" ;;
        D|d) case $line in 0) echo " _____  ";; 1) echo "|  __ \\ ";; 2) echo "| |  | |";; 3) echo "| |  | |";; 4) echo "| |__| |";; 5) echo "|_____/ ";; 6) echo "        ";; esac; echo "8" ;;
        E|e) case $line in 0) echo " ______ ";; 1) echo "|  ____|";; 2) echo "| |__   ";; 3) echo "|  __|  ";; 4) echo "| |____ ";; 5) echo "|______|";; 6) echo "        ";; esac; echo "8" ;;
        F|f) case $line in 0) echo " ______ ";; 1) echo "|  ____|";; 2) echo "| |__   ";; 3) echo "|  __|  ";; 4) echo "| |     ";; 5) echo "|_|     ";; 6) echo "        ";; esac; echo "8" ;;
        G|g) case $line in 0) echo "  _____ ";; 1) echo " / ____|";; 2) echo "| |  __ ";; 3) echo "| | |_ |";; 4) echo "| |__| |";; 5) echo " \\_____|";; 6) echo "        ";; esac; echo "8" ;;
        H|h) case $line in 0) echo " _    _ ";; 1) echo "| |  | |";; 2) echo "| |__| |";; 3) echo "|  __  |";; 4) echo "| |  | |";; 5) echo "|_|  |_|";; 6) echo "        ";; esac; echo "8" ;;
        I|i) case $line in 0) echo " _____ ";; 1) echo "|_   _|";; 2) echo "  | |  ";; 3) echo "  | |  ";; 4) echo " _| |_ ";; 5) echo "|_____|";; 6) echo "       ";; esac; echo "7" ;;
        J|j) case $line in 0) echo "      _ ";; 1) echo "     | |";; 2) echo "     | |";; 3) echo " _   | |";; 4) echo "| |__| |";; 5) echo " \\____/ ";; 6) echo "        ";; esac; echo "8" ;;
        K|k) case $line in 0) echo " _  __ ";; 1) echo "| |/ / ";; 2) echo "| ' /  ";; 3) echo "|  <   ";; 4) echo "| . \\  ";; 5) echo "|_|\\_\\ ";; 6) echo "       ";; esac; echo "7" ;;
        L|l) case $line in 0) echo " _      ";; 1) echo "| |     ";; 2) echo "| |     ";; 3) echo "| |     ";; 4) echo "| |____ ";; 5) echo "|______|";; 6) echo "        ";; esac; echo "8" ;;
        M|m) case $line in 0) echo " __  __ ";; 1) echo "|  \\/  |";; 2) echo "| \\  / |";; 3) echo "| |\\/| |";; 4) echo "| |  | |";; 5) echo "|_|  |_|";; 6) echo "        ";; esac; echo "8" ;;
        N|n) case $line in 0) echo " _   _ ";; 1) echo "| \\ | |";; 2) echo "|  \\| |";; 3) echo "| . \` |";; 4) echo "| |\\  |";; 5) echo "|_| \\_|";; 6) echo "       ";; esac; echo "7" ;;
        O|o) case $line in 0) echo "  ____  ";; 1) echo " / __ \\ ";; 2) echo "| |  | |";; 3) echo "| |  | |";; 4) echo "| |__| |";; 5) echo " \\____/ ";; 6) echo "        ";; esac; echo "8" ;;
        P|p) case $line in 0) echo " _____  ";; 1) echo "|  __ \\ ";; 2) echo "| |__) |";; 3) echo "|  ___/ ";; 4) echo "| |     ";; 5) echo "|_|     ";; 6) echo "        ";; esac; echo "8" ;;
        Q|q) case $line in 0) echo "  ____  ";; 1) echo " / __ \\ ";; 2) echo "| |  | |";; 3) echo "| |  | |";; 4) echo "| |__| |";; 5) echo " \\___\\_\\";; 6) echo "        ";; esac; echo "8" ;;
        R|r) case $line in 0) echo " _____  ";; 1) echo "|  __ \\ ";; 2) echo "| |__) |";; 3) echo "|  _  / ";; 4) echo "| | \\ \\ ";; 5) echo "|_|  \\_\\";; 6) echo "        ";; esac; echo "8" ;;
        S|s) case $line in 0) echo "  _____ ";; 1) echo " / ____|";; 2) echo "| (___  ";; 3) echo " \\___ \\ ";; 4) echo " ____) |";; 5) echo "|_____/ ";; 6) echo "        ";; esac; echo "8" ;;
        T|t) case $line in 0) echo " _______ ";; 1) echo "|__   __|";; 2) echo "   | |   ";; 3) echo "   | |   ";; 4) echo "   | |   ";; 5) echo "   |_|   ";; 6) echo "         ";; esac; echo "9" ;;
        U|u) case $line in 0) echo " _    _ ";; 1) echo "| |  | |";; 2) echo "| |  | |";; 3) echo "| |  | |";; 4) echo "| |__| |";; 5) echo " \\____/ ";; 6) echo "        ";; esac; echo "8" ;;
        V|v) case $line in 0) echo "__      __";; 1) echo "\\ \\    / /";; 2) echo " \\ \\  / / ";; 3) echo "  \\ \\/ /  ";; 4) echo "   \\  /   ";; 5) echo "    \\/    ";; 6) echo "          ";; esac; echo "10" ;;
        W|w) case $line in 0) echo "__        __";; 1) echo "\\ \\      / /";; 2) echo " \\ \\ /\\ / / ";; 3) echo "  \\ V  V /  ";; 4) echo "   \\_/\\_/   ";; 5) echo "            ";; 6) echo "            ";; esac; echo "12" ;;
        X|x) case $line in 0) echo "__   __";; 1) echo "\\ \\ / /";; 2) echo " \\ V / ";; 3) echo "  > <  ";; 4) echo " / . \\ ";; 5) echo "/_/ \\_\\";; 6) echo "       ";; esac; echo "7" ;;
        Y|y) case $line in 0) echo "__   __";; 1) echo "\\ \\ / /";; 2) echo " \\ V / ";; 3) echo "  | |  ";; 4) echo "  | |  ";; 5) echo "  |_|  ";; 6) echo "       ";; esac; echo "7" ;;
        Z|z) case $line in 0) echo " ______";; 1) echo "|___  /";; 2) echo "   / / ";; 3) echo "  / /  ";; 4) echo " / /__ ";; 5) echo "/_____|";; 6) echo "       ";; esac; echo "7" ;;
        0)   case $line in 0) echo "  ___  ";; 1) echo " / _ \\ ";; 2) echo "| | | |";; 3) echo "| |/| |";; 4) echo "| |_| |";; 5) echo " \\___/ ";; 6) echo "       ";; esac; echo "7" ;;
        1)   case $line in 0) echo "  __  ";; 1) echo " /  | ";; 2) echo "/_/| | ";; 3) echo "   | | ";; 4) echo "   | | ";; 5) echo "   |_| ";; 6) echo "       ";; esac; echo "6" ;;
        2)   case $line in 0) echo " ___  ";; 1) echo "|__ \\ ";; 2) echo "  ) | ";; 3) echo " / /  ";; 4) echo "/ /__ ";; 5) echo "|_____|";; 6) echo "       ";; esac; echo "6" ;;
        3)   case $line in 0) echo " ____  ";; 1) echo "|___ \\ ";; 2) echo "  __) |";; 3) echo " |__ < ";; 4) echo " ___) |";; 5) echo "|____/ ";; 6) echo "       ";; esac; echo "7" ;;
        4)   case $line in 0) echo " _  _   ";; 1) echo "| || |  ";; 2) echo "| || |_ ";; 3) echo "|__   _|";; 4) echo "   | |  ";; 5) echo "   |_|  ";; 6) echo "        ";; esac; echo "8" ;;
        5)   case $line in 0) echo " _____ ";; 1) echo "|  ___|";; 2) echo "| |__  ";; 3) echo "|___ \\ ";; 4) echo " ___) |";; 5) echo "|____/ ";; 6) echo "       ";; esac; echo "7" ;;
        6)   case $line in 0) echo "  __   ";; 1) echo " / /_  ";; 2) echo "| '_ \\ ";; 3) echo "| (_) |";; 4) echo " \\___/ ";; 5) echo "       ";; 6) echo "       ";; esac; echo "7" ;;
        7)   case $line in 0) echo " ______ ";; 1) echo "|____  |";; 2) echo "    / / ";; 3) echo "   / /  ";; 4) echo "  / /   ";; 5) echo " /_/    ";; 6) echo "        ";; esac; echo "8" ;;
        8)   case $line in 0) echo "  ___  ";; 1) echo " ( _ ) ";; 2) echo " / _ \\ ";; 3) echo "| (_) |";; 4) echo " \\___/ ";; 5) echo "       ";; 6) echo "       ";; esac; echo "7" ;;
        9)   case $line in 0) echo "  ___  ";; 1) echo " / _ \\ ";; 2) echo "| (_) |";; 3) echo " \\__, |";; 4) echo "   / / ";; 5) echo "  /_/  ";; 6) echo "       ";; esac; echo "7" ;;
        " ") case $line in 0) echo "      ";; 1) echo "      ";; 2) echo "      ";; 3) echo "      ";; 4) echo "      ";; 5) echo "      ";; 6) echo "      ";; esac; echo "6" ;;
        ".") case $line in 0) echo "   ";; 1) echo "   ";; 2) echo "   ";; 3) echo "   ";; 4) echo " _ ";; 5) echo "(_)";; 6) echo "   ";; esac; echo "3" ;;
        "-") case $line in 0) echo "       ";; 1) echo "       ";; 2) echo "       ";; 3) echo " _____ ";; 4) echo "|_____|";; 5) echo "       ";; 6) echo "       ";; esac; echo "7" ;;
        "_") case $line in 0) echo "       ";; 1) echo "       ";; 2) echo "       ";; 3) echo "       ";; 4) echo "       ";; 5) echo " _____ ";; 6) echo "|_____|";; esac; echo "7" ;;
        "@") case $line in 0) echo "   ____   ";; 1) echo "  / __ \\  ";; 2) echo " / / _\` | ";; 3) echo "| | (_| | ";; 4) echo " \\ \\__,_| ";; 5) echo "  \\____/  ";; 6) echo "          ";; esac; echo "10" ;;
        *)   case $line in 0) echo "      ";; 1) echo "      ";; 2) echo "      ";; 3) echo "      ";; 4) echo "      ";; 5) echo "      ";; 6) echo "      ";; esac; echo "6" ;;
    esac
}

# =============================================================================
# Font Access Functions
# =============================================================================

# Get character width for a specific font size
# Usage: get_char_width <char> <size>
get_char_width() {
    local char="$1"
    local size="$2"
    local result

    case "$size" in
        "$FONT_SIZE_SMALL"|3)
            result=$(_get_small_char "$char" "w")
            ;;
        "$FONT_SIZE_MEDIUM"|5)
            result=$(_get_medium_char "$char" "w")
            ;;
        "$FONT_SIZE_LARGE"|7)
            result=$(_get_large_char "$char" "w")
            ;;
        *)
            result=$(_get_medium_char "$char" "w")
            ;;
    esac

    # Extract just the width (last line of output)
    echo "$result" | tail -1
}

# Get character line at specific row
# Usage: get_char_line <char> <size> <line_num>
get_char_line() {
    local char="$1"
    local size="$2"
    local line_num="$3"
    local result

    case "$size" in
        "$FONT_SIZE_SMALL"|3)
            result=$(_get_small_char "$char" "$line_num")
            ;;
        "$FONT_SIZE_MEDIUM"|5)
            result=$(_get_medium_char "$char" "$line_num")
            ;;
        "$FONT_SIZE_LARGE"|7)
            result=$(_get_large_char "$char" "$line_num")
            ;;
        *)
            result=$(_get_medium_char "$char" "$line_num")
            ;;
    esac

    # Return just the character line (first line of output)
    echo "$result" | head -1
}

# =============================================================================
# Text Width Calculation
# =============================================================================

# Calculate total width of text at given font size
# Usage: calculate_text_width <text> <size>
calculate_text_width() {
    local text="$1"
    local size="$2"
    local total_width=0
    local spacing=1  # Space between characters

    for ((i = 0; i < ${#text}; i++)); do
        local char="${text:$i:1}"
        local char_width
        char_width=$(get_char_width "$char" "$size")
        total_width=$((total_width + char_width))

        # Add spacing between characters (except after last)
        if ((i < ${#text} - 1)); then
            total_width=$((total_width + spacing))
        fi
    done

    echo "$total_width"
}

# =============================================================================
# Auto-Size Detection
# =============================================================================

# Find optimal font size that fits text in given dimensions
# Usage: find_optimal_font_size <text> <max_width> <max_height>
# Returns: font size (3, 5, or 7)
find_optimal_font_size() {
    local text="$1"
    local max_width="${2:-80}"
    local max_height="${3:-20}"
    local padding="${4:-2}"  # Horizontal padding on each side

    local available_width=$((max_width - padding * 2))
    local available_height=$((max_height - 2))  # Leave some vertical margin

    # Try large first, then medium, then small
    local sizes=("$FONT_SIZE_LARGE" "$FONT_SIZE_MEDIUM" "$FONT_SIZE_SMALL")

    for size in "${sizes[@]}"; do
        local text_width
        text_width=$(calculate_text_width "$text" "$size")

        # Check if it fits both horizontally and vertically
        if ((text_width <= available_width && size <= available_height)); then
            echo "$size"
            return 0
        fi
    done

    # If nothing fits, return smallest
    echo "$FONT_SIZE_SMALL"
}

# =============================================================================
# ASCII Art Text Rendering
# =============================================================================

# Render text as ASCII art
# Usage: render_ascii_text <text> <size>
# Returns: multi-line ASCII art string
render_ascii_text() {
    local text="$1"
    local size="$2"
    local spacing=1  # Space between characters

    local lines=()

    # Initialize empty lines array
    for ((line = 0; line < size; line++)); do
        lines[$line]=""
    done

    # Build each line by concatenating characters
    for ((i = 0; i < ${#text}; i++)); do
        local char="${text:$i:1}"

        for ((line = 0; line < size; line++)); do
            local char_line
            char_line=$(get_char_line "$char" "$size" "$line")
            lines[$line]+="$char_line"

            # Add spacing between characters (except after last)
            if ((i < ${#text} - 1)); then
                lines[$line]+=$(printf '%*s' "$spacing" "")
            fi
        done
    done

    # Output all lines
    for ((line = 0; line < size; line++)); do
        echo "${lines[$line]}"
    done
}

# Render text centered in given width
# Usage: render_ascii_text_centered <text> <size> <total_width>
render_ascii_text_centered() {
    local text="$1"
    local size="$2"
    local total_width="$3"

    local text_width
    text_width=$(calculate_text_width "$text" "$size")

    local padding=$(( (total_width - text_width) / 2 ))
    ((padding < 0)) && padding=0

    local pad_str
    pad_str=$(printf '%*s' "$padding" "")

    # Render and center each line
    while IFS= read -r line; do
        echo "${pad_str}${line}"
    done < <(render_ascii_text "$text" "$size")
}

# =============================================================================
# Text Grid Generation for Banner Integration
# =============================================================================

# Global variables for text grid
declare -g TEXT_GRID_HEIGHT=0
declare -g TEXT_GRID_WIDTH=0
declare -g TEXT_START_X=0
declare -g TEXT_START_Y=0
declare -ga TEXT_GRID_LINES=()

# Generate a 2D grid of the ASCII text for overlay
# Usage: generate_text_grid <text> <size> <banner_width> <banner_height>
generate_text_grid() {
    local text="$1"
    local size="$2"
    local banner_width="$3"
    local banner_height="$4"

    # Calculate dimensions
    local text_width
    text_width=$(calculate_text_width "$text" "$size")

    # Calculate centering
    TEXT_GRID_WIDTH=$text_width
    TEXT_GRID_HEIGHT=$size
    TEXT_START_X=$(( (banner_width - text_width) / 2 ))
    TEXT_START_Y=$(( (banner_height - size) / 2 ))

    ((TEXT_START_X < 0)) && TEXT_START_X=0
    ((TEXT_START_Y < 0)) && TEXT_START_Y=0

    # Generate the text lines
    TEXT_GRID_LINES=()
    local line_num=0
    while IFS= read -r line; do
        TEXT_GRID_LINES[$line_num]="$line"
        ((line_num++))
    done < <(render_ascii_text "$text" "$size")
}

# Check if position is within text area and return the character
# Usage: get_text_char_at <x> <y>
# Returns: character at position or empty string if outside text
get_text_char_at() {
    local x="$1"
    local y="$2"

    # Check if we're in the text area
    if ((y >= TEXT_START_Y && y < TEXT_START_Y + TEXT_GRID_HEIGHT)); then
        if ((x >= TEXT_START_X && x < TEXT_START_X + TEXT_GRID_WIDTH)); then
            local text_y=$((y - TEXT_START_Y))
            local text_x=$((x - TEXT_START_X))
            local line="${TEXT_GRID_LINES[$text_y]:-}"

            if ((text_x < ${#line})); then
                local char="${line:$text_x:1}"
                # Only return non-space characters
                if [[ "$char" != " " ]]; then
                    echo "$char"
                    return 0
                fi
            fi
        fi
    fi

    echo ""
}

# Check if position is within text bounding box
# Usage: is_in_text_area <x> <y>
is_in_text_area() {
    local x="$1"
    local y="$2"

    if ((y >= TEXT_START_Y && y < TEXT_START_Y + TEXT_GRID_HEIGHT)); then
        if ((x >= TEXT_START_X && x < TEXT_START_X + TEXT_GRID_WIDTH)); then
            return 0
        fi
    fi
    return 1
}

# =============================================================================
# High-Level API for Banner Generator
# =============================================================================

# Initialize ASCII text overlay for banner generation
# Usage: init_ascii_text_overlay <text> <banner_width> <banner_height>
# This will automatically find the best font size
init_ascii_text_overlay() {
    local text="$1"
    local banner_width="${2:-80}"
    local banner_height="${3:-20}"

    if [[ -z "$text" ]]; then
        # No text, disable overlay
        TEXT_GRID_HEIGHT=0
        TEXT_GRID_WIDTH=0
        TEXT_START_X=0
        TEXT_START_Y=0
        TEXT_GRID_LINES=()
        return
    fi

    # Convert to uppercase for consistent rendering
    text=$(echo "$text" | tr '[:lower:]' '[:upper:]')

    # Find optimal font size
    local optimal_size
    optimal_size=$(find_optimal_font_size "$text" "$banner_width" "$banner_height")

    # Generate the text grid
    generate_text_grid "$text" "$optimal_size" "$banner_width" "$banner_height"
}

# Get the font size that was selected for current text
get_current_font_size() {
    echo "${TEXT_GRID_HEIGHT:-0}"
}
