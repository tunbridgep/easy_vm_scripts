#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

FILE1=/etc/libvirt/qemu/$1.xml
XML_LOCATION=$2/$1.xml
if [ -f "$FILE1" ]; then
	if [[ -d $2 ]]; then
		echo "Backing up VM xml to $2"
		cp "$FILE1" "$XML_LOCATION"
	else
		echo "$2 does not exist (or is not a valid directory)"
	fi
else
	echo "$FILE1 does not exist"
fi
