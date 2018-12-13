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

echo -e "${green}★  Starting rollback to ${VERSION}${nc}"
echo ""

read -r -p "   ♘  Are you sure you want to rollback in [${ENV}] to [v${VERSION}]? [y/N] " response
if [[ ${response} =~ ^([yY][eE][sS]|[yY])$ ]]
then

    echo ""

    if ssh -t -o LogLevel=QUIET ${CNF_USER}@${CNF_HOST} "[ -d /${REMOTE_DIR} ]"
    then
        ###
        # Create symlinks in the new release directory
        ###
        echo -e "${blue}★  Rolled back with symlinks${nc}"
        echo -e "   ✓ Removed symlink to ${CNF_BASE_REMOTE_DIR}/current"
        echo -e "   ✓ Symlinked ${REMOTE_DIR} --> ${CNF_BASE_REMOTE_DIR}/current"
        ssh -t ${CNF_USER}@${CNF_HOST} "rm -f ${CNF_BASE_REMOTE_DIR}/current" > /dev/null 2>&1
        ssh -t ${CNF_USER}@${CNF_HOST} "ln -sf ${REMOTE_DIR} ${CNF_BASE_REMOTE_DIR}/current" > /dev/null 2>&1

    else

        echo -e "${red}✗  Version directory '${REMOTE_DIR}' does not exist${nc}"
        exit 1

    fi

else
    echo -e "${red}✗  Canceled${nc}"
    exit 0
fi
