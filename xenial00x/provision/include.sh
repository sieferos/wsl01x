#!/usr/bin/env bash

BOX="CUSTOM_BOX_NAME"
LOG_DIR=$(printf "%s/%s/%s" "/var/tmp/vagrant/provision" "${BOX}" "$(date "+%Y%m%d")")
mkdir -p "${LOG_DIR}"/

ii=0
