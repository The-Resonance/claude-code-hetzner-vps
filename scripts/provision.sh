#!/bin/sh
# provision.sh - Main provisioning script for claude-code-hetzner-vps
# POSIX-compatible
# A free tool by Pete Sena | labs.theresonance.studio

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/lib/common.sh"
. "${SCRIPT_DIR}/lib/branding.sh"
. "${SCRIPT_DIR}/lib/security.sh"
. "${SCRIPT_DIR}/lib/hcloud.sh"

# Default values
DEFAULT_SERVER_TYPE="cx22"
DEFAULT_LOCATION="nbg1"
DEFAULT_USERNAME="claude"
SSH_KEY_NAME="claude-code-hetzner-vps"

# Show usage
usage() {
    cat << EOF
Usage: provision.sh <server-name> [server-type] [location]

Arguments:
  server-name    Name for your server (required, lowercase alphanumeric with hyphens)
  server-type    Hetzner server type (default: cx22)
  location       Datacenter location (default: nbg1)

Server Types:
  cx22   2 vCPU, 4 GB RAM   ~4.49 EUR/month (default)
  cx32   4 vCPU, 8 GB RAM   ~8.98 EUR/month
  cax11  2 ARM, 4 GB RAM    ~3.79 EUR/month (cheapest)

Locations:
  nbg1   Nuremberg, Germany (default)
  fsn1   Falkenstein, Germany
  hel1   Helsinki, Finland
  ash    Ashburn, USA
  hil    Hillsboro, USA

Example:
  provision.sh my-dev-server cx22 nbg1
EOF
}

main() {
    # Parse arguments
    if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
        usage
        exit 0
    fi

    server_name="${1:-}"
    server_type="${2:-$DEFAULT_SERVER_TYPE}"
    location="${3:-$DEFAULT_LOCATION}"

    print_header "Provisioning Secure Hetzner VPS"

    # Validate server name
    if [ -z "$server_name" ]; then
        log_error "Server name is required"
        printf "\n"
        usage
        exit 1
    fi

    validate_server_name "$server_name" || exit 1

    # Check prerequisites
    print_section "Checking Prerequisites"
    check_prerequisites || exit 1
    log_success "hcloud CLI configured and authenticated"

    # Find SSH key
    ssh_key_path=$(find_ssh_key) || exit 1
    ssh_pub_key=$(cat "$ssh_key_path")
    log_success "Found SSH key: $ssh_key_path"

    # Check if server already exists
    if hcloud_server_exists "$server_name"; then
        log_error "Server '$server_name' already exists"
        printf "\n  Choose a different name or delete the existing server:\n"
        printf "    /destroy %s\n\n" "$server_name"
        exit 1
    fi

    # Display configuration
    print_section "Configuration"
    print_row "Server Name:" "$server_name"
    print_row "Server Type:" "$server_type"
    print_row "Location:" "$location"
    print_row "Image:" "Ubuntu 24.04 LTS"
    print_row "Username:" "$DEFAULT_USERNAME"

    # Ensure SSH key exists in Hetzner
    print_section "Setting Up SSH Key"
    hcloud_ensure_ssh_key "$SSH_KEY_NAME" "$ssh_key_path"
    log_success "SSH key ready in Hetzner account"

    # Generate cloud-init configuration
    print_section "Generating Security Configuration"
    user_data_file=$(mktemp)
    trap 'rm -f "$user_data_file"' EXIT

    generate_cloud_init "$DEFAULT_USERNAME" "$ssh_pub_key" > "$user_data_file"
    log_success "Generated cloud-init with security hardening"

    # Create server
    print_section "Creating Server"
    log_info "Provisioning server (this takes about 30 seconds)..."
    hcloud_create_server "$server_name" "$server_type" "$location" "$SSH_KEY_NAME" "$user_data_file"

    # Wait for server to be running
    printf "  Waiting for server to start"
    if hcloud_wait_for_running "$server_name" 30; then
        printf " done!\n"
    else
        log_error "Server did not start in time"
        exit 1
    fi

    # Get server IP
    server_ip=$(hcloud_get_ip "$server_name")

    # Display success
    print_success_box "Server provisioned successfully!"

    print_section "Connection Details"
    print_row "Server IP:" "$server_ip"
    print_row "SSH Command:" "ssh ${DEFAULT_USERNAME}@${server_ip}"
    print_row "Claude Code:" "Available after ~2 minutes"

    print_section "Security Features Enabled"
    printf "  ✓ UFW firewall (port 22 only)\n"
    printf "  ✓ fail2ban SSH protection\n"
    printf "  ✓ SSH key-only authentication\n"
    printf "  ✓ Root login disabled\n"
    printf "  ✓ Automatic security updates\n"

    print_section "Next Steps"
    printf "  1. Wait 2 minutes for cloud-init to complete\n"
    printf "  2. Connect: ssh %s@%s\n" "$DEFAULT_USERNAME" "$server_ip"
    printf "  3. Start using Claude Code: claude\n"

    print_footer
}

main "$@"
