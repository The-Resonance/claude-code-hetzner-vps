---
name: destroy
description: Permanently destroy a Hetzner VPS server. Requires confirmation before deletion.
argument-hint: <server-name>
---

# Destroy Server

Permanently destroy a Hetzner VPS server. This action is irreversible.

## Arguments

Parse from `$ARGUMENTS`:
- Required: Server name to destroy

## Safety Protocol

This command REQUIRES explicit confirmation:

1. Show server details being destroyed (name, IP, type, created date)
2. Display warning: "This will permanently delete the server and ALL data"
3. Ask user to confirm by typing "yes" or the server name
4. Only proceed if confirmation is explicit

NEVER auto-confirm or skip confirmation for destructive operations.

## Workflow

### Step 1: Show Server Info
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/status.sh" "[server-name]"
```

### Step 2: Require Confirmation
Ask: "Are you sure you want to permanently destroy '[server-name]'? This cannot be undone. Type 'yes' to confirm."

### Step 3: Execute (only after confirmation)
```bash
CONFIRM_DESTROY=yes bash "${CLAUDE_PLUGIN_ROOT}/scripts/destroy.sh" "[server-name]"
```

## Error Handling

- **Server not found**: Suggest `/status` to list all servers
- **Confirmation not given**: Cancel operation, do NOT proceed
