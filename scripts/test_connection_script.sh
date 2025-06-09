#!/bin/bash

# Vapi-FritzBox-Bridge Connection Test
# Usage: ./test-connection.sh

set -e

echo "🧪 Testing Vapi-FritzBox-Bridge Connection..."
echo "============================================="

# Test 1: Asterisk Status
echo "1️⃣ Testing Asterisk status..."
if systemctl is-active --quiet asterisk; then
    echo "   ✅ Asterisk is running"
else
    echo "   ❌ Asterisk is not running"
    exit 1
fi

# Test 2: PJSIP Endpoints
echo "2️⃣ Testing PJSIP endpoints..."
ENDPOINTS=$(asterisk -rx "pjsip show endpoints" | grep -c "Objects found:")
if [[ $ENDPOINTS -gt 0 ]]; then
    echo "   ✅ PJSIP endpoints loaded"
    asterisk -rx "pjsip show endpoints" | grep "Endpoint:"
else
    echo "   ❌ No PJSIP endpoints found"
    exit 1
fi

# Test 3: Authentication Objects
echo "3️⃣ Testing authentication objects..."
AUTHS=$(asterisk -rx "pjsip show auths" | grep -c "vapi-auth\|fritzbox-auth")
if [[ $AUTHS -eq 2 ]]; then
    echo "   ✅ Authentication objects loaded"
    asterisk -rx "pjsip show auths"
else
    echo "   ❌ Authentication objects missing"
    exit 1
fi

# Test 4: FritzBox Registration
echo "4️⃣ Testing FritzBox registration..."
REGISTRATIONS=$(asterisk -rx "pjsip show registrations" | grep -c "Registered")
if [[ $REGISTRATIONS -gt 0 ]]; then
    echo "   ✅ FritzBox registration active"
    asterisk -rx "pjsip show registrations"
else
    echo "   ⚠️ FritzBox registration not active (check credentials)"
fi

# Test 5: Network Connectivity
echo "5️⃣ Testing network connectivity..."
PUBLIC_IP=$(curl -s ifconfig.me || echo "unknown")
echo "   🌐 Public IP: $PUBLIC_IP"

# Test port 5060
if netstat -ulnp | grep -q ":5060"; then
    echo "   ✅ Port 5060 UDP is listening"
else
    echo "   ❌ Port 5060 UDP is not listening"
    exit 1
fi

# Test 6: Dialplan
echo "6️⃣ Testing dialplan..."
if asterisk -rx "dialplan show default" | grep -q "_X."; then
    echo "   ✅ Default context configured"
else
    echo "   ❌ Default context missing"
    exit 1
fi

echo ""
echo "🎉 Connection test completed!"
echo ""
echo "📊 Summary:"
echo "   - Asterisk: Running ✅"
echo "   - PJSIP: Configured ✅"  
echo "   - Authentication: Ready ✅"
echo "   - FritzBox: $([ $REGISTRATIONS -gt 0 ] && echo "Connected ✅" || echo "Check config ⚠️")"
echo "   - Network: Ready ✅"
echo "   - Dialplan: Configured ✅"
echo ""
echo "🚀 Ready for Vapi integration!"
echo ""
echo "Next: Create Vapi credentials with this IP: $PUBLIC_IP"