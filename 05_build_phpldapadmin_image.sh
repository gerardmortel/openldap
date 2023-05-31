#!/bin/bash

# Put the following into a Dockerifle
cat << EOF > new_Dockerfile_phpldapadmin
#Pull the latest base image from Dockerhub
FROM osixia/phpldapadmin

# Set the environment variables
ENV PHPLDAPADMIN_HTTPS="false"
 
EXPOSE 8090
EOF

# Build the phpldapadmin image
podman build -t docker.io/${DOCKERUSERNAME}/phpldapadmin_new:1.0 -f new_Dockerfile_phpldapadmin

# Login to docker
podman login -u ${DOCKERUSERNAME} -p ${DOCKERPASSWORD}

# Push to docker hub
podman push docker.io/${DOCKERUSERNAME}/phpldapadmin_new:1.0
