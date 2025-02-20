#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_arp.h>
#include <arpa/inet.h>
#include "mac_operations.h"

int change_mac_address(const char* interface, const char* new_mac) {
    struct ifreq ifr;
    int sock;
    
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) return 0;
    
    strncpy(ifr.ifr_name, interface, IFNAMSIZ);
    
    if (ioctl(sock, SIOCGIFFLAGS, &ifr) < 0) {
        close(sock);
        return 0;
    }
    
    ifr.ifr_flags &= ~IFF_UP;
    if (ioctl(sock, SIOCSIFFLAGS, &ifr) < 0) {
        close(sock);
        return 0;
    }
    
    ifr.ifr_hwaddr.sa_family = ARPHRD_ETHER;
    sscanf(new_mac, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
           &ifr.ifr_hwaddr.sa_data[0],
           &ifr.ifr_hwaddr.sa_data[1],
           &ifr.ifr_hwaddr.sa_data[2],
           &ifr.ifr_hwaddr.sa_data[3],
           &ifr.ifr_hwaddr.sa_data[4],
           &ifr.ifr_hwaddr.sa_data[5]);
           
    if (ioctl(sock, SIOCSIFHWADDR, &ifr) < 0) {
        close(sock);
        return 0;
    }
    
    if (ioctl(sock, SIOCGIFFLAGS, &ifr) < 0) {
        close(sock);
        return 0;
    }
    
    ifr.ifr_flags |= IFF_UP;
    if (ioctl(sock, SIOCSIFFLAGS, &ifr) < 0) {
        close(sock);
        return 0;
    }
    
    close(sock);
    return 1;
}
