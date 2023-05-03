#!/bin/bash
# 
#script to run bedrock connect stuff
#


echo "About to set up Bedrock Connect"
echo "Check if the volume is available"

if [ ! -d '/brc' ]; then
    echo "ERROR:  A named volume was not specified for the bedrockConnect storage.  Please create one with: docker volume create yourvolumename"
    echo "Please pass the new volume to docker like this:  docker run -it -v yourvolumename:/brc"
    exit 1
fi

echo "looking for custom server list"
if [ -e "/scripts/custom_servers.json" ]; then
	echo "copying custom servers to volume"
    cp /scripts/custom_servers.json /brc/custom_servers.json
fi
#
# Here would be a place to check if the new version is available instead of just taking it in the docker file
#
echo "checking if jar file in place"
if [ ! -e "/brc/BedrockConnect-1.0-SNAPSHOT.jar" ]; then
	echo "copying jar file to volume"
    cp /scripts/BedrockConnect-1.0-SNAPSHOT.jar /brc/BedrockConnect-1.0-SNAPSHOT.jar
fi

# mysql is the service (use instead of host when between docker containers)
# Start server
echo "Starting bedrock connect server..."
#CMD ["java", "-Xms256M", "-Xmx256M", "-jar", "BedrockConnect-1.0-SNAPSHOT.jar", "nodb=true"]

exec java -Xms256M -Xmx256M -jar /brc/BedrockConnect-1.0-SNAPSHOT.jar nodb=${NODB} mysql_user=${MYSQL_USER} mysql_pass=${MYSQL_PASSWORD} mysql_host=mysql custom_servers=/brc/custom_servers.json

# Exit container
exit 0