#!/bin/sh
# cost-estimate.sh - Cost estimation for Hetzner VPS
# POSIX-compatible
# A free tool by Pete Sena | labs.theresonance.studio

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/lib/common.sh"
. "${SCRIPT_DIR}/lib/branding.sh"

# Server type pricing (EUR/month, December 2025)
get_price() {
    case "$1" in
        # Shared x86 (Intel/AMD)
        cx22)   printf "4.49" ;;
        cx32)   printf "8.98" ;;
        cx42)   printf "17.96" ;;
        cx52)   printf "35.92" ;;
        # Shared AMD
        cpx11)  printf "4.49" ;;
        cpx21)  printf "8.49" ;;
        cpx31)  printf "14.99" ;;
        cpx41)  printf "27.99" ;;
        cpx51)  printf "54.99" ;;
        # ARM64 (Ampere)
        cax11)  printf "3.79" ;;
        cax21)  printf "6.49" ;;
        cax31)  printf "12.49" ;;
        cax41)  printf "23.99" ;;
        *)      printf "unknown" ;;
    esac
}

# Server type specifications
get_specs() {
    case "$1" in
        cx22)   printf "2 vCPU (shared), 4 GB RAM, 40 GB NVMe" ;;
        cx32)   printf "4 vCPU (shared), 8 GB RAM, 80 GB NVMe" ;;
        cx42)   printf "8 vCPU (shared), 16 GB RAM, 160 GB NVMe" ;;
        cx52)   printf "16 vCPU (shared), 32 GB RAM, 320 GB NVMe" ;;
        cpx11)  printf "2 vCPU (AMD), 2 GB RAM, 40 GB NVMe" ;;
        cpx21)  printf "3 vCPU (AMD), 4 GB RAM, 80 GB NVMe" ;;
        cpx31)  printf "4 vCPU (AMD), 8 GB RAM, 160 GB NVMe" ;;
        cpx41)  printf "8 vCPU (AMD), 16 GB RAM, 240 GB NVMe" ;;
        cpx51)  printf "16 vCPU (AMD), 32 GB RAM, 360 GB NVMe" ;;
        cax11)  printf "2 vCPU (ARM64), 4 GB RAM, 40 GB NVMe" ;;
        cax21)  printf "4 vCPU (ARM64), 8 GB RAM, 80 GB NVMe" ;;
        cax31)  printf "8 vCPU (ARM64), 16 GB RAM, 160 GB NVMe" ;;
        cax41)  printf "16 vCPU (ARM64), 32 GB RAM, 320 GB NVMe" ;;
        *)      printf "Unknown server type" ;;
    esac
}

# Get recommendation for server type
get_recommendation() {
    case "$1" in
        cx22|cax11)
            printf "Great for development and light workloads" ;;
        cx32|cax21|cpx21)
            printf "Good for small production apps" ;;
        cx42|cax31|cpx31)
            printf "Recommended for medium production workloads" ;;
        *)
            printf "For heavy production workloads" ;;
    esac
}

# Show usage
usage() {
    cat << EOF
Usage: cost-estimate.sh [server-type]

Arguments:
  server-type    Hetzner server type (default: cx22)

Available Types:
  Shared x86:  cx22, cx32, cx42, cx52
  Shared AMD:  cpx11, cpx21, cpx31, cpx41, cpx51
  ARM64:       cax11, cax21, cax31, cax41

Example:
  cost-estimate.sh cx32
EOF
}

main() {
    if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
        usage
        exit 0
    fi

    server_type="${1:-cx22}"

    print_header "Cost Estimation"

    price=$(get_price "$server_type")
    specs=$(get_specs "$server_type")
    recommendation=$(get_recommendation "$server_type")

    if [ "$price" = "unknown" ]; then
        log_error "Unknown server type: $server_type"
        printf "\nAvailable types: cx22, cx32, cx42, cx52, cpx11-51, cax11-41\n"
        exit 1
    fi

    print_section "Selected Configuration"
    print_row "Type:" "$server_type"
    print_row "Specs:" "$specs"

    print_section "Estimated Monthly Cost"

    # EUR price
    printf "  EUR:    %.2f EUR/month\n" "$price"

    # USD price (approximate 1.08 rate)
    if command_exists bc; then
        usd=$(printf "%.2f" "$(echo "$price * 1.08" | bc -l)")
    else
        usd=$(printf "%.2f" "$price")
    fi
    printf "  USD:    ~%.2f USD/month\n" "$usd"

    # Hourly rate
    if command_exists bc; then
        hourly=$(printf "%.4f" "$(echo "$price / 730" | bc -l)")
    else
        hourly="0.0061"
    fi
    printf "  Hourly: ~%.4f EUR/hour\n" "$hourly"

    print_section "Recommendation"
    printf "  %s\n" "$recommendation"

    print_section "Popular Options Comparison"
    printf "  %-8s %-40s %12s\n" "Type" "Specs" "EUR/month"
    printf "  %-8s %-40s %12s\n" "────" "─────" "─────────"
    printf "  %-8s %-40s %12.2f\n" "cax11" "2 vCPU (ARM64), 4 GB RAM" "3.79"
    printf "  %-8s %-40s %12.2f\n" "cx22" "2 vCPU (shared), 4 GB RAM" "4.49"
    printf "  %-8s %-40s %12.2f\n" "cx32" "4 vCPU (shared), 8 GB RAM" "8.98"
    printf "  %-8s %-40s %12.2f\n" "cpx21" "3 vCPU (AMD), 4 GB RAM" "8.49"

    print_section "Included with All Plans"
    printf "  ✓ 20 TB traffic (EU) / 1 TB (US)\n"
    printf "  ✓ DDoS protection\n"
    printf "  ✓ Hourly billing (pay only for what you use)\n"
    printf "  ✓ No setup fees\n"

    print_footer
}

main "$@"
