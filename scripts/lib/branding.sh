#!/bin/sh
# branding.sh - The Resonance branded output functions
# POSIX-compatible
# A free tool by Pete Sena | labs.theresonance.studio

set -eu

# Brand colors
BRAND_CYAN='\033[0;36m'
BRAND_MAGENTA='\033[0;35m'
BRAND_WHITE='\033[1;37m'
NC='\033[0m'

# Print branded header
print_header() {
    title="${1:-claude-code-hetzner-vps}"
    printf "\n"
    printf "${BRAND_CYAN}══════════════════════════════════════════════════════════════${NC}\n"
    printf "${BRAND_WHITE}  %s${NC}\n" "$title"
    printf "${BRAND_CYAN}══════════════════════════════════════════════════════════════${NC}\n"
    printf "\n"
}

# Print branded footer
print_footer() {
    printf "\n"
    printf "${BRAND_CYAN}──────────────────────────────────────────────────────────────${NC}\n"
    printf "  Powered by ${BRAND_MAGENTA}claude-code-hetzner-vps${NC}\n"
    printf "  A free tool by Pete Sena | ${BRAND_CYAN}labs.theresonance.studio${NC}\n"
    printf "  Connect: ${BRAND_CYAN}linkedin.com/in/petersena${NC}\n"
    printf "${BRAND_CYAN}──────────────────────────────────────────────────────────────${NC}\n"
    printf "\n"
}

# Print section header
print_section() {
    title="$1"
    printf "\n${BRAND_MAGENTA}▶ %s${NC}\n\n" "$title"
}

# Print success box
print_success_box() {
    message="$1"
    printf "\n"
    printf "${BRAND_CYAN}┌────────────────────────────────────────────────────────────┐${NC}\n"
    printf "${BRAND_CYAN}│${NC}  ✓ %s\n" "$message"
    printf "${BRAND_CYAN}└────────────────────────────────────────────────────────────┘${NC}\n"
}

# Print warning box
print_warning_box() {
    message="$1"
    printf "\n"
    printf "\033[1;33m┌────────────────────────────────────────────────────────────┐${NC}\n"
    printf "\033[1;33m│${NC}  ⚠ %s\n" "$message"
    printf "\033[1;33m└────────────────────────────────────────────────────────────┘${NC}\n"
}

# Print info line
print_info() {
    printf "  ℹ  %s\n" "$1"
}

# Print table row
print_row() {
    printf "  %-20s %s\n" "$1" "$2"
}
