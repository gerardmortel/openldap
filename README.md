# Install OpenLDAP on OpenShift
# https://github.ibm.com/gmortel/openldap

# Resources
Using the OCP registry
https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/22.0.2?topic=SSYHZ8_22.0.2/com.ibm.dba.install/op_topics/tsk_images_enterp.htm

# Purpose
The purpose of this repo is to install openldap on OpenShift

# Prerequisites
1. OpenShift cluster on Fyre
2. NFS Storage configured https://github.com/gerardmortel/nfs-storage-for-fyre
3. Docker hub password

# Instructions
1. ssh into the infrastructure node as root (e.g. ssh root@api.slavers.cp.fyre.ibm.com)
2. yum install -y git unzip podman
3. cd
4. rm -f main.zip
4. wget https://github.com/gerardmortel/openldap/archive/refs/heads/main.zip
5. unzip main.zip
6. rm -f main.zip
7. cd openldap-main
8. Put your values for DOCKERUSERNAME DOCKERPASSWORD LDAPADMINPASSWORD inside file 02_setup_env.sh
9. ./01_driver.sh
