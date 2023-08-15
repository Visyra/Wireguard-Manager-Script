#!/usr/bin/env python3

import os
import subprocess

def install_wireguard(distribution):
    if distribution in ["Ubuntu", "Debian", "Linux Mint", "Elementary OS", "Zorin OS", "Kali Linux"]:
        os.system("sudo apt-get update")
        os.system("sudo apt-get install wireguard")
    elif distribution in ["Fedora", "CentOS", "RHEL", "CentOS Stream", "Mageia", "Fedora Workstation", "Fedora Server", "Fedora Silverblue", "Clear Linux", "Calculate Linux", "Sabayon"]:
        os.system("sudo dnf install wireguard-tools")
    elif distribution in ["Arch Linux", "Manjaro", "Antergos", "EndeavourOS", "BlackArch Linux", "Trisquel", "Void Linux", "NixOS"]:
        os.system("sudo pacman -S wireguard-tools")
    elif distribution in ["openSUSE", "Solus", "MX Linux", "Puppy Linux", "Alpine Linux", "Parrot OS", "Tails", "Slax", "Peppermint OS", "Bodhi Linux", "SystemRescueCd", "CRUX", "GhostBSD", "TrueOS", "Project Trident", "OpenBSD", "FreeBSD"]:
        os.system("sudo zypper install wireguard-tools")
    else:
        print("Distribution not recognized or supported.")
        exit(1)

def uninstall_wireguard(distribution):
    if distribution in ["Ubuntu", "Debian", "Linux Mint", "Elementary OS", "Zorin OS", "Kali Linux"]:
        os.system("sudo apt-get remove --purge wireguard")
    elif distribution in ["Fedora", "CentOS", "RHEL", "CentOS Stream", "Mageia", "Fedora Workstation", "Fedora Server", "Fedora Silverblue", "Clear Linux", "Calculate Linux", "Sabayon"]:
        os.system("sudo dnf remove wireguard-tools")
    elif distribution in ["Arch Linux", "Manjaro", "Antergos", "EndeavourOS", "BlackArch Linux", "Trisquel", "Void Linux", "NixOS"]:
        os.system("sudo pacman -Rs wireguard-tools")
    elif distribution in ["openSUSE", "Solus", "MX Linux", "Puppy Linux", "Alpine Linux", "Parrot OS", "Tails", "Slax", "Peppermint OS", "Bodhi Linux", "SystemRescueCd", "CRUX", "GhostBSD", "TrueOS", "Project Trident", "OpenBSD", "FreeBSD"]:
        os.system("sudo zypper remove wireguard-tools")
    else:
        print("Distribution not recognized or supported.")
        exit(1)

def add_vpn_tunnel():
    tunnel_name = input("Enter a name for the VPN tunnel: ")
    server_address = input("Enter the server's public IP or DNS: ")
    server_port = input("Enter the server's listening port: ")
    client_ip = input("Enter the client's private IP (e.g., 10.0.0.2): ")
    private_key = input("Enter the client's private key: ")

    tunnel_config = f"""
[Interface]
PrivateKey = {private_key}
Address = {client_ip}/24
DNS = 8.8.8.8

[Peer]
PublicKey = <server_public_key>
Endpoint = {server_address}:{server_port}
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
"""

    with open(f"/etc/wireguard/{tunnel_name}.conf", "w") as conf_file:
        conf_file.write(tunnel_config)

    subprocess.run(["wg-quick", "up", tunnel_name])
    print(f"VPN tunnel {tunnel_name} added and activated.")

def activate_vpn_tunnel():
    tunnel_name = input("Enter the name of the VPN tunnel to activate: ")
    subprocess.run(["wg-quick", "up", tunnel_name])
    print(f"VPN tunnel {tunnel_name} activated.")

def deactivate_vpn_tunnel():
    tunnel_name = input("Enter the name of the VPN tunnel to deactivate: ")
    subprocess.run(["wg-quick", "down", tunnel_name])
    print(f"VPN tunnel {tunnel_name} deactivated.")

def delete_vpn_tunnel():
    tunnel_name = input("Enter the name of the VPN tunnel to delete: ")
    subprocess.run(["wg-quick", "down", tunnel_name])
    os.remove(f"/etc/wireguard/{tunnel_name}.conf")
    print(f"VPN tunnel {tunnel_name} deleted.")

if os.geteuid() != 0:
    print("This script must be run as root.")
    exit(1)

print("Select an option:")
print("1. Install WireGuard")
print("2. Add VPN tunnel")
print("3. Activate VPN tunnel")
print("4. Deactivate VPN tunnel")
print("5. Delete VPN tunnel")
print("6. Uninstall WireGuard")

choice = input()

if choice == "1":
    distribution = input("Enter your distribution: ")
    install_wireguard(distribution)
elif choice == "2":
    add_vpn_tunnel()
elif choice == "3":
    activate_vpn_tunnel()
elif choice == "4":
    deactivate_vpn_tunnel()
elif choice == "5":
    delete_vpn_tunnel()
elif choice == "6":
    uninstall_wireguard()
else:
    print("Invalid choice.")
    exit(1)
