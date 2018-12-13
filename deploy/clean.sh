#!/usr/bin/env bash
# Bash deploy script. Copyright (c) 2017 Romain Bruckert
# https://kvz.io/blog/2013/11/21/bash-best-practices/

###
# Check input arguments
##
if [ -z "${ENV}" ]; then
   echo -e "${red}✗ No argument supplied for environment (-e|--env|--environment)${nc}"
   exit 1
fi
if [ -z "${VERSION}" ]; then
    echo -e "${red}✗ No argument supplied for version (-v|--version)${nc}"
    exit 1
fi

echo -e "${green}★  Starting cleaning util${nc}"

###
# Check input arguments
##
if [ -z "${ENV}" ]; then
   echo -e "${red}✗ No argument supplied for environment (-e|--env|--environment)${nc}"
   exit 1
fi
if [ -z "${VERSION}" ]; then
    echo -e "${red}✗ No argument supplied for version (-v|--version)${nc}"
    exit 1
fi
if [ -z "${DEBUG}" ]; then
    DEBUG='--no-debug'
fi

REMOTE_VERSION_NUMBER=$(ssh ${CNF_USER}@${CNF_HOST} "cat ${CNF_BASE_REMOTE_DIR}/current/.version.${ENV}")

# Makee sur deploying a same version is allowed (ask the developer)
if [ ${VERSION} = ${REMOTE_VERSION_NUMBER} ]; then
    echo -e "${red}✗  Cant remove a currently live version${nc}"
    exit 0
else

    ###
    # First list version directories to be sure...
    ##
    echo -e "${green}★  Listing remote directories for your information${nc}"
    ssh -t ${CNF_USER}@${CNF_HOST} "cd ${CNF_BASE_REMOTE_DIR} && tree -L 1"

    ###
    # Set remote dir to delete
    ###
    REMOTE_VERSION_DIR_TO_REMOVE=${CNF_BASE_REMOTE_DIR}/version-${VERSION}

    read -r -p "   ♘  Are you sure you want to remove ${REMOTE_VERSION_DIR_TO_REMOVE}? [y/N] " response
    if [[ ${response} =~ ^([yY][eE][sS]|[yY])$ ]]
    then

        echo -e "${blue}★  Preparing to remove${nc}"
        echo -e "   ✓ Removing directory ${REMOTE_VERSION_DIR_TO_REMOVE}"
        ssh -t ${CNF_USER}@${CNF_HOST} "rm -rf ${REMOTE_VERSION_DIR_TO_REMOVE}" > /dev/null 2>&1
        echo -e "   ✓ Directory removed"

        ssh -t ${CNF_USER}@${CNF_HOST} "cd ${CNF_BASE_REMOTE_DIR} && tree -L 1"

        exit 0

    else
        echo -e "${red}✗  Canceled${nc}"
        exit 0
    fi

fi
