#!/bin/bash
# 
#script to run bedrock connect stuff
#


echo "About to set up Bedrock Connect"
echo "Check if the volume is available"

echo "contents of /brc are"

ls -l /brc 


 
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

currentMD5=$(md5sum /scripts/BedrockConnect-1.0-SNAPSHOT.jar | cut -d' ' -f1)
echo "MD5 of current Jar File = $currentMD5"

#echo "$currentMD5"

echo "downloading latest JAR file"
curl --no-progress-meter -k -L -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" -o /scripts/latestJarFile.jar "https://github.com/Pugmatt/BedrockConnect/releases/latest/download/BedrockConnect-1.0-SNAPSHOT.jar"
if [ -e /scripts/latestJarFile.jar ]; then
	latestMD5=$(md5sum /scripts/latestJarFile.jar | cut -d' ' -f1)
	echo "md5 for latest JAR $latestMD5 "
	#echo "$latestMD5"
fi

echo "contents of /scripts are"
ls -l /scripts
 

if [ -e /scripts/BedrockConnect-1.0-SNAPSHOT.jar ] && [ "$latestMD5" = "$currentMD5" ]; then
    echo "JarFile is up to date"
else
	if [ -e /scripts/latestJarFile.jar ]; then
		echo "updating JAR file"
		mv /scripts/latestJarFile.jar /scripts/BedrockConnect-1.0-SNAPSHOT.jar
		cp /scripts/BedrockConnect-1.0-SNAPSHOT.jar /brc/BedrockConnect-1.0-SNAPSHOT.jar
	fi
fi 

echo "putting jar file in place"
if [ -e "/scripts/BedrockConnect-1.0-SNAPSHOT.jar" ]; then
	echo "copying jar file from download to volume"
    cp /scripts/BedrockConnect-1.0-SNAPSHOT.jar /brc/BedrockConnect-1.0-SNAPSHOT.jar
fi



# mysql is the service (use instead of host when between docker containers)
# Start server
echo "Starting bedrock connect server..."
#CMD ["java", "-Xms256M", "-Xmx256M", "-jar", "BedrockConnect-1.0-SNAPSHOT.jar", "nodb=true"]

exec java -Xms256M -Xmx256M -jar /brc/BedrockConnect-1.0-SNAPSHOT.jar nodb=${NODB} mysql_user=${MYSQL_USER} mysql_pass=${MYSQL_PASSWORD} mysql_host=${MYSQL_HOST} custom_servers=/brc/custom_servers.json

# Exit container
exit 0
