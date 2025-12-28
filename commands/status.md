---
name: status
description: Check status of Hetzner VPS servers. Shows all servers or details for a specific one.
argument-hint: [server-name]
---

# Server Status

Check the status of your Hetzner VPS servers.

## Arguments

Parse from `$ARGUMENTS`:
- Optional: Server name - if provided, show detailed status for that server

## Workflow

### All Servers (no argument)
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/status.sh"
```

Display table with: Name, Status, IP, Type, Location

### Specific Server (with name)
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/status.sh" "[server-name]"
```

Display detailed info:
- Server name, status, IPs
- Server type and specs
- Datacenter location
- Creation date
- SSH connection command
- Health check (SSH available?)

## Output Format

For all servers, present a clean table.
For specific server, present detailed breakdown with connection info.

## Error Handling

- **Server not found**: Suggest `/status` to list all servers
- **No servers exist**: Suggest `/provision` to create one
