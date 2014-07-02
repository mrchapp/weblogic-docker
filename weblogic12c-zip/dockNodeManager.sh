#!/bin/sh
TIMESTAMP=`date +%s`
CONTAINER_NAME=nodemanager${TIMESTAMP}
CID_FILE=${CONTAINER_NAME}.cid

docker run -d --name ${CONTAINER_NAME} -e DOCKER_CONTAINER_NAME=${CONTAINER_NAME} --cidfile $CID_FILE --link wls12cdev:wls12cdev oracle/weblogic12c_dev /u01/oracle/createMachine.sh

NMIP=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' `cat $CID_FILE`)

echo "New NodeManager started on IP Address: ${NMIP}. Hopefully this Machine was automatically added to 'base_domain'. If not, go to Admin Console and try to add it manually with this IP address."
