#!/usr/bin/env bash

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
WHITE='\e[97m'
NC='\e[0m'

clear

header() {
  echo -e "${WHITE}┌───────────────────────────────┐${NC}"
  echo -e "${WHITE}│  🛠️  Windows XP Control Panel  │${NC}"
  echo -e "${WHITE}└───────────────────────────────┘${NC}"
}

about_me() {
  echo -e "${WHITE}┌──────────────────────────────────────────┐${NC}"
  echo -e "${WHITE}│${NC}  👤 ${GREEN}I am ${YELLOW}s3p${NC}                             │"
  echo -e "${WHITE}│${NC}  🌐 Website: ${BLUE}https://s3p.me${NC}              │"
  echo -e "${WHITE}│${NC}  💻 GitHub : ${MAGENTA}https://github.com/0v3rf3ar${NC} │"
  echo -e "${WHITE}└──────────────────────────────────────────┘${NC}"
  echo
}

menu() {
  echo -e "${YELLOW}Please select an option:${NC}"
  echo -e "${GREEN}[1]${NC} Prerequisites"
  echo -e "${GREEN}[2]${NC} Create Disk & Install"
  echo -e "${GREEN}[3]${NC} Boot Up"
  echo -e "${GREEN}[4]${NC} Exit"
}

prerequisites() {
  echo -e "${BLUE}Checking prerequisites...${NC}"
  sleep 1

  required_cmds=("pkg" "wget" "qemu-img" "qemu-system-x86_64")
  for cmd in "${required_cmds[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
      echo -e "${RED}Missing required command: $cmd${NC}"
      echo -e "${YELLOW}Attempting to install: $cmd${NC}"
      pkg install "$cmd" -y || {
        echo -e "${RED}Failed to install $cmd. Exiting.${NC}"
        exit 1
      }
    fi
  done

  ISO_URL="https://0x4.s3.ir-thr-at1.arvanstorage.ir/xp.iso"
  ISO_FILE="xp.iso"

  if [[ ! -f $ISO_FILE ]]; then
    echo -e "${CYAN}Downloading Windows XP ISO...${NC}"
    wget -O "$ISO_FILE" "$ISO_URL" || {
      echo -e "${RED}Failed to download ISO.${NC}"
      exit 1
    }
  else
    echo -e "${GREEN}ISO already exists. Skipping download.${NC}"
  fi

  echo -e "${GREEN}All prerequisites satisfied.${NC}"
}

installer() {
  echo -e "${BLUE}Running installer...${NC}"
  sleep 1
  echo -e "${CYAN}Enter desired Disk Space (e.g., 10G):${NC}"
  read -rp "Disk: " disk_space
  sleep 1
  echo -e "${CYAN}Creating qcow2 Disk...${NC}"
  qemu-img create -f qcow2 winxp.qcow2 "$disk_space"
  sleep 2
  echo -e "${GREEN}Disk created successfully.${NC}"
  sleep 1
  clear
  echo -e "${CYAN}RAM for Installation (e.g., 1024):${NC}"
  read -rp "RAM: " ram_value
  echo -e "${GREEN}Running Windows XP installer...${NC}"
  qemu-system-x86_64 -m "$ram_value" -cdrom xp.iso -boot d -drive file=winxp.qcow2,format=qcow2 -netdev user,id=n1 -device rtl8139,netdev=n1 -vga std -display vnc=:2 -cpu pentium3 -rtc base=localtime
}

boot_up() {
  echo -e "${CYAN}RAM (e.g., 1024):${NC}"
  read -rp "RAM: " ram
  echo -e "${CYAN}CPU (pentium3 or max):${NC}"
  read -rp "CPU: " cpu_type
  echo -e "${BLUE}Booting up...${NC}"
  sleep 1
  echo -e "${GREEN}System is now running. (Ctrl + C to shutdown)${NC}"
  qemu-system-x86_64 -m "$ram" -drive file=winxp.qcow2,format=qcow2 -netdev user,id=n1 -device rtl8139,netdev=n1 -vga std -display vnc=:2 -cpu "$cpu_type" -rtc base=localtime -boot c
}

while true; do
  clear
  header
  about_me
  menu
  echo
  read -rp "$(echo -e ${YELLOW}Enter your choice [1-4]:${NC} )" choice

  case $choice in
    1) prerequisites ;;
    2) installer ;;
    3) boot_up ;;
    4) echo -e "${RED}Exiting...${NC}"; exit 0 ;;
    *) echo -e "${RED}Invalid choice. Please try again.${NC}" ;;
  esac

  echo -e "${CYAN}Press Enter to return to the menu...${NC}"
  read
done
