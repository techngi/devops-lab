#!/bin/bash
# ---------- Colors ----------
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
CYAN='\e[36m'
BOLD='\e[1m'
RESET='\e[0m'

name=$(hostname)
up=$(uptime | awk '{print $3,$4}' | sed 's/,//')
addr=$(ip -4 add | awk '/inet / && $2 !~ /127/ {print $2}' | cut -d/ -f1 | sed -n '2p')
ram=$(free -h | awk '/Mem:/ {print $2}')
#echo "Hostname is $name, Uptime is $up, and IP address is $addr"

# ---------- Output ----------
echo -e "${BOLD}${CYAN}===== System Details =====${RESET}"
echo -e "${GREEN}Hostname      :${RESET} $name"
echo -e "${GREEN}Uptime        :${RESET} $up"
#echo -e "${GREEN}CPU Cores     :${RESET} $cores"
echo -e "${GREEN}Total RAM     :${RESET} $ram"
#echo -e "${GREEN}Default GW    :${RESET} $gateway"
echo -e "${GREEN}IP Address    :${RESET} $addr"
echo -e "${BOLD}${CYAN}==========================${RESET}"
