# Stage 1: Build the Maven project
FROM maven:3.8.5-openjdk-11 AS build
WORKDIR /build

# Copy the entire hmdm-server source code
COPY hmdm-server/ /build/

# Build the WAR file. Since we created build.properties, it will build successfully
RUN mvn clean package -DskipTests

# Stage 2: Final image based on tomcat
FROM tomcat:9-jdk11

ARG SQL_PASS=Q1XIpOTkWU9Z

ENV HMDM_SQL_HOST=localhost \
    HMDM_SQL_PORT=5432 \
    HMDM_SQL_BASE=hmdm \
    HMDM_SQL_USER=hmdm \
    HMDM_SQL_PASS=$SQL_PASS \
    HMDM_LANGUAGE='en' \
    HMDM_TOMTCAT_PORT="8080" \ 
    HMDM_TOMTCAT_HOST="localhost" \
    HMDM_TOMTCAT_PORTOCOL=http \
    HMDM_TOMTCAT_DOMAIN="0.0.0.0" 

RUN mkdir -p /home/hmdmr && cd /home/hmdmr
WORKDIR /home/hmdmr

RUN apt-get update -y
RUN apt-get install android-tools-adb android-tools-fastboot postgresql -y
RUN apt install aapt wget unzip sudo -y
RUN wget https://h-mdm.com/files/hmdm-5.25-install-ubuntu.zip
RUN unzip hmdm-5.25-install-ubuntu.zip

# Copy our custom built war file into the installer's server/target directory
COPY --from=build /build/server/target/launcher.war /home/hmdmr/hmdm-install/server/target/launcher.war

COPY etc/docker-entrypoint.sh /hmdm-entrypoint.sh
COPY etc/hmdm_install.sh /home/hmdmr/hmdm-install/
RUN chmod 775 /hmdm-entrypoint.sh
RUN chmod 775 /home/hmdmr/hmdm-install/hmdm_install.sh

RUN service postgresql start && \
    sudo -u postgres psql -c "CREATE USER hmdm WITH PASSWORD '$HMDM_SQL_PASS';" && \
    sudo -u postgres psql -c "CREATE DATABASE hmdm WITH OWNER=hmdm;"

CMD ["/hmdm-entrypoint.sh"]
