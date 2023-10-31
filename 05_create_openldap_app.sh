#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 05_create_openldap_app.sh ==============================================="
echo "================================================================================"
echo ""

echo "#### Create the project where openldap will live if it does not already exist"
oc new-project ${NS}

echo "#### Switch to project cp4ba"
oc project ${NS}

echo "#### Create a service account called: ${SERVICEACCOUNTNAME}"
oc create serviceaccount ${SERVICEACCOUNTNAME}

echo "#### Add anyuid security context contstraint to serviceaccount ${SERVICEACCOUNTNAME}"
oc adm policy add-scc-to-user anyuid system:serviceaccount:${NS}:${SERVICEACCOUNTNAME}

echo "#### Create the openldap app"
oc new-app --name openldap --as-deployment-config -e LDAP_ADMIN_PASSWORD=${LDAPADMINPASSWORD} ${OPENLDAPIMAGESTREAM}

# Run next 2 commands at the same time or you'll get an error in the log tha the other directory is not empty
echo "#### Create storage for the openldap app"
oc set volume dc/openldap --add --name=ldap-data --mount-path=/var/lib/ldap -t pvc --claim-name=ldap-data --claim-size=1G --claim-class=${STORAGECLASSNAME}
oc set volume dc/openldap --add --name=ldap-config --mount-path=/etc/ldap/slapd.d -t pvc --claim-name=ldap-config --claim-size=1G --claim-class=${STORAGECLASSNAME}

echo "#### Patch the app with a Recreate strategy to stop the constant pod killing"
cat << EOF > new_dc_openldap_patch.yaml
spec:
  strategy:
    type: Recreate
  template:
    spec:
      serviceAccountName: ${SERVICEACCOUNTNAME}
EOF
oc patch dc/openldap --patch-file='new_dc_openldap_patch.yaml' --type='merge'

echo "#### Expose the openldap app"
oc expose dc/openldap --type=LoadBalancer --name=ingress-openldap