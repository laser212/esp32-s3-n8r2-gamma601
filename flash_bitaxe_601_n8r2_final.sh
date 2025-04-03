#!/bin/bash
set -e

# ✅ CONFIGURATION
PORT="/dev/ttyACM0"
CSV_FILE="config-601.cvs"  # ⚠️ Your file is .cvs, not .csv
NVS_BIN="build/nvs.bin"

echo "🚀 Setting up Bitaxe Gamma 601 for ESP32-S3 N8R2 (25MHz XTAL)..."

# ✅ Step 1: Clean & Build
echo "🧹 Cleaning previous build..."
idf.py fullclean

echo "🛠️  Building firmware..."
idf.py build

# ✅ Step 2: Generate NVS Binary from .cvs
echo "📄 Generating NVS binary from $CSV_FILE..."

python $IDF_PATH/components/nvs_flash/nvs_partition_generator/nvs_partition_gen.py generate \
  "$CSV_FILE" "$NVS_BIN" 0x6000 --version 2

echo "📦 NVS binary created: $NVS_BIN"

# ✅ Step 3: Flash Firmware
echo "⚡ Flashing firmware to $PORT..."

python -m esptool \
  --chip esp32s3 \
  -p $PORT \
  -b 460800 \
  --before default_reset \
  --after hard_reset write_flash \
  --flash_mode dio \
  --flash_size 8MB \
  --flash_freq 80m \
  0x0000 build/bootloader/bootloader.bin \
  0x8000 build/partition_table/partition-table.bin \
  0x10000 build/ota_data_initial.bin \
  0x20000 build/esp-miner.bin \
  0x6C0000 build/www.bin \
  0x09000 build/nvs.bin

# ✅ Step 4: Monitor
echo "✅ Flash complete. Launching monitor..."
idf.py -p $PORT monitor
