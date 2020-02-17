#!/usr/bin/env bash

# dereference public yandex-disk link and download; print name of downloaded file to stdout
yadisk_download ()
{
    public_link=$1
    base="https://cloud-api.yandex.net/v1/disk/public/resources?public_key="
    response=`curl $base$public_link --ipv4 --silent`
    address=`echo $response | sed -e 's/.*"file":"\([^"]*\)".*/\1/'`
    name=`echo $response | sed -e 's/.*"name":"\([^"]*\)".*/\1/'`
    >&2 echo Downloading "$name..." # print this to stderr so stdout can have only $name
    if `curl "$address" -L --output $name --ipv4 --progress-bar`; then
        >&2 echo "$name: Download finished"
    else
        >&2 echo "$name: Download failed"
    fi
    echo $name
}
