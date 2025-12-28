---
name: cost-estimate
description: Estimate monthly cost for a Hetzner VPS before provisioning. Shows pricing comparison.
argument-hint: [server-type]
---

# Cost Estimation

Estimate the monthly cost for a Hetzner VPS before provisioning.

## Arguments

Parse from `$ARGUMENTS`:
- Optional: Server type (default: cx22)

## Workflow

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/cost-estimate.sh" "[server-type]"
```

## Output

Display:
- Selected server type and specs
- Monthly cost in EUR and USD
- Hourly rate
- Comparison with other popular options
- What's included (traffic, DDoS protection, etc.)

## Available Server Types

**Shared x86:**
- cx22, cx32, cx42, cx52

**Shared AMD:**
- cpx11, cpx21, cpx31, cpx41, cpx51

**ARM64 (Ampere):**
- cax11, cax21, cax31, cax41

## Error Handling

- **Unknown type**: Show available types and suggest cx22 as default
