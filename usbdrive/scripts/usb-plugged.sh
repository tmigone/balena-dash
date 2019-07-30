#!/bin/bash

echo "--- udev-plug-usb rule triggered ---" >> /app/usb.log
echo "$(date) $(ls -1 | wc -l)" >> /app/usb.log
echo "Serial id is $ID_SERIAL" >> /app/usb.log
echo "Usec id is $USEC_INITIALIZED" >> /app/usb.log
echo "Vendor id is $ID_VENDOR" >> /app/usb.log
echo "File system type $ID_FS_TYPE" >> /app/usb.log

# Mount device
if findmnt -rno SOURCE,TARGET $DEVNAME >/dev/null; then
    echo "Device $DEVNAME is already mounted!" >> /app/usb.log
else
    echo "Mounting device: $DEVNAME" >> /app/usb.log
    echo "Mounting destination: /mnt/storage-$USEC_INITIALIZED" >> /app/usb.log    
    mkdir -p /mnt/storage-$USEC_INITIALIZED >> /app/usb.log
    mount -t $ID_FS_TYPE -o rw $DEVNAME /mnt/storage-$USEC_INITIALIZED >> /app/usb.log
fi

# Sync files
echo "Sync: /mnt/storage-$USEC_INITIALIZED" >> /app/usb.log
rsync -a --delete /mnt/storage-$USEC_INITIALIZED/ /usbstorage

# Unmount device
if findmnt -rno SOURCE,TARGET $DEVNAME >/dev/null; then
    echo "Unmounting device: $DEVNAME" >> /app/usb.log
    unmount -f $DEVNAME
else
    echo "No deviced named $DEVNAME was found." >> /app/usb.log
fi

