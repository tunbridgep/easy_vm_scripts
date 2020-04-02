#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

FILE1=/var/lib/libvirt/images/$1.qcow2
FILE2=/etc/libvirt/qemu/$1.xml
FILE_SHRUNK=$2/$1-shrunk.qcow2
XML_LOCATION=$2/$1.xml
if [ -f "$FILE1" ] && [ -f "$FILE2" ]; then
	if [[ -d $2 ]]; then
		echo "Backing up VM to $2"
		cp "$FILE2" "$XML_LOCATION"
		qemu-img convert -p -c -O qcow2 "$FILE1" "$FILE_SHRUNK"
	else
		echo "$2 does not exist (or is not a valid directory)"
	fi
else
	echo "$FILE1 or $FILE2 does not exist"
fi
