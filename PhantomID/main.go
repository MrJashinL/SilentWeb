package main

import (
    "fmt"
    "os"
    "flag"
)

var __author__ = "Jashin L."

type VPNConfig struct {
    Protocol    string
    Server      string
    Username    string
    Password    string
    UseTor      bool
}

func main() {
    protocol := flag.String("p", "", "VPN Protocol (pptp/l2tp/sstp/openvpn)")
    server := flag.String("s", "", "VPN Server address")
    username := flag.String("u", "", "Username")
    password := flag.String("pw", "", "Password")
    useTor := flag.Bool("t", false, "Use Tor")
    
    flag.Parse()
    
    config := VPNConfig{
        Protocol: *protocol,
        Server: *server,
        Username: *username,
        Password: *password,
        UseTor: *useTor,
    }
    
    startVPN(config)
}

func startVPN(config VPNConfig) {
    C.initialize_vpn()
    
    if config.UseTor {
        L.start_tor()
    }
    
    switch config.Protocol {
    case "pptp":
        C.connect_pptp(config.Server, config.Username, config.Password)
    case "l2tp":
        C.connect_l2tp(config.Server, config.Username, config.Password)
    case "sstp":
        C.connect_sstp(config.Server, config.Username, config.Password)
    case "openvpn":
        C.connect_openvpn(config.Server, config.Username, config.Password)
    }
}
