#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 05_create_openldap_app.sh ==============================================="
echo "================================================================================"
echo ""

# Create the project where openldap will live if it does not already exist
#oc new-project ${CP4BANAMESPACE}
oc new-project ${NS}

# Switch to project cp4ba
oc project ${NS}

# Create a service account called openldap
oc create serviceaccount ${SERVICEACCOUNTNAME}

# Add anyuid security context contstraint
#oc adm policy add-scc-to-user anyuid system:serviceaccount:${CP4BANAMESPACE}:openldap
oc adm policy add-scc-to-user anyuid system:serviceaccount:${NS}:${SERVICEACCOUNTNAME}

# Create the openldap app
# oc new-app --name openldap --as-deployment-config -e LDAP_ADMIN_PASSWORD=${LDAPADMINPASSWORD} ${DOCKERHUBIMAGE}
oc new-app --name openldap --as-deployment-config -e LDAP_ADMIN_PASSWORD=${LDAPADMINPASSWORD} ${OPENLDAPIMAGESTREAM}

# Patch the app with a Recreate strategy to stop the constant pod killing
#oc patch dc/openldap -p '{"spec":{"strategy":{"type":"Recreate"},"template":{"spec":{"serviceAccountName":"openldap"}}}}'
cat << EOF > new_dc_openldap_patch.yaml
spec:
  strategy:
    type: Recreate
  template:
    spec:
      serviceAccountName: ${SERVICEACCOUNTNAME}
EOF
oc patch dc/openldap --patch-file='new_dc_openldap_patch.yaml' --type='merge'

# Expose the app
oc expose dc/openldap --type=LoadBalancer --name=ingress-openldap

# Run next 2 commands at the same time or you'll get an error in the log tha the other directory is not empty
# Create storage for the openldap app
oc set volume dc/openldap --add --name=ldap-data --mount-path=/var/lib/ldap -t pvc --claim-name=ldap-data --claim-size=1G --claim-class=${STORAGECLASSNAME}
oc set volume dc/openldap --add --name=ldap-config --mount-path=/etc/ldap/slapd.d -t pvc --claim-name=ldap-config --claim-size=1G --claim-class=${STORAGECLASSNAME}