#!/bin/bash

echo "====================="

if [ ! -e wls1036_dev.zip ]
then
  echo "Download the WebLogic 11gR1 ZIP Distribution and"
  echo "drop the file wls1036_dev.zip in this folder before"
  echo "building this WLS Docker container!"
  exit 
fi

MD5="9690c184b81731b8feaa245b0060a296  wls1036_dev.zip"
MD5_CHECK="`md5sum wls1036_dev.zip`"

if [ "$MD5" != "$MD5_CHECK" ]
then
  echo "MD5 does not match! Download again!"
  exit
fi

echo "====================="

docker build -t oracle/weblogic .

echo ""
echo "WebLogic Docker Container is ready to be used. To start, run 'dockWebLogic.sh'"

