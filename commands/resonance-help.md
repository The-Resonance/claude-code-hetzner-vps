---
name: resonance-help
description: Display help and documentation for claude-code-hetzner-vps plugin
---

# claude-code-hetzner-vps Help

Display comprehensive help for the Hetzner VPS provisioning plugin.

## Available Commands

Present this information clearly:

| Command | Description |
|---------|-------------|
| `/provision <name> [type] [location]` | Create a new secure VPS |
| `/status [name]` | Check server status |
| `/destroy <name>` | Permanently remove a server |
| `/cost-estimate [type]` | Estimate monthly costs |
| `/resonance-help` | Show this help |

## Prerequisites

Explain the setup requirements:

1. **Hetzner Account**: Create at https://console.hetzner.cloud
2. **API Token**: Generate in Hetzner Console > Security > API Tokens
3. **hcloud CLI**:
   - macOS: `brew install hcloud`
   - Linux: Download from GitHub releases
4. **SSH Key**: Generate with `ssh-keygen -t ed25519`

## Quick Start Example

```bash
# Set up hcloud CLI (one time)
hcloud context create my-project
# Enter your API token when prompted

# Check costs
/cost-estimate cx22

# Create your server
/provision my-dev-server cx22 nbg1

# Connect (after ~2 min)
ssh claude@<server-ip>

# Use Claude Code
claude
```

## Security Features

All servers automatically include:
- UFW firewall (SSH only)
- fail2ban intrusion prevention
- SSH key-only authentication
- Root login disabled
- Automatic security updates

## Server Types Quick Reference

| Type | Specs | EUR/month |
|------|-------|-----------|
| cx22 | 2 vCPU, 4 GB | ~4.49 |
| cx32 | 4 vCPU, 8 GB | ~8.98 |
| cax11 | 2 ARM, 4 GB | ~3.79 |

## About

**claude-code-hetzner-vps** is a free tool designed to make secure cloud provisioning accessible to everyone.

- Website: https://labs.theresonance.studio
- Author: Pete Sena (https://linkedin.com/in/petersena)
- Repository: https://github.com/The-Resonance/claude-code-hetzner-vps

## Support

Open an issue at the GitHub repository for questions or bugs.
