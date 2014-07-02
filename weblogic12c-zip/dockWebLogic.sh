#!/bin/sh
if [ -e "weblogic.cid" ]
then
  docker kill `cat weblogic.cid` > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    rm weblogic.cid
  else
    docker rm `cat weblogic.cid` && rm weblogic.cid
  fi
fi


docker run -d -p 7001:7001 -cidfile weblogic.cid --name wls12cdev oracle/weblogic12c_dev /u01/oracle/wls12130/user_projects/domains/base_domain/startWebLogic.sh > /dev/null 2>&1

CIPA=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' wls12cdev)

echo "Open WebLogic Console at http://${CIPA}:7001/console"
