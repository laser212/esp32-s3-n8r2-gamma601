📘 Bitaxe Gamma 601 Firmware Flashing Guide (ESP32-S3 N8R2 - 25MHz XTAL)
This guide walks you through setting up your system and flashing the Bitaxe Gamma 601 miner with fully working firmware, NVS config, and Web UI.

✅ Requirements
You need a Linux system (Ubuntu/Debian recommended) and a Bitaxe Gamma 601 with an ESP32-S3 N8R2 and 25MHz crystal.

🧰 Install Dependencies
bash
Copy
Edit
# Install required tools and packages
sudo apt update && sudo apt install -y git cmake ninja-build python3 python3-pip libffi-dev libssl-dev dfu-util

# Install ESP-IDF v5.1+ (if not installed)
cd ~
git clone --recursive https://github.com/espressif/esp-idf.git
cd esp-idf
git checkout v5.1
./install.sh
Add ESP-IDF to your environment in your shell config (~/.bashrc, ~/.zshrc, etc.):

bash
Copy
Edit
echo 'source $HOME/esp-idf/export.sh' >> ~/.bashrc
source ~/.bashrc
Then reload terminal or run:

bash
Copy
Edit
source ~/esp-idf/export.sh
🧪 Extra Python Dependencies
bash
Copy
Edit
# Ensure nvs partition generator is installed
pip install esptool cryptography pyserial
pip install --upgrade setuptools wheel
pip install nvs-partition-gen
⚡ How to Use the Flash Script
Place the flash_bitaxe_601_n8r2_final.sh script in your project directory (e.g. esp-miner)

Ensure it is executable:

bash
Copy
Edit
chmod +x flash_bitaxe_601_n8r2_final.sh
Run the script:

bash
Copy
Edit
./flash_bitaxe_601_n8r2_final.sh
🛠 What This Script Does
✅ Cleans and builds the firmware
✅ Automatically generates NVS binary from config-601.cvs
✅ Flashes all required components:

Flash Address	Binary	Description
0x0000	bootloader.bin	Bootloader
0x8000	partition-table.bin	Flash partition map
0x10000	ota_data_initial.bin	OTA state tracking
0x20000	esp-miner.bin	Firmware
0x6C0000	www.bin	Web UI interface
0x7C0000	nvs.bin	NVS config (SSID, pool, etc.)
🔁 After Flashing
Monitor output (if needed):

bash
Copy
Edit
idf.py -p /dev/ttyACM0 monitor
Visit the Bitaxe Web UI from your network (hostname or IP address)

I amn not taking full credit for this script as it was made with help of Chat GPT special thank you to the Open Source Miners United Discord for the information and guidance needed to make this happen especialy to mutatrum for explaining to me what needs to be done. 

