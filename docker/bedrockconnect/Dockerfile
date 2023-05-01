FROM openjdk:11
RUN mkdir -p /scripts
ADD https://github.com/Pugmatt/BedrockConnect/releases/latest/download/BedrockConnect-1.0-SNAPSHOT.jar /scripts/
COPY *.sh /scripts/
COPY *.json /scripts/
WORKDIR /scripts
EXPOSE 19132/udp
#CMD ["/bin/bash", "-c", "echo Dockerfile for bedrock;pwd;echo scripts;ls /scripts;echo brc;ls /brc"]
ENTRYPOINT ["/bin/bash", "/scripts/start.sh"]
#CMD ["java", "-Xms256M", "-Xmx256M", "-jar", "BedrockConnect-1.0-SNAPSHOT.jar", "nodb=true"]
