#!/bin/bash

# For first time run, run steps 2 thru 7
. ./02_setup_env.sh
./03_access_ocp_registry.sh
./04_build_openldap_image.sh
./05_create_openldap_app.sh
./06_build_phpldapadmin_image.sh
./07_create_phpldapadmin_app.sh

# Subsequent runs do not need to rebuild images.  Comment out build steps 4 and 6, run all the rest
# . ./02_setup_env.sh
# ./03_access_ocp_registry.sh
# #./04_build_openldap_image.sh
# ./05_create_openldap_app.sh
# #./06_build_phpldapadmin_image.sh
# ./07_create_phpldapadmin_app.sh