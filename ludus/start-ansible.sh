#!/bin/bash
# if error fork() in macos -> use: export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

set -e  # exit on error

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# output functions
info() { echo -e "[+] $1"; }
success() { echo -e "${GREEN}[+]${NC} $1"; }
warning() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; exit 1; }

# check prerequisites
command -v ludus >/dev/null || error "ludus not found"
command -v jq >/dev/null || error "jq not found" 
command -v ansible-playbook >/dev/null || error "ansible not found"
[ -f "hosts.yml" ] || error "hosts.yml not found"
[ -d "../ansible" ] || error "run from ludus directory"

info "getting Ludus range number"
LUDUSRANGENUMBER=$(ludus range list --json | jq -r '.rangeNumber') || error "failed to get range"
[ "$LUDUSRANGENUMBER" != "null" ] && [ -n "$LUDUSRANGENUMBER" ] || error "no active range found"
export LUDUSRANGENUMBER

info "creating Ansible inventory"
[ -f "../ansible/inventory/hosts.yml" ] && cp "../ansible/inventory/hosts.yml" "../ansible/inventory/hosts.yml.backup"
sed "s/LUDUSRANGENUMBER/$LUDUSRANGENUMBER/g" hosts.yml > ../ansible/inventory/hosts.yml || error "failed to create inventory"

info "extracting WireGuard config"
ludus user wireguard > training-wg.conf || error "failed to get WireGuard config"

warning "connect to WireGuard VPN before continuing!"
warning "import training-wg.conf into your WireGuard client"
read -p "connected to VPN? [y/N]: " -r
[[ ! $REPLY =~ ^[Yy]$ ]] && error "VPN connection required"

info "testing connectivity"
if ping -c1 -W3 "10.$LUDUSRANGENUMBER.10.100" >/dev/null 2>&1; then
    success "lab connectivity OK"
else
    warning "cannot reach lab, check your VPN connection!"
    exit 1
fi

info "running Ansible playbook"
cd ../ansible || error "cannot change to ansible directory"
[ -f "main.yml" ] || error "main.yml not found"
ansible-playbook main.yml || error "ansible failed"

success "LAB READY. ENJOY!"
