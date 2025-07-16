# WinXP-Termux
A Rootless installation script of windows XP on Termux android
| Control Panel | Windows XP in Action |
|---------------|-----------------------|
| ![ctrlpl](https://raw.githubusercontent.com/0v3rf3ar/winXP-Termux/refs/heads/main/ctrlpl.webp) | ![windowXp](https://raw.githubusercontent.com/0v3rf3ar/winXP-Termux/refs/heads/main/windowXp.webp) |

## 🚀 Usage
Copy and paste this code below to your termux shell.
```bash
cd ~
mkdir xp && cd xp
curl -O https://raw.githubusercontent.com/0v3rf3ar/winXP-Termux/refs/heads/main/control-panel.sh
chmod +x control-panel.sh
./control-panel.sh
```
***
### 🛠️ Installation

1. Choose "Prerequisites" at first run in order to install the required packages & the ISO file.
2. Go back to the menu and select Create Disk & Install.
    * Enter the desired disk size (e.g., 10G).
    * For RAM, 1024 MB is enough, but you can allocate more depending on your phone's specs.


3. After you see "Running Windows XP installer" you can go to your VNC client and connect to `localhost:5902`. From there you can do the installation.
4. Install could take a while depending on your phone but after it is finished, it will boot to your Windows XP. you can shutdown the windows from vnc like a normal system or hit (Ctrl + C)
5. Next time you want to run it, choose "Boot Up" from control panel and choose your desired RAM and CPU type, for maximum performance choose `max` CPU type.

This project is just for nostalgia but you can make it work and have fun with it :) 

---

### 💡 Also, Check Out My Weblog!

Want more nostalgic, fun, and technical content like this?

➡️ Dive into my posts at **[s3p.me](https://s3p.me)** — I write about hacking, CTF, and creative projects.

> 🧠 From reverse engineering old systems to building tools, there's always something cool happening.

Stay curious. Stay awesome. 😎
