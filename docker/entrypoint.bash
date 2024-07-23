#!/bin/bash

set -e
set -x

INITIALIZED_FILE="/var/initialized"

setup_user() {
   env_vars=("LOCAL_USER" "LOCAL_UID" "LOCAL_UID" "LOCAL_GID")
   for var in "${env_vars[@]}"; do
     if [ -z "${!var}" ]; then
       echo "Error: $var is not defined."
       exit 1
     fi
   done
   
   groupadd -g "${LOCAL_GID}" "${LOCAL_USER}"
   useradd -u "${LOCAL_UID}" -g "${LOCAL_GID}" "${LOCAL_USER}"
   echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
   echo "${LOCAL_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
   usermod -a -G mock "${LOCAL_USER}"
}

setup_dirs() {
   mkdir -p /dest/RPMS
   mkdir /var/eext
   chown -R "${LOCAL_USER}":"${LOCAL_USER}" /dest /var/eext /var/lib/rpm /usr/share/eext
}

install_packages() {
   PKGS=(
      "emacs"
      "vim-enhanced"
   )
   dnf install -y "${PKGS[@]}"
}


if [[ ! -f "${INITIALIZED_FILE}" ]]; then
   setup_user
   setup_dirs
   install_packages
   touch "${INITIALIZED_FILE}"
fi

# Block indefinetely
# We use docker exec for further usage
while true; do sleep 10000; done

