#!/usr/bin/env bash
# Bash deploy script. Copyright (c) 2017 Romain Bruckert
# https://kvz.io/blog/2013/11/21/bash-best-practices/

SF_DIR=$1
SF_ENV=$2
SF_DBG=$3
source ${SF_DIR}/deploy/import/utils.sh

bold=$(tput bold)
normal=$(tput sgr0)

###
# Check arguments
##
if [ -z "$1" ]; then
   echo -e "${red}  ✗ No 1st argument supplied {SF_DIR}.${nc}"
   exit 2
fi
if [ -z "$2" ]; then
   echo -e "${red}  ✗ No 2nd argument supplied {SF_ENV}.${nc}"
   exit 2
fi

# Goto to symfony folder
cd ${SF_DIR}

###
# Post deploy script for Symfony 2 installation
###
echo "   ✓ Deleting Symfony2 cache"
sudo rm -rf app/cache/* && rm -rf app/logs/*

echo "   ✓ Setting Symfony2 permissions"
HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)

sudo setfacl -dR -m u:www-data:rwX -m u:$(whoami):rwX app/cache app/logs
sudo setfacl -R -m u:www-data:rwX -m u:$(whoami):rwX app/cache app/logs

echo "   ✓ Executing doctrine migrations"
php app/console doctrine:migration:migrate --no-interaction > /dev/null 2>&1

echo "   ✓ Clearing Symfony2 cache"
php app/console cache:clear --env=${SF_ENV} ${SF_DBG} > /dev/null 2>&1

echo "   ✓ Warming up the cache"
php app/console cache:warmup --env=${SF_ENV} ${SF_DBG} > /dev/null 2>&1

echo "   ✓ Dumping Symfony2 assets"
php app/console assetic:dump --env=${SF_ENV} ${SF_DBG} > /dev/null 2>&1

# Doing this before assets or data symlinks script will produce following error
# [Twig_Error_Loader]
#   The "/home/srv/medical/version-2.1.11/app/../web/assets/apps" directory does not exist ("/home/srv/medical/versio
#   n-2.1.11/app/../web/assets/apps").

# if [ $VERSION == 0 ]; then
#     HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
#
#     sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX "$SF_DIR/app/cache" "$SF_DIR/app/logs"
#     sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX "$SF_DIR/app/cache" "$SF_DIR/app/logs"
#
#     sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX "$SF_DIR/app/data" "$SF_DIR/web/assets"
#     sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX "$SF_DIR/app/data" "$SF_DIR/web/assets"
#
#     sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX "$SF_DIR/app/Resources/translations"
#     sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX "$SF_DIR/app/Resources/translations"
# fi

exit 0
