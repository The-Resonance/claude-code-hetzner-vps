# Complete Tutorial Site Prompt

Copy everything below the line and paste it into Claude Code.

---

Build a complete, production-ready Next.js tutorial website for "claude-code-hetzner-vps". This site teaches developers how to provision a secure, Claude Code-ready VPS on Hetzner Cloud for ~$5/month.

**IMPORTANT**: Use ALL the copy provided below exactly as written. This is real content from an actual setup walkthrough, not placeholder text.

## Tech Stack

- Next.js 15+ (App Router)
- TypeScript
- Tailwind CSS
- shadcn/ui components (install: Card, Button, Accordion, Badge, Tabs, Separator)
- Framer Motion for animations
- Geist font family (from next/font/google)
- Lucide React icons

## Design System

### Colors
```
--background: #09090b (near-black)
--foreground: #fafafa (white)
--card: #18181b with border-white/5
--accent: #3b82f6 (electric blue)
--accent-glow: #3b82f6/20
--muted: #a1a1aa (zinc-400)
--success: #22c55e (green-500)
--warning: #f59e0b (amber-500)
```

### Typography
- Headings: Geist Sans, font-bold
- Body: Geist Sans, text-zinc-400
- Code: Geist Mono

### Visual Effects
- Subtle grid pattern overlay on background
- Glassmorphism cards (bg-white/5 backdrop-blur border-white/10)
- Gradient borders on hover
- Electric blue glow on interactive elements

---

## PAGE STRUCTURE & COMPLETE COPY

### 1. HERO SECTION

**Headline:**
```
Your Own Secure Dev Server.
~$5/month.
```

**Subheadline:**
```
Provision a Claude Code-ready VPS with enterprise security in under 5 minutes. No DevOps degree required.
```

**Terminal Animation** (animate typing effect):
```bash
$ /provision my-dev-server

Creating server 'my-dev-server'...
  Type: cx22 (2 vCPU, 4GB RAM)
  Location: nbg1 (Nuremberg, DE)
  Cost: €4.49/month (~$5 USD)

✓ Server created
✓ UFW firewall configured
✓ fail2ban installed
✓ SSH hardened
✓ Claude Code installed

Server ready: 203.0.113.42
Run: ssh claude@203.0.113.42
```

**CTA Buttons:**
- Primary: "Get Started" (scrolls to setup section)
- Secondary/Ghost: "View on GitHub" (links to github.com/The-Resonance/claude-code-hetzner-vps)

**Floating Badges** (arranged around terminal):
- "UFW Firewall"
- "fail2ban Protection"
- "SSH Hardening"
- "Auto Updates"

---

### 2. THE PROBLEM / SOLUTION SECTION

**Section Title:** "Why This Exists"

**Two-column layout:**

**LEFT COLUMN - "The Old Way"** (grayed out, items with strikethrough):
```
Configure UFW firewall rules
Set up fail2ban jails
Harden SSH configuration
Disable root login
Set up key-only authentication
Install and configure dependencies
Enable automatic security updates
Hope you didn't miss anything
```

**RIGHT COLUMN - "The New Way"** (bright, with checkmarks):
```
✓ One command
✓ 60 seconds
✓ Enterprise security
✓ Claude Code pre-installed
✓ Ready to code
```

---

### 3. FEATURES GRID

**Section Title:** "What You Get"

**6 Feature Cards (3x2 grid):**

1. **Security Hardening**
   - Icon: Shield
   - Description: "UFW firewall blocks all traffic except SSH. fail2ban bans attackers after 5 failed attempts. SSH allows key-only authentication with root disabled."

2. **Cost Transparency**
   - Icon: DollarSign
   - Description: "See exactly what you'll pay before provisioning. Starting at €3.79/month (~$4 USD). Hourly billing means you only pay for what you use."

3. **Claude Code Pre-installed**
   - Icon: Terminal
   - Description: "SSH in and run 'claude'. That's it. No installation, no configuration, no PATH issues. Just start coding."

4. **One Command Deploy**
   - Icon: Zap
   - Description: "Run /provision my-server and you're done. Server creation, security hardening, and tool installation all automated."

5. **GitHub Ready**
   - Icon: GitBranch
   - Description: "Set up GitHub CLI and SSH keys in minutes. Push code, create PRs, and integrate with Vercel for automatic deployments."

6. **Production Capable**
   - Icon: Globe
   - Description: "Open ports for web apps, set up Caddy for automatic HTTPS, and run production workloads with pm2 process management."

---

### 4. VIDEO SECTION

**Section Title:** "Watch the Walkthrough"

**Placeholder for embedded video:**
```
[VIDEO EMBED PLACEHOLDER]
Aspect ratio: 16:9
Border radius: rounded-xl
Border: border-white/10
```

**Caption below video:**
```
Complete walkthrough from zero to running Claude Code on your own server.
```

---

### 5. SETUP GUIDE (Interactive Accordion)

**Section Title:** "Complete Setup Guide"
**Section Subtitle:** "Follow these 9 steps to get your server running"

**Use shadcn Accordion component. Each step expands to show full content.**

---

**STEP 1: Create a Hetzner Account**

```
Hetzner Cloud offers some of the best price-to-performance ratios in the industry. Their servers are reliable, fast, and incredibly affordable.

1. Go to console.hetzner.cloud
2. Click "Register" in the top right
3. Enter your email and create a password
4. Verify your email address
5. You may need to add payment information (you won't be charged until you provision a server)

Why Hetzner? European data centers with excellent connectivity, transparent pricing, and servers starting under $5/month.
```

---

**STEP 2: Create a Project**

```
Projects help you organize your resources. You might have separate projects for development, staging, and production.

1. Once logged in, click "+ New Project"
2. Name it something like "claude-servers" or "dev-environment"
3. Click "Add project"
4. Click into your new project to open it

All your servers, SSH keys, and other resources will live inside this project.
```

---

**STEP 3: Generate an API Token**

```
The API token lets the hcloud CLI manage your servers. Keep it secret—anyone with this token can create or destroy your servers.

1. In your project, go to Security → API Tokens
2. Click "Generate API Token"
3. Name it "claude-code-cli" (or whatever you prefer)
4. Select "Read & Write" permissions
5. Click "Generate API Token"
6. IMPORTANT: Copy the token immediately. You won't be able to see it again!

Store this token somewhere safe. You'll need it in the next step.
```

---

**STEP 4: Install the hcloud CLI**

**macOS:**
```bash
brew install hcloud
```

**Linux:**
```bash
curl -fsSL https://github.com/hetznercloud/cli/releases/latest/download/hcloud-linux-amd64.tar.gz | tar xz
sudo mv hcloud /usr/local/bin/
```

**Windows:**
```
Download from: github.com/hetznercloud/cli/releases
Add to your PATH
```

```
The hcloud CLI is how you'll interact with Hetzner's API. It's fast, well-documented, and makes server management a breeze.
```

---

**STEP 5: Configure Authentication**

```bash
hcloud context create claude-servers
```

```
When prompted, paste the API token you copied in Step 3.

Verify it works:
```

```bash
hcloud server list
```

```
You should see an empty list (no errors). If you get "unauthorized", double-check your token.
```

---

**STEP 6: Check Your SSH Key**

```
SSH keys are how you'll securely connect to your server. No passwords—just cryptographic keys.

Check if you already have one:
```

```bash
ls ~/.ssh/id_ed25519.pub || ls ~/.ssh/id_rsa.pub
```

```
If you see a file path, you're good. If not, generate a new key:
```

```bash
ssh-keygen -t ed25519 -C "your@email.com"
```

```
Press Enter to accept the default location. You can add a passphrase for extra security or leave it empty.
```

---

**STEP 7: Provision Your Server**

```
First, check the cost:
```

```bash
/cost-estimate cx22
```

```
You'll see:
  Type: cx22
  Specs: 2 vCPU (shared), 4 GB RAM, 40 GB NVMe
  Monthly: €4.49 (~$4.85 USD)
  Hourly: ~€0.0061/hour

Now provision:
```

```bash
/provision my-dev-server cx22 nbg1
```

```
This creates a server named "my-dev-server" using the cx22 type in Nuremberg, Germany. The process takes about 60 seconds.

You'll see the server IP address when it's done.
```

---

**STEP 8: Connect via SSH**

```
IMPORTANT: Wait about 2 minutes after provisioning. The server needs time to run cloud-init, which installs all the security tools and Claude Code.

Then connect:
```

```bash
ssh claude@YOUR_SERVER_IP
```

```
Replace YOUR_SERVER_IP with the IP address from the previous step.

You'll see a welcome message confirming all security features are active:

══════════════════════════════════════════════════════════════
  Server provisioned by claude-code-hetzner-vps

  A free tool by Pete Sena
  https://labs.theresonance.studio

  Security features enabled:
    ✓ UFW firewall (port 22 only)
    ✓ fail2ban intrusion prevention
    ✓ SSH key-only authentication
    ✓ Root login disabled
    ✓ Automatic security updates

  Claude Code is ready. Run: claude
══════════════════════════════════════════════════════════════
```

---

**STEP 9: Start Using Claude Code**

```bash
claude
```

```
That's it. You're now running Claude Code on your own secure VPS.

You can:
- Work on long-running tasks without tying up your laptop
- Run multiple projects in parallel
- Keep your development environment consistent
- Access your dev server from anywhere
```

---

### 6. GITHUB + VERCEL WORKFLOW

**Section Title:** "Set Up GitHub for Deployments"
**Section Subtitle:** "Push code and auto-deploy with Vercel"

**Content (use cards or steps):**

**Install GitHub CLI:**
```bash
sudo apt install gh -y
```

**Authenticate:**
```bash
gh auth login
```
```
Select:
• GitHub.com
• HTTPS
• Yes (authenticate with browser)
• Login with a one-time code
```

**Set Up SSH Key for Git:**
```bash
# Generate a key for this server
ssh-keygen -t ed25519 -C "my-hetzner-server"

# IMPORTANT: Add the required scope first
gh auth refresh -h github.com -s admin:public_key

# Add the key to your GitHub account
gh ssh-key add ~/.ssh/id_ed25519.pub --title "hetzner-dev-server"

# Test the connection
ssh -T git@github.com
```

**You should see:**
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

**Clone and Work:**
```bash
git clone git@github.com:username/your-repo.git
cd your-repo
claude
```

```
Now you can commit, push, and create PRs. If your repo is connected to Vercel, pushes trigger automatic deployments.
```

---

### 7. RUNNING WEB APPS

**Section Title:** "Deploy Web Applications"

**Two cards/tabs:**

**Card 1: Development (Quick Access)**
```bash
# Open port 3000
sudo ufw allow 3000/tcp

# Run Next.js bound to all interfaces
npm run dev -- -H 0.0.0.0
```

```
Access at: http://YOUR_SERVER_IP:3000
```

**Card 2: Production (Domain + HTTPS)**
```bash
# Open web ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Install Caddy (automatic HTTPS)
sudo apt install -y caddy

# Edit Caddy config
sudo nano /etc/caddy/Caddyfile
```

**Caddyfile content:**
```
yourdomain.com {
    reverse_proxy localhost:3000
}
```

```bash
# Restart Caddy
sudo systemctl restart caddy

# Keep your app running with pm2
npm install -g pm2
pm2 start npm --name "myapp" -- start
```

```
Point your domain's A record to your server IP. Caddy automatically provisions SSL certificates from Let's Encrypt.
```

---

### 8. COMMON GOTCHAS

**Section Title:** "Common Issues & Fixes"
**Section Subtitle:** "Things we learned the hard way so you don't have to"

**Use cards with warning icon → solution pattern:**

**Gotcha 1:**
- Problem: "cx22 not available in US locations"
- Cause: "Shared CPU types are limited to European data centers"
- Solution: "Use nbg1 (Nuremberg), fsn1 (Falkenstein), or hel1 (Helsinki)"

**Gotcha 2:**
- Problem: "SSH Permission denied (publickey)"
- Cause: "Running SSH from the wrong machine"
- Solution: "Run the ssh command from your LOCAL computer, not from another server"

**Gotcha 3:**
- Problem: "gh ssh-key add returns 404 error"
- Cause: "Missing admin:public_key API scope"
- Solution: "Run: gh auth refresh -h github.com -s admin:public_key"

**Gotcha 4:**
- Problem: "Can't access web app in browser"
- Cause: "Firewall blocking the port"
- Solution: "Run: sudo ufw allow 3000/tcp (or 80/443 for production)"

**Gotcha 5:**
- Problem: "Next.js only accessible on localhost"
- Cause: "Dev server bound to 127.0.0.1 by default"
- Solution: "Run: npm run dev -- -H 0.0.0.0"

**Gotcha 6:**
- Problem: "'claude' command not found"
- Cause: "Cloud-init still running"
- Solution: "Wait 2 minutes after provisioning. Check status: sudo cloud-init status"

---

### 9. COST CALCULATOR

**Section Title:** "Pricing"
**Section Subtitle:** "Transparent costs, no surprises"

**Interactive component with tabs or radio buttons:**

| Type | vCPU | RAM | Storage | EUR/month | USD/month |
|------|------|-----|---------|-----------|-----------|
| cax11 | 2 (ARM64) | 4 GB | 40 GB | €3.79 | ~$4.10 |
| cx22 | 2 (shared) | 4 GB | 40 GB | €4.49 | ~$4.85 |
| cx32 | 4 (shared) | 8 GB | 80 GB | €8.98 | ~$9.70 |
| cpx21 | 3 (AMD) | 4 GB | 80 GB | €8.49 | ~$9.17 |

**Show selected plan details with animated number transitions**

**Note below calculator:**
```
All plans include:
• 20 TB traffic (EU) / 1 TB (US)
• DDoS protection
• Hourly billing (pay only for uptime)
• No setup fees
```

**Recommendation callout:**
```
Recommended: cx22 for development. It handles Claude Code perfectly and costs less than a coffee per month.
```

---

### 10. FAQ ACCORDION

**Section Title:** "Frequently Asked Questions"

**Q: Is this actually secure?**
```
Yes. Every server is provisioned with:
• UFW firewall denying all incoming traffic except SSH
• fail2ban banning IPs after 5 failed login attempts (1 hour ban)
• SSH configured for key-only authentication
• Root login completely disabled
• Automatic security updates via unattended-upgrades

This is the same security stack used by production servers.
```

**Q: Why Hetzner instead of AWS/GCP/DigitalOcean?**
```
Price-to-performance. A comparable server on AWS would cost 3-4x more. Hetzner's European data centers are fast, reliable, and they've been in business since 1997. For development workloads, it's hard to beat.
```

**Q: Can I run this on my existing server?**
```
The security hardening and Claude Code installation can be done manually on any Ubuntu server. Check the cloud-init configuration in the repository for the exact steps.
```

**Q: How do I connect from multiple computers?**
```
Add more SSH keys to ~/.ssh/authorized_keys on your server. Or use the same SSH key across your machines (less secure but more convenient).
```

**Q: What if I need more power?**
```
You can resize your server in the Hetzner console, or provision a larger type. cx32 (4 vCPU, 8GB) handles more demanding workloads, or go with dedicated CPU options for consistent performance.
```

**Q: Can I run multiple projects?**
```
Absolutely. Create a ~/projects directory, clone multiple repos, and cd into whichever one you're working on. Each project maintains its own state.
```

---

### 11. CTA FOOTER

**Headline:** "Ready to deploy?"

**Install command (with copy button):**
```bash
/provision my-server cx22 nbg1
```

**Links row:**
- GitHub: github.com/The-Resonance/claude-code-hetzner-vps
- Documentation: (link to README)

**Branding footer:**
```
A free tool by Pete Sena
labs.theresonance.studio | linkedin.com/in/petersena

No strings attached. No premium tier. Just useful software.
```

---

## IMPLEMENTATION NOTES

### Component Structure
```
/src
  /components
    /ui (shadcn components)
    Hero.tsx
    ProblemSolution.tsx
    FeaturesGrid.tsx
    VideoSection.tsx
    SetupGuide.tsx
    GitHubWorkflow.tsx
    WebApps.tsx
    Gotchas.tsx
    CostCalculator.tsx
    FAQ.tsx
    Footer.tsx
    CodeBlock.tsx (with copy button)
    TerminalAnimation.tsx
  /app
    page.tsx
    layout.tsx
    globals.css
```

### Animations
- Staggered fade-in on scroll (use framer-motion's whileInView)
- Terminal typing animation in hero (custom hook with setInterval)
- Smooth accordion transitions (shadcn default)
- Number counter for cost calculator
- Subtle hover glow on cards

### Responsive
- Mobile: Single column, full-width cards
- Tablet: 2-column grids
- Desktop: 3-column feature grid, side-by-side layouts

### Accessibility
- Proper heading hierarchy (h1 → h2 → h3)
- Alt text for any images/icons
- Keyboard navigation for accordion
- Focus states on interactive elements

---

Build the complete application with all the copy above. Make every section polished, every animation smooth, and the overall experience feel like it was built by a senior engineer at Vercel.
