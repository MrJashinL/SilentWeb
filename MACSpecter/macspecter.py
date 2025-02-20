#!/usr/bin/env python3
import ctypes
import argparse
import subprocess
import re
from typing import Optional

__author__ = "Jashin L."

class MACSpecter:
    def __init__(self):
        self.lib = ctypes.CDLL('./mac_operations.so')
        
    def validate_mac(self, mac: str) -> bool:
        pattern = r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$'
        return bool(re.match(pattern, mac))
    
    def change_mac(self, interface: str, new_mac: str) -> bool:
        if not self.validate_mac(new_mac):
            return False
            
        return bool(self.lib.change_mac_address(
            interface.encode(),
            new_mac.encode()
        ))

def main():
    parser = argparse.ArgumentParser(description='MACSpecter - Advanced MAC Address Spoofing Tool')
    parser.add_argument('-i', '--interface', required=True, help='Network interface')
    parser.add_argument('-m', '--mac', required=True, help='New MAC address')
    
    args = parser.parse_args()
    spoofer = MACSpecter()
    
    if spoofer.change_mac(args.interface, args.mac):
        print(f"[+] MAC address changed successfully on {args.interface}")
    else:
        print("[-] Failed to change MAC address")

if __name__ == '__main__':
    main()
