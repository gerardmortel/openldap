# Install OpenLDAP on OpenShift
# https://github.ibm.com/gmortel/openldap

# Resources
Using the OCP registry
https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/22.0.2?topic=SSYHZ8_22.0.2/com.ibm.dba.install/op_topics/tsk_images_enterp.htm

cloudctl case and corresponding ibm-pak commands
https://www.ibm.com/docs/en/cpfs?topic=plugin-cloudctl-case-corresponding-pak-commands

# Purpose
The purpose of this repo is to install openldap on OpenShift

# Prerequisites
1. OpenShift cluster on Fyre
2. NFS Storage configured https://github.com/gerardmortel/nfs-storage-for-fyre

# Instructions
1. ssh into the infrastructure node as root (e.g. ssh root@api.slavers.cp.fyre.ibm.com)
2. yum install -y git unzip podman
3. cd
4. rm -f main.zip
5. rm -rf openldap-main
6. wget https://github.com/gerardmortel/openldap/archive/refs/heads/main.zip
7. unzip main.zip
8. rm -f main.zip
9. cd openldap-main
10. STOP!! Put your values for LDAPADMINPASSWORD, KUBEADMINPASSWORD, DOCKERUSERNAME, DOCKERPASSWORD inside file 02_setup_env.sh
11. ./01_driver.sh
12. Login with cn=admin,dc=your,dc=company,dc=com and the password you set in step 10
