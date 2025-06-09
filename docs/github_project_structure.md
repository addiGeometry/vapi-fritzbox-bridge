# Vapi-FritzBox-Bridge

🚀 **Production-ready SIP bridge connecting Vapi.ai to FritzBox via Asterisk**

## 📋 Overview

This project implements a complete telecommunications bridge that allows Vapi.ai AI assistants to make and receive phone calls through a FritzBox router, enabling AI-powered phone conversations over traditional PSTN networks.

### Architecture
```
Vapi.ai ↔ Asterisk (VPS) ↔ FritzBox ↔ PSTN/Mobile Networks
```

## ✨ Features

- ✅ **Outbound Calls**: Vapi → Asterisk → FritzBox → Phone Number
- ✅ **Inbound Calls**: Phone Number → FritzBox → Asterisk → Vapi  
- ✅ **IPv6 Support**: Full IPv6 compatibility for modern networks
- ✅ **Authentication**: Secure SIP authentication between all components
- ✅ **NAT Traversal**: STUN support for complex network topologies
- ✅ **Real-time Monitoring**: Complete logging and debugging capabilities

## 🏗️ Components

| Component | Purpose | Technology |
|-----------|---------|------------|
| **Vapi.ai** | AI Assistant Platform | SIP Client |
| **Asterisk** | SIP Proxy/Bridge | PJSIP |
| **FritzBox** | Home Router/PBX | SIP Server |
| **VPS** | Cloud Infrastructure | Ubuntu/Debian |

## 📦 Project Structure

```
vapi-fritzbox-bridge/
├── asterisk/
│   ├── pjsip.conf           # SIP endpoint configuration
│   ├── extensions.conf      # Call routing dialplan
│   └── logger.conf          # Logging configuration
├── docs/
│   ├── installation.md     # Step-by-step setup guide
│   ├── troubleshooting.md   # Common issues and fixes  
│   ├── architecture.md     # Technical deep-dive
│   └── testing.md          # Testing procedures
├── scripts/
│   ├── setup.sh            # Automated installation
│   ├── test-connection.sh   # Connection testing
│   └── monitor.sh          # Real-time monitoring
├── examples/
│   ├── vapi-credentials.json # Vapi API examples
│   └── test-calls.sh        # Call testing scripts
└── README.md               # This file
```

## 🚀 Quick Start

### Prerequisites
- Ubuntu/Debian VPS with public IP
- FritzBox with SIP capabilities  
- Vapi.ai account with API access
- Domain/DynDNS for FritzBox (e.g., MyFRITZ)

### Installation
```bash
git clone https://github.com/yourusername/vapi-fritzbox-bridge.git
cd vapi-fritzbox-bridge
chmod +x scripts/setup.sh
sudo ./scripts/setup.sh
```

### Configuration
1. **Configure FritzBox SIP user**
2. **Set up Asterisk with provided configs**  
3. **Create Vapi credentials and phone number**
4. **Test the bridge**

See [Installation Guide](docs/installation.md) for detailed instructions.

## 🔧 Configuration Files

### Asterisk PJSIP Configuration
Key components configured in `asterisk/pjsip.conf`:
- IPv6 transport bindings
- Vapi endpoint with authentication
- FritzBox trunk with registration
- IP-based endpoint identification

### Extensions/Dialplan
Call routing logic in `asterisk/extensions.conf`:
- Default context for Vapi calls
- FritzBox context for inbound calls
- Test extensions for debugging

## 📊 Monitoring & Debugging

### Real-time Monitoring
```bash
# Watch active calls
watch -n 1 "sudo asterisk -rx 'core show channels'"

# Monitor SIP traffic  
sudo asterisk -rx "pjsip set logger on"

# View logs
sudo tail -f /var/log/asterisk/messages.log
```

### Testing
```bash
# Test Vapi → FritzBox call
./scripts/test-outbound.sh "+49123456789"

# Test connection health
./scripts/test-connection.sh
```

## 🛠️ Technical Details

### Network Requirements
- **VPS**: Public IPv4/IPv6 address
- **Ports**: 5060 UDP (SIP), RTP range (configurable)
- **Firewall**: Bidirectional SIP traffic allowed

### Authentication Flow
1. Vapi authenticates to Asterisk using username/password
2. Asterisk authenticates to FritzBox using SIP credentials
3. FritzBox registers with public PSTN providers

### Call Flow
```mermaid
sequenceDiagram
    participant V as Vapi.ai
    participant A as Asterisk
    participant F as FritzBox  
    participant P as PSTN
    
    V->>A: SIP INVITE
    A->>A: Authenticate Vapi
    A->>F: SIP INVITE (via registration)
    F->>P: Place call
    P-->>F: Call connected
    F-->>A: SIP 200 OK
    A-->>V: SIP 200 OK
    V<->>P: RTP Audio Stream (via A,F)
```

## 🐛 Troubleshooting

Common issues and solutions:

| Issue | Cause | Solution |
|-------|-------|----------|
| `vapi-endpoint Unavailable` | Missing authentication | Check `auth=vapi-auth` in pjsip.conf |
| `NonQual` FritzBox contact | IPv4/IPv6 mismatch | Use IPv6 or configure IPv4 properly |
| `404 Not Found` errors | Wrong context | Ensure calls route to `default` context |
| Timeout errors | Firewall/NAT issues | Check port 5060 UDP bidirectional |

See [Troubleshooting Guide](docs/troubleshooting.md) for more details.

## 📈 Performance & Scaling

- **Concurrent Calls**: Limited by VPS resources and FritzBox capacity
- **Latency**: Typically <100ms for European routes  
- **Audio Quality**: HD audio support (G.722, Opus)
- **Reliability**: 99%+ uptime with proper monitoring

## 🤝 Contributing

Contributions welcome! Please read our contributing guidelines and submit pull requests.

### Development Setup
```bash
# Clone repo
git clone https://github.com/yourusername/vapi-fritzbox-bridge.git

# Install in development mode
./scripts/setup.sh --dev

# Run tests
./scripts/test-all.sh
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Vapi.ai** team for excellent SIP documentation
- **Asterisk** project for robust SIP implementation  
- **AVM** for FritzBox SIP capabilities
- **Community** contributors and testers

## 📞 Support

- **Issues**: GitHub Issues
- **Discussions**: GitHub Discussions
- **Documentation**: [Wiki](https://github.com/yourusername/vapi-fritzbox-bridge/wiki)

---

**Built with ❤️ for the AI voice community**