#!/usr/bin/env bash
# Bash deploy script. Copyright (c) 2017 Romain Bruckert
# https://kvz.io/blog/2013/11/21/bash-best-practices/

SF_DIR=$1
SF_ENV=$2
SF_DBG=$3
FULL_INSTALL=$4
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
# Some modules need to be reinstalled
###
if [ ${FULL_INSTALL} == 1 ]; then
    echo "   ✓ Installing NPM modules for inTouch (because this a full deploy)"
    cd ${SF_DIR}/app/nodejs/intouch
    npm install > /dev/null 2>&1
    echo "   ✓ Restarting a few NodeJs scripts for intouch"
    pm2 restart elastic > /dev/null 2>&1
    pm2 restart intouch > /dev/null 2>&1
    pm2 restart notify > /dev/null 2>&1
    pm2 restart remind > /dev/null 2>&1
    pm2 restart search > /dev/null 2>&1
    pm2 restart unread > /dev/null 2>&1
fi

# Goto to symfony folder
cd ${SF_DIR}

exit 0
