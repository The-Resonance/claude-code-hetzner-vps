#!/bin/sh
# destroy.sh - Safe server destruction with confirmation
# POSIX-compatible
# A free tool by Pete Sena | labs.theresonance.studio

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/lib/common.sh"
. "${SCRIPT_DIR}/lib/branding.sh"
. "${SCRIPT_DIR}/lib/hcloud.sh"

# Show usage
usage() {
    cat << EOF
Usage: destroy.sh <server-name> [--confirm]

Arguments:
  server-name    Name of server to destroy (required)
  --confirm      Skip confirmation prompt (use with caution)

Example:
  destroy.sh my-server
EOF
}

main() {
    if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
        usage
        exit 0
    fi

    server_name="${1:-}"
    confirm_flag="${2:-}"

    print_header "Destroy Server"

    # Validate server name
    if [ -z "$server_name" ]; then
        log_error "Server name is required"
        printf "\n"
        usage
        exit 1
    fi

    # Check prerequisites
    check_prerequisites || exit 1

    # Check if server exists
    if ! hcloud_server_exists "$server_name"; then
        log_error "Server '$server_name' not found"
        printf "\n  List all servers: /status\n"
        exit 1
    fi

    # Display server info
    print_section "Server to be destroyed"
    hcloud server describe "$server_name" -o format='  Name:     {{.Name}}
  Status:   {{.Status}}
  IP:       {{.PublicNet.IPv4.IP}}
  Type:     {{.ServerType.Name}}
  Created:  {{.Created}}'

    printf "\n"
    print_warning_box "This action is PERMANENT and IRREVERSIBLE!"
    printf "\n  All data on this server will be lost.\n"

    # Handle confirmation
    if [ "$confirm_flag" = "--confirm" ]; then
        # Auto-confirmed via flag
        log_info "Destroying server (--confirm flag provided)..."
    else
        # This script expects confirmation to be handled by Claude
        # The CONFIRM_DESTROY environment variable should be set
        if [ "${CONFIRM_DESTROY:-}" != "yes" ]; then
            printf "\n"
            log_info "To destroy this server, Claude will ask for confirmation."
            log_info "Or run with --confirm flag to skip the prompt."
            printf "\n"
            exit 0
        fi
    fi

    # Perform deletion
    print_section "Destroying Server"
    log_info "Deleting '$server_name'..."

    if hcloud_delete_server "$server_name"; then
        print_success_box "Server '$server_name' has been destroyed"
        printf "\n  Resources released. You will not be billed for this server going forward.\n"
    else
        log_error "Failed to delete server"
        exit 1
    fi

    print_footer
}

main "$@"
