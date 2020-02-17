#!/usr/bin/env bash
source yadisk_download.sh
public_link="https://yadi.sk/d/E5KggBOE3QYwc7" # test_data.tar
name=`yadisk_download $public_link`

echo -n "Unpacking $name..."
tar -xvf "$name" >> /dev/null
echo -e "\b\b\b  --> Done"
echo -n "Removing $name..."
rm "$name"
echo -e "\b\b\b --> Done"

