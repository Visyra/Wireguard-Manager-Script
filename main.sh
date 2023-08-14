#!/bin/bash

install_wireguard() {
    distribution=$1

    case $distribution in
        "Ubuntu" | "Debian" | "Linux Mint" | "Elementary OS" | "Zorin OS" | "Kali Linux")
            sudo apt-get update
            sudo apt-get install wireguard
            ;;
        "Fedora" | "CentOS" | "RHEL" | "CentOS Stream" | "Mageia" | "Fedora Workstation" | "Fedora Server" | "Fedora Silverblue" | "Clear Linux" | "Calculate Linux" | "Sabayon")
            sudo dnf install wireguard-tools
            ;;
        "Arch Linux" | "Manjaro" | "Antergos" | "EndeavourOS" | "BlackArch Linux" | "Trisquel" | "Void Linux" | "NixOS")
            sudo pacman -S wireguard-tools
            ;;
        "openSUSE" | "Solus" | "MX Linux" | "Puppy Linux" | "Alpine Linux" | "Parrot OS" | "Tails" | "Slax" | "Peppermint OS" | "Bodhi Linux" | "SystemRescueCd" | "CRUX" | "GhostBSD" | "TrueOS" | "Project Trident" | "OpenBSD" | "FreeBSD")
            sudo zypper install wireguard-tools
            ;;
        *)
            echo "Distribution not recognized or supported."
            exit 1
            ;;
    esac
}

uninstall_wireguard() {
    distribution=$1

    case $distribution in
        "Ubuntu" | "Debian" | "Linux Mint" | "Elementary OS" | "Zorin OS" | "Kali Linux")
            sudo apt-get remove --purge wireguard
            ;;
        "Fedora" | "CentOS" | "RHEL" | "CentOS Stream" | "Mageia" | "Fedora Workstation" | "Fedora Server" | "Fedora Silverblue" | "Clear Linux" | "Calculate Linux" | "Sabayon")
            sudo dnf remove wireguard-tools
            ;;
        "Arch Linux" | "Manjaro" | "Antergos" | "EndeavourOS" | "BlackArch Linux" | "Trisquel" | "Void Linux" | "NixOS")
            sudo pacman -Rs wireguard-tools
            ;;
        "openSUSE" | "Solus" | "MX Linux" | "Puppy Linux" | "Alpine Linux" | "Parrot OS" | "Tails" | "Slax" | "Peppermint OS" | "Bodhi Linux" | "SystemRescueCd" | "CRUX" | "GhostBSD" | "TrueOS" | "Project Trident" | "OpenBSD" | "FreeBSD")
            sudo zypper remove wireguard-tools # or appropriate package manager command
            ;;
        *)
            echo "Distribution not recognized or supported."
            exit 1
            ;;
    esac

    echo "WireGuard uninstalled from $distribution."
}

add_vpn_tunnel() {
    read -p "Enter a name for the VPN tunnel: " tunnel_name
    read -p "Enter the server's public IP or DNS: " server_address
    read -p "Enter the server's listening port: " server_port
    read -p "Enter the client's private IP (e.g., 10.0.0.2): " client_ip
    read -p "Enter the client's private key (generate using 'wg genkey'): " private_key

    cat << EOF >> /etc/wireguard/$tunnel_name.conf
[Interface]
PrivateKey = $private_key
Address = $client_ip/24
DNS = 8.8.8.8

[Peer]
PublicKey = <server_public_key>
Endpoint = $server_address:$server_port
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF

    wg-quick up $tunnel_name
    echo "VPN tunnel $tunnel_name added and activated."
}

activate_vpn_tunnel() {
    read -p "Enter the name of the VPN tunnel to activate: " tunnel_name
    wg-quick up $tunnel_name
    echo "VPN tunnel $tunnel_name activated."
}

deactivate_vpn_tunnel() {
    read -p "Enter the name of the VPN tunnel to deactivate: " tunnel_name
    wg-quick down $tunnel_name
    echo "VPN tunnel $tunnel_name deactivated."
}

delete_vpn_tunnel() {
    read -p "Enter the name of the VPN tunnel to delete: " tunnel_name
    wg-quick down $tunnel_name
    rm -f /etc/wireguard/$tunnel_name.conf
    echo "VPN tunnel $tunnel_name deleted."
}

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

echo "Select an option:"
echo "1. Install WireGuard"
echo "2. Add VPN tunnel"
echo "3. Activate VPN tunnel"
echo "4. Deactivate VPN tunnel"
echo "5. Delete VPN tunnel"
echo "6. Uninstall WireGuard"

read choice

case $choice in
    1)
        read -p "Enter your distribution: " distribution
        install_wireguard "$distribution"
        ;;
    2)
        add_vpn_tunnel
        ;;
    3)
        activate_vpn_tunnel
        ;;
    4)
        deactivate_vpn_tunnel
        ;;
    5)
        delete_vpn_tunnel
        ;;
    6)
        uninstall_wireguard
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac
