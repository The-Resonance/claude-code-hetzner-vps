# Security Hardening Reference

Complete security configuration applied to every provisioned server.

## UFW Firewall

### Default Configuration
```bash
# Deny all incoming by default
ufw default deny incoming

# Allow all outgoing
ufw default allow outgoing

# Allow SSH
ufw allow 22/tcp

# Enable firewall
ufw --force enable
```

### Adding Web Server Ports
```bash
# HTTP
sudo ufw allow 80/tcp

# HTTPS
sudo ufw allow 443/tcp

# Custom port (e.g., Node.js dev server)
sudo ufw allow 3000/tcp
```

### Useful Commands
```bash
# Check status
sudo ufw status verbose

# List rules with numbers
sudo ufw status numbered

# Delete a rule
sudo ufw delete [rule-number]

# Reset to defaults
sudo ufw reset
```

## fail2ban

### Configuration (/etc/fail2ban/jail.local)
```ini
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600    # 1 hour
findtime = 600    # 10 minutes
```

### Useful Commands
```bash
# Check SSH jail status
sudo fail2ban-client status sshd

# Unban an IP
sudo fail2ban-client set sshd unbanip [IP-ADDRESS]

# Ban an IP manually
sudo fail2ban-client set sshd banip [IP-ADDRESS]

# Restart fail2ban
sudo systemctl restart fail2ban
```

## SSH Hardening

### Configuration (/etc/ssh/sshd_config.d/hardening.conf)
```
# Disable root login
PermitRootLogin no

# Disable password authentication
PasswordAuthentication no

# Enable public key authentication
PubkeyAuthentication yes

# Limit authentication attempts
MaxAuthTries 3

# Disable forwarding (security)
X11Forwarding no
AllowAgentForwarding no
AllowTcpForwarding no
```

### Verifying SSH Config
```bash
# Test configuration
sudo sshd -t

# Restart SSH (after changes)
sudo systemctl restart sshd
```

## Automatic Updates

Unattended upgrades are enabled for security patches:
```bash
# Check status
systemctl status unattended-upgrades

# View logs
cat /var/log/unattended-upgrades/unattended-upgrades.log
```

## User Configuration

### Non-root 'claude' User
- Has sudo access (NOPASSWD for convenience)
- Home directory: /home/claude
- SSH keys copied from root
- Claude Code pre-installed

### Switching Users
```bash
# From root to claude
su - claude

# Run command as root
sudo [command]
```

## Security Checklist

After provisioning, verify:

- [ ] UFW firewall active: `sudo ufw status`
- [ ] fail2ban running: `sudo systemctl status fail2ban`
- [ ] SSH key-only: Try password login (should fail)
- [ ] Root login disabled: `ssh root@[ip]` (should fail)
- [ ] Updates enabled: `systemctl status unattended-upgrades`

## Additional Hardening (Optional)

### Disable IPv6 (if not needed)
```bash
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Install audit logging
```bash
sudo apt install auditd
sudo systemctl enable auditd
```

### Restrict SSH to specific IPs
```bash
# Allow only your IP
sudo ufw delete allow 22/tcp
sudo ufw allow from [YOUR-IP] to any port 22
```
