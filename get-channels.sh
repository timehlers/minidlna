#!/bin/bash

if [ "$1" = "" ]; then
 echo "Usage $0 IP"
 exit 1
fi

channels=`wget "http://${1}:8080/playlist/channels" -O - 2>/dev/null | tr -d "\n" | sed "s%http://192.168.1.110:8080/stream/channelid/%;%g" | sed "s/#EXTINF:-1,/\n/g"`

if [ "$channels" != "" ]; then

 IFS=";"
 echo "$channels" | (while read name uuid; do

  if [ "${uuid%\?*}" != "" ]; then
   if [ ! -f "/var/lib/minidlna-tvheadend/services/Live TV/${uuid%\?*}.url" ]; then
    echo "$name" > "/var/lib/minidlna-tvheadend/services/Live TV/${uuid%\?*}.url"
   else
    echo "/var/lib/minidlna-tvheadend/services/Live TV/${uuid%\?*}.url already exists"
   fi
  fi

 done)

fi
