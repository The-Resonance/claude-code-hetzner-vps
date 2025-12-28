#!/bin/sh
# common.sh - Shared utilities for claude-code-hetzner-vps
# POSIX-compatible shell functions
# A free tool by Pete Sena | labs.theresonance.studio

set -eu

# Colors (POSIX-safe)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Logging functions
log_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

log_success() {
    printf "${GREEN}[OK]${NC} %s\n" "$1"
}

log_warning() {
    printf "${YELLOW}[WARN]${NC} %s\n" "$1"
}

log_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1" >&2
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate server name format (RFC 1123)
validate_server_name() {
    name="$1"
    if [ -z "$name" ]; then
        log_error "Server name is required"
        return 1
    fi

    # Check length
    if [ ${#name} -gt 63 ]; then
        log_error "Server name must be 63 characters or less"
        return 1
    fi

    # Check format: lowercase alphanumeric and hyphens
    case "$name" in
        -*)
            log_error "Server name cannot start with a hyphen"
            return 1
            ;;
        *-)
            log_error "Server name cannot end with a hyphen"
            return 1
            ;;
        *[!a-z0-9-]*)
            log_error "Server name must be lowercase alphanumeric with hyphens only"
            return 1
            ;;
    esac

    return 0
}

# Check all prerequisites
check_prerequisites() {
    # Check hcloud CLI
    if ! command_exists hcloud; then
        log_error "hcloud CLI not found"
        printf "\n  Install hcloud:\n"
        printf "    macOS:  brew install hcloud\n"
        printf "    Linux:  https://github.com/hetznercloud/cli/releases\n\n"
        return 1
    fi

    # Test API authentication
    if ! hcloud server list >/dev/null 2>&1; then
        log_error "Hetzner API authentication failed"
        printf "\n  Set up authentication:\n"
        printf "    hcloud context create my-project\n"
        printf "    (Enter your API token when prompted)\n\n"
        printf "  Get an API token at:\n"
        printf "    https://console.hetzner.cloud > Security > API Tokens\n\n"
        return 1
    fi

    return 0
}

# Find SSH public key
find_ssh_key() {
    for key_path in "$HOME/.ssh/id_ed25519.pub" "$HOME/.ssh/id_rsa.pub"; do
        if [ -f "$key_path" ]; then
            printf "%s" "$key_path"
            return 0
        fi
    done

    log_error "No SSH public key found"
    printf "\n  Generate a key:\n"
    printf "    ssh-keygen -t ed25519 -C \"your@email.com\"\n\n"
    return 1
}

# Get SSH public key content
get_ssh_key_content() {
    key_path=$(find_ssh_key) || return 1
    cat "$key_path"
}

# Read sensitive input from stdin (hidden)
read_secret() {
    prompt="$1"
    printf "%s: " "$prompt" >&2
    stty -echo 2>/dev/null || true
    read -r secret
    stty echo 2>/dev/null || true
    printf "\n" >&2
    printf "%s" "$secret"
}

# Wait for SSH to become available
wait_for_ssh() {
    host="$1"
    user="${2:-claude}"
    max_attempts="${3:-30}"

    printf "  Waiting for SSH"
    attempt=1
    while [ $attempt -le $max_attempts ]; do
        if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o BatchMode=yes "$user@$host" "echo ready" >/dev/null 2>&1; then
            printf " ready!\n"
            return 0
        fi
        printf "."
        sleep 5
        attempt=$((attempt + 1))
    done

    printf " timeout\n"
    return 1
}

# Format currency
format_eur() {
    printf "%.2f EUR" "$1"
}

format_usd() {
    eur="$1"
    # Approximate EUR to USD (1.08 rate)
    if command_exists bc; then
        usd=$(printf "%.2f" "$(echo "$eur * 1.08" | bc -l)")
        printf "~%.2f USD" "$usd"
    else
        # Can't calculate without bc, show note instead
        printf "(~1.08x in USD)"
    fi
}
