#!/bin/sh
# status.sh - Server status checker
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
Usage: status.sh [server-name]

Arguments:
  server-name    Name of server to check (optional, shows all if omitted)

Examples:
  status.sh              # List all servers
  status.sh my-server    # Show details for specific server
EOF
}

main() {
    if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
        usage
        exit 0
    fi

    server_name="${1:-}"

    print_header "Server Status"

    # Check prerequisites
    check_prerequisites || exit 1

    if [ -z "$server_name" ]; then
        # List all servers
        print_section "All Servers"

        server_count=$(hcloud server list -o noheader 2>/dev/null | wc -l | tr -d ' ')

        if [ "$server_count" = "0" ]; then
            printf "  No servers found.\n\n"
            printf "  Create one with: /provision <server-name>\n"
        else
            printf "  %-20s %-12s %-16s %-10s %-10s\n" "NAME" "STATUS" "IP" "TYPE" "LOCATION"
            printf "  %-20s %-12s %-16s %-10s %-10s\n" "────" "──────" "──" "────" "────────"
            hcloud server list -o columns=name,status,ipv4,server_type,datacenter 2>/dev/null | tail -n +2 | while read -r line; do
                printf "  %s\n" "$line"
            done
        fi
    else
        # Show specific server details
        if ! hcloud_server_exists "$server_name"; then
            log_error "Server '$server_name' not found"
            printf "\n  List all servers: /status\n"
            exit 1
        fi

        print_section "Server: $server_name"

        # Get server details
        hcloud server describe "$server_name" -o format='  Name:     {{.Name}}
  Status:   {{.Status}}
  IPv4:     {{.PublicNet.IPv4.IP}}
  IPv6:     {{.PublicNet.IPv6.IP}}
  Type:     {{.ServerType.Name}}
  Location: {{.Datacenter.Name}}
  Created:  {{.Created}}'

        server_ip=$(hcloud_get_ip "$server_name")

        print_section "Quick Connect"
        printf "  SSH: ssh claude@%s\n" "$server_ip"

        # Try to check if SSH is available
        print_section "Health Check"
        if ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no -o BatchMode=yes "claude@$server_ip" "echo ok" >/dev/null 2>&1; then
            log_success "SSH connection available"
        else
            log_warning "SSH not responding (server may still be initializing)"
        fi
    fi

    print_footer
}

main "$@"
