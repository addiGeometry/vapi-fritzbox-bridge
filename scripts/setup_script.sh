#!/bin/bash

# Vapi-FritzBox-Bridge Setup Script
# Usage: sudo ./setup.sh

set -e

echo "🚀 Starting Vapi-FritzBox-Bridge Setup..."

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run as root (use sudo)"
   exit 1
fi

# Update system
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install Asterisk
echo "📞 Installing Asterisk..."
apt install -y asterisk asterisk-core-sounds-en-gsm

# Create backup of original configs
echo "💾 Backing up original configurations..."
cp /etc/asterisk/pjsip.conf /etc/asterisk/pjsip.conf.original 2>/dev/null || true
cp /etc/asterisk/extensions.conf /etc/asterisk/extensions.conf.original 2>/dev/null || true

# Copy our configurations
echo "⚙️ Installing bridge configurations..."
cp asterisk/pjsip.conf /etc/asterisk/
cp asterisk/extensions.conf /etc/asterisk/
cp asterisk/logger.conf /etc/asterisk/

# Set correct permissions
chown asterisk:asterisk /etc/asterisk/*.conf
chmod 640 /etc/asterisk/*.conf

# Enable and start Asterisk
echo "🔧 Starting Asterisk service..."
systemctl enable asterisk
systemctl restart asterisk

# Wait for Asterisk to start
sleep 5

# Configure firewall (UFW)
echo "🔥 Configuring firewall..."
ufw allow 5060/udp comment "SIP"
ufw allow 7078:7097/udp comment "RTP"

# Test Asterisk installation
echo "🧪 Testing Asterisk installation..."
if asterisk -rx "core show version" >/dev/null 2>&1; then
    echo "✅ Asterisk is running successfully"
else
    echo "❌ Asterisk failed to start"
    exit 1
fi

echo ""
echo "🎉 Base installation complete!"
echo ""
echo "📋 Next steps:"
echo "1. Edit /etc/asterisk/pjsip.conf and set your FritzBox password"
echo "2. Configure your FritzBox SIP user (see docs/installation.md)"
echo "3. Create Vapi credentials using the API"
echo "4. Run ./scripts/test-connection.sh to verify"
echo ""
echo "📖 See docs/installation.md for detailed configuration instructions"