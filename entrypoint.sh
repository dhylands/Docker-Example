#!/bin/bash
#
# This script is always run whenever the docker image is run, and any extra
# arguments passed on the docker command line are passed in.
#
# This script was inspired by https://github.com/sdt/docker-raspberry-pi-cross-compiler

if [ "${DEBUG}" != "" ]; then
    echo "=================================================="
    echo "USER_UID = ${USER_UID}"
    echo "USER_GID = ${USER_GID}"
    echo "USER_NAME = ${USER_NAME}"
    echo "USER_GROUP = ${USER_GROUP}"
    echo "USER_HOME = ${USER_HOME}"
    echo "USER_PWD = ${USER_PWD}"
    echo "=================================================="

    set -x
fi

if [[ -n "${USER_UID}" ]] && [[ -n "${USER_GID}" ]]; then
    # Give the user sudo access
    echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME}
    # Add a user and group so that the bash prompt looks reasonable
    groupadd -o -g "${USER_GID}" "${USER_GROUP}" 2> /dev/null
    useradd -o -m -d "${USER_HOME}" -g "${USER_GID}" -G dialout -u "${USER_UID}" "${USER_NAME}" 2> /dev/null
    cd "${USER_PWD}"
    if [ "${USER_DEBUG}" != "" ]; then
        echo "Running as ${USER_NAME}:${USER_GROUP} as ${USER_UID}:${USER_GID}"
    fi

    # Ensure the user's home directory is owned by the user
    chown "${USER_UID}":"${USER_GID}" "/home/${USER_NAME}"

    # Modify the sudoers file so they can run commands without requiring a password
    echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

    if [[ $# == 0 ]]; then
        # No arguments passed in. We'll act as if the user entered `bash`
        HOME="${USER_HOME}" exec chpst -u ":${USER_UID}:${USER_GID}" bash
    else
        HOME="${USER_HOME}" exec chpst -u ":${USER_UID}:${USER_GID}" "$@"
    fi
else
    if [ "${USER_DEBUG}" != "" ]; then
        echo "Running as root"
    fi
    if [[ $# == 0 ]]; then
        # No arguments passed in. We'll act as if the user entered `bash`
        exec bash
    else
        exec "$@"
    fi
fi
