#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 06_build_phpldapadmin_image.sh =========================================="
echo "================================================================================"
echo ""

# Put the following into a Dockerifle
cat << EOF > new_Dockerfile_phpldapadmin
#Pull the latest base image from Dockerhub
FROM docker.io/osixia/phpldapadmin:latest

# Set the environment variables
ENV PHPLDAPADMIN_HTTPS="false"
 
EXPOSE 8090
EOF

# Build the phpldapadmin image
podman build -t ${PHPLDAPADMINIMAGE} -f new_Dockerfile_phpldapadmin

# Login to the OpenShift cluster registry
podman login $(oc registry info --public) -u kubeadmin -p $(oc whoami -t) --tls-verify=false

# Push to OpenShift cluster registry
podman push ${PHPLDAPADMINIMAGE} --tls-verify=false