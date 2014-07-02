#!/bin/sh
if [ -e "weblogic.cid" ]
then
  docker kill `cat weblogic.cid` > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    rm -f weblogic.cid
  else
    docker rm `cat weblogic.cid`  > /dev/null 2>&1 && rm weblogic.cid
  fi
fi

if [ ""$1 = "-attach" ]
then
  ATTACH_DEFAULT_PORT="-p 7001:7001"
fi

docker run -d $ATTACH_DEFAULT_PORT --cidfile weblogic.cid --name wls12cdev oracle/weblogic12c_dev /u01/oracle/wls12130/user_projects/domains/base_domain/startWebLogic.sh # > /dev/null 2>&1

if [ -n "${ATTACH_DEFAULT_PORT}" ]
then
  WLS_ADMIN_IP=127.0.0.1
else
  WLS_ADMIN_IP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' wls12cdev)
fi

echo "WebLogic starting... "
sleep 10
echo "Open WebLogic Console at http://${WLS_ADMIN_IP}:7001/console"
