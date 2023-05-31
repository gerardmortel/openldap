#!/bin/bash

export NS="cp4ba"
export SERVICEACCOUNTNAME="openldap"

# Replace "gmortel" with your docker repo user name
export DOCKERUSERNAME=""
export DOCKERPASSWORD=""
export DOCKERHUBIMAGE="docker.io/${DOCKERUSERNAME}/openldap_bootstrap:1.0"
export LDAPADMINPASSWORD="thesummerofBpmr0cks!"
export STORAGECLASSNAME="nfs-managed-storage"
