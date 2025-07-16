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
  pkg update && pkg install qemu-utils qemu-system-x86_64-headless wget -y
  if [ ! -f "xp.iso" ]; then
    echo -e "${CYAN}Downloading Windows XP ISO...${NC}"
    wget https://0x4.s3.ir-thr-at1.arvanstorage.ir/xp.iso -O xp.iso
  else
    echo -e "${YELLOW}xp.iso already exists. Skipping download.${NC}"
  fi
  echo -e "${GREEN}All prerequisites satisfied.${NC}"
}

installer() {
  if [ ! -f "xp.iso" ]; then
    echo -e "${RED}xp.iso not found. Please run prerequisites first.${NC}"
    return
  fi

  expected_checksum="2074cdb6711c8edae43051566583a60570586902"
  actual_checksum=$(sha1sum xp.iso | awk '{print $1}')

  if [ "$actual_checksum" != "$expected_checksum" ]; then
    echo -e "${RED}Warning: Checksum mismatch for xp.iso${NC}"
    echo -e "${YELLOW}Expected:${NC} $expected_checksum"
    echo -e "${YELLOW}Actual:  ${NC} $actual_checksum"
    read -rp "$(echo -e ${RED}Continue anyway? [y/N]:${NC} )" proceed
    if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
      echo -e "${RED}Aborted due to checksum mismatch.${NC}"
      return
    fi
  else
    echo -e "${GREEN}Checksum verified successfully.${NC}"
  fi

  echo -e "${CYAN}Enter desired Disk Space (e.g., 10G):${NC}"
  read -rp "Disk: " disk_space
  echo -e "${CYAN}Creating qcow2 Disk...${NC}"
  qemu-img create -f qcow2 winxp.qcow2 "$disk_space"
  echo -e "${GREEN}Disk created successfully.${NC}"

  echo -e "${CYAN}RAM for Installation (e.g., 1024):${NC}"
  read -rp "RAM: " ram_value
  echo -e "${GREEN}Running Windows XP installer...${NC}"
  qemu-system-x86_64 -m "$ram_value" -cdrom xp.iso -boot d -drive file=winxp.qcow2,format=qcow2 -netdev user,id=n1 -device rtl8139,netdev=n1 -vga std -display vnc=:2 -cpu pentium3 -rtc base=localtime
}

boot_up() {
  echo -e "${CYAN}RAM(e.g., 1024):${NC}"
  read -rp "RAM: " ram
  echo -e "${CYAN}CPU(pentium3 or max):${NC}"
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
