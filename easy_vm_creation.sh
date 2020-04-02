#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if ! [ -x "$(command -v xmlstarlet)" ]; then
    echo "you need xmlstarlet to use this script"
    exit 1;
fi


if [ $# == 4 ] && ([ $3 == "-d" ] || [ $3 == "-s" ]); then

    NEW_XML="./$2.xml"
    NEW_DISK=/var/lib/libvirt/images/$2.qcow2
    

    #copy and modify xml
    cp "$1" "$NEW_XML" 

    #change name parameter
    xmlstarlet ed --inplace -u 'domain/name' -v "$2" "$NEW_XML"

    #delete uuid parameter
    xmlstarlet ed --inplace -d 'domain/uuid' "$NEW_XML"

    #change storage parameter to use this one
    xmlstarlet ed --inplace -u "//source[contains(@file, '.qcow2')]/@file" -v "$NEW_DISK" "$NEW_XML"

    if [ $3 == "-s" ]; then
        echo "creating new VM $2 using new disk $NEW_DISK of size $4"
        qemu-img create -f qcow2 $NEW_DISK $4
    else
        if [ ! -f "$4" ]; then
            echo "disk image $4 was not found. Exiting..."
            exit 1;
        else
            echo "creating new VM $2 using disk $NEW_DISK and $2.xml"
            #copy disk to correct place
            qemu-img convert -p -O qcow2 "$4" "$NEW_DISK"
        fi
    fi

    virsh define $NEW_XML
    echo ""
    echo "new VM created. Don't forget to assign a bootable disk if you need to!"
    rm $NEW_XML
else
    echo "usage: $0 <existing_xml_file> <new_domain_name> -d <hard_disk_image_path>"
    echo "or"
    echo "usage: $0 <existing_xml_file> <new_domain_name> -s <size>"
    echo "note that hard disk image will be copied"
    echo "if path does not exist and a size is provided, a new image will be created of that size"
    echo ""
    echo "existing disk images located at /var/lib/libvirt/images are as follows:"
    ls /var/lib/libvirt/images
    echo ""
    echo "vm names are as follows"
    virsh list --all
fi
