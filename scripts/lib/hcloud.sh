#!/bin/sh
# hcloud.sh - Hetzner CLI wrapper functions
# POSIX-compatible
# A free tool by Pete Sena | labs.theresonance.studio

set -eu

# Note: common.sh should be sourced by the calling script
# This file provides hcloud wrapper functions only

# Check if server exists
hcloud_server_exists() {
    server_name="$1"
    hcloud server describe "$server_name" >/dev/null 2>&1
}

# Get server IP
hcloud_get_ip() {
    server_name="$1"
    hcloud server ip "$server_name" 2>/dev/null
}

# Get server status
hcloud_get_status() {
    server_name="$1"
    hcloud server describe "$server_name" -o format='{{.Status}}' 2>/dev/null
}

# Get server type details
hcloud_get_server_type() {
    type_name="$1"
    hcloud server-type describe "$type_name" -o json 2>/dev/null
}

# List all servers
hcloud_list_servers() {
    hcloud server list 2>/dev/null
}

# List all server types
hcloud_list_server_types() {
    hcloud server-type list 2>/dev/null
}

# Ensure SSH key exists in Hetzner account
hcloud_ensure_ssh_key() {
    key_name="$1"
    pub_key_path="$2"

    # Check if key already exists
    if hcloud ssh-key describe "$key_name" >/dev/null 2>&1; then
        return 0
    fi

    # Upload key
    hcloud ssh-key create --name "$key_name" --public-key-from-file "$pub_key_path"
}

# Create server with cloud-init
hcloud_create_server() {
    server_name="$1"
    server_type="$2"
    location="$3"
    ssh_key_name="$4"
    user_data_file="$5"

    hcloud server create \
        --name "$server_name" \
        --type "$server_type" \
        --image ubuntu-24.04 \
        --location "$location" \
        --ssh-key "$ssh_key_name" \
        --user-data-from-file "$user_data_file"
}

# Delete server
hcloud_delete_server() {
    server_name="$1"
    hcloud server delete "$server_name"
}

# Wait for server to be running
hcloud_wait_for_running() {
    server_name="$1"
    max_attempts="${2:-30}"

    attempt=1
    while [ $attempt -le $max_attempts ]; do
        status=$(hcloud_get_status "$server_name" 2>/dev/null || echo "unknown")
        if [ "$status" = "running" ]; then
            return 0
        fi
        sleep 2
        attempt=$((attempt + 1))
    done

    return 1
}

# Get server details as formatted output
hcloud_server_details() {
    server_name="$1"
    hcloud server describe "$server_name" -o format='Name: {{.Name}}
Status: {{.Status}}
IP: {{.PublicNet.IPv4.IP}}
Type: {{.ServerType.Name}}
Location: {{.Datacenter.Name}}
Created: {{.Created}}'
}
