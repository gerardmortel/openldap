#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 06_build_phpldapadmin_image.sh =========================================="
echo "================================================================================"
echo ""

echo "#### Create the project where openldap will live if it does not already exist"
oc new-project ${NS}

echo "#### Switch to project ${NS}"
oc project ${NS}

echo "#### Login to Docker"
podman login docker.io -u $DOCKERUSERNAME -p $DOCKERPASSWORD

echo "#### Create phpldapadmin Dockerfile"
cat << EOF > new_Dockerfile_phpldapadmin
# Pull the latest base image from Dockerhub
FROM docker.io/osixia/phpldapadmin:latest

# Set the environment variables
ENV PHPLDAPADMIN_HTTPS="false"
 
EXPOSE 8090
EOF

echo "#### Build the phpldapadmin image"
podman build -t ${PHPLDAPADMINIMAGE} -f new_Dockerfile_phpldapadmin

echo "#### Check if we can login to the OpenShift cluster registry"
while [ true ]
do
    podman login $(oc registry info --public) -u kubeadmin -p $(oc whoami -t) --tls-verify=false
    if [ $? -eq 0 ]; then
        echo "#### Successfully logged in to OpenShift cluster registry"
        break
    else
        echo "#### Unable to login to OpenShift cluster registry"
        echo "#### Sleeping for 10 seconds"
        sleep 10
    fi
done

echo "#### Push ${PHPLDAPADMINIMAGE} image to OpenShift cluster registry"
while [ true ]
do
    oc login -u kubeadmin -p $KUBEADMINPASSWORD
    podman push ${PHPLDAPADMINIMAGE} --tls-verify=false
    if [ $? -eq 0 ]; then
        echo "#### Successfully pushed ${PHPLDAPADMINIMAGE} image to OpenShift cluster registry"
        break
    else
        echo "#### Unable to push ${PHPLDAPADMINIMAGE} image to OpenShift cluster registry"
        echo "#### Sleeping for 10 seconds"
        sleep 10
    fi
done