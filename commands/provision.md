---
name: provision
description: Provision a secure Hetzner VPS with Claude Code pre-installed. Creates a hardened server with UFW firewall, fail2ban, and SSH security.
argument-hint: <server-name> [server-type] [location]
---

# Provision Hetzner VPS

Create a secure, production-ready Hetzner VPS with Claude Code pre-installed.

## Pre-flight Checks

Before provisioning, verify:
1. `hcloud` CLI is installed: `which hcloud`
2. API authentication is configured: `hcloud server list`
3. SSH key exists: `~/.ssh/id_ed25519.pub` or `~/.ssh/id_rsa.pub`

If hcloud is missing, provide installation instructions:
- macOS: `brew install hcloud`
- Linux: Download from https://github.com/hetznercloud/cli/releases

If authentication fails, guide user to:
1. Create API token at https://console.hetzner.cloud > Security > API Tokens
2. Run: `hcloud context create my-project`

## Arguments

Parse from `$ARGUMENTS`:
- First word: Server name (required) - lowercase alphanumeric with hyphens
- Second word: Server type (optional) - defaults to `cx22`
- Third word: Location (optional) - defaults to `nbg1`

## Workflow

### Step 1: Cost Estimation
ALWAYS show estimated cost first:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/cost-estimate.sh" "[server-type]"
```

Ask user: "This server will cost approximately X EUR/month. Proceed? (yes/no)"

### Step 2: Provision
Only after user confirms:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/provision.sh" "[server-name]" "[server-type]" "[location]"
```

### Step 3: Report Success
After provisioning, display:
- Server IP address
- SSH connection command: `ssh claude@[ip]`
- Security features enabled
- Note: Wait ~2 minutes for cloud-init to complete

## Security Features Applied

Every server includes:
- UFW firewall (port 22 only)
- fail2ban SSH jail (5 retries, 1hr ban)
- SSH hardening (key-only, no root login)
- Automatic security updates
- Non-root `claude` user with sudo

## Server Types Reference

| Type | vCPU | RAM | EUR/month |
|------|------|-----|-----------|
| cx22 | 2 | 4 GB | ~4.49 |
| cx32 | 4 | 8 GB | ~8.98 |
| cax11 | 2 (ARM) | 4 GB | ~3.79 |

## Locations Reference

| Code | Location |
|------|----------|
| nbg1 | Nuremberg, Germany (default) |
| fsn1 | Falkenstein, Germany |
| hel1 | Helsinki, Finland |
| ash | Ashburn, USA |
| hil | Hillsboro, USA |

## Error Handling

- **Server name exists**: Suggest alternative name or `/destroy` existing
- **Invalid API token**: Guide to create token in Hetzner Console
- **SSH key missing**: Guide to generate with `ssh-keygen -t ed25519`
