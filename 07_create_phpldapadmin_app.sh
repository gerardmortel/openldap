#!/bin/bash

echo ""
echo "================================================================================"
echo "=== In 07_create_phpldapadmin_app.sh ==========================================="
echo "================================================================================"
echo ""

echo "#### Sleep 30 seconds to allow for image push to settle down.  Without this, app creation fails"
sleep 30

# Create the phpldapadmin app
echo "" &&  echo "#### Create the phpldapadmin app" && echo ""
oc new-app --name phpldapadmin --as-deployment-config -e PHPLDAPADMIN_LDAP_HOSTS=openldap ${PHPLDAPADMINIMAGESTREAM}

# Patch the app with a Recreate strategy to stop the constant pod killing
echo "" &&  echo "#### Patch the app with a Recreate strategy to stop the constant pod killing" && echo ""
#oc patch dc/phpldapadmin -p '{"spec":{"strategy":{"type":"Recreate"},"template":{"spec":{"serviceAccountName":"${SERVICEACCOUNTNAME}"}}}}'
cat << EOF > new_dc_phpldapadmin_patch.yaml
spec:
  strategy:
    type: Recreate
  template:
    spec:
      serviceAccountName: ${SERVICEACCOUNTNAME}
EOF
oc patch dc/phpldapadmin --patch-file='new_dc_phpldapadmin_patch.yaml' --type='merge'

# Expose the phpldapadmin app
echo "" &&  echo "#### Expose the phpldapadmin app" && echo ""
oc expose service/phpldapadmin