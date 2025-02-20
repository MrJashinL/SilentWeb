import net
import os
import osproc

type
  VPNConnection = object
    protocol: string
    server: string
    username: string
    password: string

proc initializeVPN() {.exportc.} =
  discard execCmd("modprobe ppp-generic")
  discard execCmd("systemctl start strongswan")
  discard execCmd("systemctl start xl2tpd")

proc connectPPTP(server, username, password: string) {.exportc.} =
  let config = """
[ppp]
name $1
password $2
refuse-eap
refuse-chap
refuse-mschap
require-mppe
require-mschap-v2
""" % [username, password]
  
  writeFile("/etc/ppp/peers/vpn-pptp", config)
  discard execCmd("pon vpn-pptp")

proc connectL2TP(server, username, password: string) {.exportc.} =
  let config = """
conn L2TP-PSK
  type=transport
  keyexchange=ikev1
  authby=secret
  leftprotoport=udp/l2tp
  left=%defaultroute
  right=$1
""" % [server]
  
  writeFile("/etc/ipsec.conf", config)
  discard execCmd("ipsec restart")

proc connectSSTP(server, username, password: string) {.exportc.} =
  discard execCmd("sstp-client --cert-warn --user $1 --password $2 $3" % 
    [username, password, server])

proc connectOpenVPN(server, username, password: string) {.exportc.} =
  let config = """
client
remote $1
auth-user-pass
""" % [server]
  
  writeFile("/etc/openvpn/client.conf", config)
  discard execCmd("openvpn --config /etc/openvpn/client.conf")
