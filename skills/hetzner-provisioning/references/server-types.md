# Hetzner Server Types Reference

Complete reference for Hetzner Cloud server types and pricing.

## Shared vCPU (Intel/AMD)

Best for variable workloads, development, and small production apps.

| Type | vCPU | RAM | Storage | EUR/month | Best For |
|------|------|-----|---------|-----------|----------|
| cx22 | 2 | 4 GB | 40 GB NVMe | 4.49 | Development, testing |
| cx32 | 4 | 8 GB | 80 GB NVMe | 8.98 | Small production |
| cx42 | 8 | 16 GB | 160 GB NVMe | 17.96 | Medium production |
| cx52 | 16 | 32 GB | 320 GB NVMe | 35.92 | Large production |

## Shared vCPU (AMD EPYC)

Higher single-thread performance for compute-intensive tasks.

| Type | vCPU | RAM | Storage | EUR/month | Best For |
|------|------|-----|---------|-----------|----------|
| cpx11 | 2 | 2 GB | 40 GB NVMe | 4.49 | Light workloads |
| cpx21 | 3 | 4 GB | 80 GB NVMe | 8.49 | Development |
| cpx31 | 4 | 8 GB | 160 GB NVMe | 14.99 | Small production |
| cpx41 | 8 | 16 GB | 240 GB NVMe | 27.99 | Medium production |
| cpx51 | 16 | 32 GB | 360 GB NVMe | 54.99 | Large production |

## ARM64 (Ampere Altra)

Best price-to-performance for compatible workloads.

| Type | vCPU | RAM | Storage | EUR/month | Best For |
|------|------|-----|---------|-----------|----------|
| cax11 | 2 | 4 GB | 40 GB NVMe | 3.79 | Budget development |
| cax21 | 4 | 8 GB | 80 GB NVMe | 6.49 | Small production |
| cax31 | 8 | 16 GB | 160 GB NVMe | 12.49 | Medium production |
| cax41 | 16 | 32 GB | 320 GB NVMe | 23.99 | Large production |

## Recommendations

### For Claude Code Development
- **Best value**: cx22 (4.49 EUR/month)
- **Budget option**: cax11 (3.79 EUR/month, ARM64)
- **More power**: cx32 (8.98 EUR/month)

### For Production
- **Small apps**: cx32 or cax21
- **Medium apps**: cx42 or cax31
- **High traffic**: cx52 or cax41

## Included with All Plans

- **Traffic**: 20 TB/month (EU), 1 TB/month (US/Asia)
- **DDoS Protection**: Free
- **IPv4 + IPv6**: Included
- **Hourly Billing**: Pay only for what you use
- **No Setup Fees**: Start and stop anytime

## Billing Notes

- Servers are billed hourly up to the monthly cap
- Deleting a server stops all charges immediately
- Stopped servers still incur charges (disk space reserved)
- To stop charges completely, delete the server
