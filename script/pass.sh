#!/bin/sh


USB="usb2_sda1"

# If not specified, the mount point used will be "/mnt/usb2_sda1"
# Si no se especifica, el punto de montaje usado sera "/mnt/usb2_sda1"
if [ -z "$1" ]; then
    echo "No USB device specified. Using default: /mnt/$USB"
else
    USB="$1"
	echo "Using /mnt/$USB"
fi


# Copy current router configuration to USB
# Copia configuracion actual del router en el usb

/bin/cp /data/zcfg_config.json "/mnt/$USB/"

# Read the part of mtd0 where the passwords are stored and save to file in /tmp/
# Lee la parte de mtd0 donde se guardan los pass y lo guarda en archivo en /tmp/

/sbin/mtd -q -q readflash /tmp/flashdump 256 65280 bootloader

# Copy the dump to the USB
# Se copia el dump  al usb

/bin/cp /tmp/flashdump "/mnt/$USB/"

# Extract text strings to file
# Se extraen las cadenas de texto a archivo

/bin/grep -a "[\x80-\xFF]" /tmp/flashdump > "/mnt/$USB/pass.txt"

# hexdump in text format
# hexdump en formato texto

/usr/bin/hexdump -C /tmp/flashdump > "/mnt/$USB/hexdump_pass.txt"

