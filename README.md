# claude-code-hetzner-vps

> Spin up a secure, Claude Code-ready VPS for ~$5/month in under 5 minutes.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-purple)](https://claude.ai/code)

**A free tool by [Pete Sena](https://linkedin.com/in/petersena) | [The Resonance Labs](https://labs.theresonance.studio)**

---

## What is Claude Code?

[Claude Code](https://claude.ai/code) is Anthropic's official CLI tool that lets you use Claude AI directly in your terminal. It can read files, write code, run commands, and help you build software faster. This plugin extends Claude Code with commands to provision secure cloud servers.

---

## Installation

### Option 1: From Marketplace (Easiest)

```bash
# In Claude Code
/plugin marketplace add The-Resonance/claude-code-hetzner-vps
/plugin install claude-code-hetzner-vps
```

### Option 2: Clone and Use

```bash
# Clone the plugin
git clone https://github.com/The-Resonance/claude-code-hetzner-vps.git ~/.claude-plugins/hetzner-vps

# Start Claude Code with the plugin
claude --plugin-dir ~/.claude-plugins/hetzner-vps
```

### Option 3: Test Locally

```bash
git clone https://github.com/The-Resonance/claude-code-hetzner-vps.git
cd claude-code-hetzner-vps
claude --plugin-dir .
```

Once loaded, you'll have access to these commands:
- `/provision` - Create a secure VPS
- `/status` - Check server status
- `/destroy` - Delete a server
- `/cost-estimate` - See pricing before you spend

---

## The Problem

You want to run Claude Code on a remote server—maybe for longer tasks, CI/CD pipelines, or just to keep your laptop free. But setting up a secure cloud server means:

- Configuring firewalls
- Hardening SSH
- Setting up fail2ban
- Installing dependencies
- ...and hoping you didn't miss a security step

## The Solution

One command. Fully secured. Claude Code pre-installed.

```bash
/provision my-server
```

That's it. You get:
- **UFW firewall** blocking everything except SSH
- **fail2ban** banning brute-force attackers
- **SSH hardening** (key-only, no root, limited retries)
- **Automatic security updates**
- **Claude Code** ready to use

---

## 5-Minute Setup (Complete Walkthrough)

### Step 1: Create a Hetzner Account

1. Go to [console.hetzner.cloud](https://console.hetzner.cloud)
2. Click **Register** and create an account
3. Verify your email
4. You may need to add payment info (no charge until you provision)

### Step 2: Create a Project

1. In the Hetzner Console, click **+ New Project**
2. Name it something like `claude-servers`
3. Click into your new project

### Step 3: Generate an API Token

1. Go to **Security** → **API Tokens**
2. Click **Generate API Token**
3. Name it `claude-code-cli`
4. Select **Read & Write** permissions
5. Click **Generate**
6. **Copy the token immediately** (you won't see it again!)

### Step 4: Install the hcloud CLI

**macOS:**
```bash
brew install hcloud
```

**Linux:**
```bash
curl -fsSL https://github.com/hetznercloud/cli/releases/latest/download/hcloud-linux-amd64.tar.gz | tar xz
sudo mv hcloud /usr/local/bin/
```

### Step 5: Configure hcloud Authentication

```bash
hcloud context create claude-servers
```

When prompted, paste your API token from Step 3.

**Verify it works:**
```bash
hcloud server list
```

Should return an empty list (no errors).

### Step 6: Ensure You Have an SSH Key

Check if you have one:
```bash
ls ~/.ssh/id_ed25519.pub || ls ~/.ssh/id_rsa.pub
```

If not, generate one:
```bash
ssh-keygen -t ed25519 -C "your@email.com"
```

Press Enter to accept defaults.

### Step 7: Provision Your Server

```bash
# Check cost first
/cost-estimate cx22

# Create the server
/provision my-dev-server cx22 nbg1
```

This takes about 60 seconds. You'll see the server IP when done.

### Step 8: Connect via SSH

**Wait ~2 minutes** for cloud-init to complete, then:

```bash
ssh claude@<your-server-ip>
```

You'll see the branded welcome message confirming security features are active.

### Step 9: Use Claude Code

```bash
claude
```

Done! You're running Claude Code on your own secure VPS.

---

## GitHub + Vercel Workflow

To push code and work with Vercel, set up GitHub authentication on your server:

### Install GitHub CLI

```bash
sudo apt install gh -y
```

### Authenticate with GitHub

```bash
gh auth login
```

Select:
- GitHub.com
- HTTPS
- Yes (authenticate with browser)
- Login with a one-time code

### Set Up SSH Key for Git

```bash
# Generate a key for this server
ssh-keygen -t ed25519 -C "your-server-name"

# Add the required scope (important!)
gh auth refresh -h github.com -s admin:public_key

# Add the key to your GitHub account
gh ssh-key add ~/.ssh/id_ed25519.pub --title "my-hetzner-server"

# Test the connection
ssh -T git@github.com
```

### Clone and Work

```bash
# Clone your repo
git clone git@github.com:username/your-repo.git
cd your-repo

# Run Claude Code
claude
```

Now you can commit, push, and create PRs. Vercel will auto-deploy.

---

## Running Web Apps

By default, the firewall only allows SSH (port 22). To access web apps:

### Quick Dev Access (port 3000)

```bash
# On your server
sudo ufw allow 3000/tcp

# Run Next.js bound to all interfaces
npm run dev -- -H 0.0.0.0
```

Access at: `http://<your-server-ip>:3000`

### Production Setup (Domain + HTTPS)

```bash
# Open web ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Install Caddy (auto-HTTPS)
sudo apt install -y caddy
```

Edit `/etc/caddy/Caddyfile`:
```
yourdomain.com {
    reverse_proxy localhost:3000
}
```

```bash
sudo systemctl restart caddy

# Keep your app running with pm2
npm install -g pm2
pm2 start npm --name "myapp" -- start
```

Point your domain's A record to your server IP. Caddy handles SSL automatically.

---

## Common Gotchas (& Fixes)

| Problem | Cause | Solution |
|---------|-------|----------|
| `cx22` not available in US | Shared CPU types limited to EU | Use `nbg1`, `fsn1`, or `hel1` location |
| SSH "Permission denied" | Running SSH from wrong machine | Run `ssh` from your **local** computer, not the server |
| `gh ssh-key add` returns 404 | Missing API scope | Run `gh auth refresh -h github.com -s admin:public_key` first |
| Can't access web app in browser | Firewall blocking port | `sudo ufw allow 3000/tcp` (or 80/443 for production) |
| Next.js only accessible on localhost | Not bound to 0.0.0.0 | Run `npm run dev -- -H 0.0.0.0` |
| Cloud-init not complete | Provisioning still running | Wait ~2 minutes after server creation |
| `claude` command not found | Cloud-init still running | Check: `sudo cloud-init status` |

---

## Commands Reference

| Command | Description |
|---------|-------------|
| `/provision <name> [type] [location]` | Create a secure VPS |
| `/status [name]` | Check server status |
| `/destroy <name>` | Permanently delete a server |
| `/cost-estimate [type]` | Estimate monthly costs |
| `/resonance-help` | Full documentation |

---

## Server Types & Pricing

| Type | vCPU | RAM | Storage | EUR/month | USD/month* |
|------|------|-----|---------|-----------|------------|
| **cax11** | 2 (ARM64) | 4 GB | 40 GB | €3.79 | ~$4.10 |
| **cx22** | 2 (shared) | 4 GB | 40 GB | €4.49 | ~$4.85 |
| **cx32** | 4 (shared) | 8 GB | 80 GB | €8.98 | ~$9.70 |
| **cpx21** | 3 (AMD) | 4 GB | 80 GB | €8.49 | ~$9.17 |

*USD approximate at 1.08 exchange rate

**Recommendation:** Start with `cx22` for development. It handles Claude Code perfectly.

---

## Locations

| Code | City | Region |
|------|------|--------|
| `nbg1` | Nuremberg | Germany (default) |
| `fsn1` | Falkenstein | Germany |
| `hel1` | Helsinki | Finland |
| `ash` | Ashburn | USA* |
| `hil` | Hillsboro | USA* |

*US locations have limited server types. Use EU for best availability.

---

## Security Details

### What Gets Configured Automatically

**UFW Firewall:**
```bash
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
```

**fail2ban (SSH jail):**
- Max retries: 5
- Ban time: 1 hour
- Find time: 10 minutes

**SSH Hardening:**
```
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3
X11Forwarding no
```

**Automatic Updates:**
- `unattended-upgrades` enabled
- Security patches applied automatically

---

## Multi-Project Workflow

For working on multiple projects:

```bash
# Create a projects directory
mkdir ~/projects
cd ~/projects

# Clone your repos
git clone git@github.com:you/project-a.git
git clone git@github.com:you/project-b.git

# Work on project A
cd project-a
claude

# Later, work on project B
cd ../project-b
claude
```

Each project maintains its own git state. Claude Code inherits your shell's authentication.

---

## Troubleshooting

### "hcloud not found"
```bash
# macOS
brew install hcloud

# Linux
curl -fsSL https://github.com/hetznercloud/cli/releases/latest/download/hcloud-linux-amd64.tar.gz | tar xz
sudo mv hcloud /usr/local/bin/
```

### "unauthorized" or "forbidden" error
Your API token may be invalid or expired. Generate a new one:
1. Hetzner Console → Security → API Tokens
2. Generate new token with Read & Write
3. Run `hcloud context create <name>` and paste new token

### Server created but can't SSH
1. Wait 2 minutes for cloud-init
2. Ensure you're SSHing from your local machine (not from another server)
3. Check your SSH key: `ssh -i ~/.ssh/id_ed25519 claude@<ip>`

### Claude Code not installed
SSH in and check cloud-init:
```bash
sudo cloud-init status
sudo cat /var/log/cloud-init-output.log | tail -50
```

---

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## About

**claude-code-hetzner-vps** is a free tool designed to make secure cloud provisioning accessible to everyone. No strings attached, no premium tier, just useful software.

Built by [Pete Sena](https://linkedin.com/in/petersena) at [The Resonance Labs](https://labs.theresonance.studio).

*Helping builders ship faster, securely.*
