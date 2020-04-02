#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "usage: $0 <qcow2_disk_name>"
    echo "please only use the name, without extension"
    echo "so /var/lib/libvirt/images/mydisk.qcow2 should be passed as mydisk"
    echo ""
    echo "names are as follows:"
    ls /var/lib/libvirt/images
else
    FILE=/var/lib/libvirt/images/$1.qcow2
    FILE_TEMP=$FILE.original
    if test -f "$FILE"; then
        echo "shrinking $FILE..."
        mv "$FILE" "$FILE_TEMP"
        qemu-img convert -p -O qcow2 "$FILE_TEMP" "$FILE"
        echo "shrink complete. Backup created at $FILE_TEMP"
    else
        echo "$FILE does not exist. Exiting..."
    fi
fi
