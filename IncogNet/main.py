#!/usr/bin/env python3
import argparse
import ctypes
import os
import platform

__author__ = "Jashin L."

class IncogNet:
    def __init__(self):
        self.lib = ctypes.CDLL('./target/release/libdns_handler.so')
        self.dns_files = {
            'Linux': '/etc/resolv.conf',
            'Darwin': '/private/etc/resolv.conf',
            'Windows': 'C:\\Windows\\System32\\drivers\\etc\\hosts'
        }
        
    def clear_dns_cache(self):
        return self.lib.clear_dns_cache()
        
    def modify_dns(self, new_dns):
        return self.lib.modify_dns(new_dns.encode())
        
    def list_dns(self):
        return self.lib.list_current_dns()

def main():
    parser = argparse.ArgumentParser(description='IncogNet - DNS Management Tool')
    parser.add_argument('-c', '--clear', action='store_true', help='Clear DNS cache')
    parser.add_argument('-m', '--modify', help='Modify DNS server')
    parser.add_argument('-l', '--list', action='store_true', help='List current DNS')
    
    args = parser.parse_args()
    tool = IncogNet()
    
    if args.clear:
        if tool.clear_dns_cache():
            print("[+] DNS cache cleared successfully")
    elif args.modify:
        if tool.modify_dns(args.modify):
            print(f"[+] DNS changed to {args.modify}")
    elif args.list:
        tool.list_dns()

if __name__ == "__main__":
    main()
