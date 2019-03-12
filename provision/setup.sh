#!/usr/bin/env bash

# /*
# * setup.sh
# * sieferos: 24/10/2017
# */

source "/var/tmp/vagrant/provision/include.sh"

LOG_FILE="${LOG_DIR}/setup.log"

printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "$0" | tee -a "${LOG_FILE}" ; ii=$((++ii))

### HOSTNAME
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "HOSTNAME" | tee -a "${LOG_FILE}" ; ii=$((++ii))
sudo sed -i.bak '/xenial/d' /etc/hosts 2>&1 | tee -a "${LOG_FILE}"
echo "127.0.0.1 ${BOX}" | sudo tee -a /etc/hosts 2>&1 | tee -a "${LOG_FILE}"
sudo hostnamectl set-hostname "${BOX}" 2>&1 | tee -a "${LOG_FILE}"
hostname 2>&1 | tee -a "${LOG_FILE}"

### TIMEZONE (EU)
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "TIMEZONE (EU)" | tee -a "${LOG_FILE}" ; ii=$((++ii))
sudo timedatectl set-timezone Europe/Madrid 2>&1 | tee -a "${LOG_FILE}"

### VIRTUAL BOX GUEST TOOLS
# printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "VIRTUAL BOX GUEST TOOLS" | tee -a "${LOG_FILE}" ; ii=$((++ii))
# sudo apt-get -y install virtualbox-guest-dkms 2>&1 | tee -a "${LOG_FILE}"

### DISABLE RELEASE UPGRADE
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "DISABLE RELEASE UPGRADE" | tee -a "${LOG_FILE}" ; ii=$((++ii))
for F in $(find /etc/update-motd.d/*-release-upgrade 2>/dev/null) ; do sudo chmod -x "${F}" 2>&1 | tee -a "${LOG_FILE}" ; done

### DISABLE SSH LOGIN BANNER
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "DISABLE SSH LOGIN BANNER" | tee -a "${LOG_FILE}" ; ii=$((++ii))
! ( egrep -qi "^\BANNER[[:space:]]" /etc/ssh/sshd_config ) && printf "\nBanner /dev/null\n" | sudo tee -a /etc/ssh/sshd_config 2>&1 | tee -a "${LOG_FILE}"
touch ~/.hushlogin 2>&1 | tee -a "${LOG_FILE}"

### DISABLE GRUB AT STARTUP
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "DISABLE GRUB AT STARTUP" | tee -a "${LOG_FILE}" ; ii=$((++ii))
sudo sed -i '/GRUB_DISABLE_OS_PROBER=/ s/false/true/' /etc/default/grub 2>&1 | tee -a "${LOG_FILE}"
sudo sed -i '/GRUB_HIDDEN_TIMEOUT_QUIET=/ s/true/false/' /etc/default/grub 2>&1 | tee -a "${LOG_FILE}"
sudo sed -i '/GRUB_TIMEOUT=/ s/10/0/' /etc/default/grub 2>&1 | tee -a "${LOG_FILE}"
sudo sed -i 's/#GRUB_DISABLE_RECOVERY/GRUB_DISABLE_RECOVERY/' /etc/default/grub 2>&1 | tee -a "${LOG_FILE}"
sudo chmod a-x /etc/grub.d/30_os-prober 2>&1 | tee -a "${LOG_FILE}"
sudo update-grub 2>&1 | tee -a "${LOG_FILE}"

### LOGICAL VOLUME MANAGER
printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "LOGICAL VOLUME MANAGER (2)" | tee -a "${LOG_FILE}" ; ii=$((++ii))
sudo apt-get -y install lvm2 2>&1 | tee -a "${LOG_FILE}"

### VAGRANT PLUGIN: vagrant-reload
### printf "\n[ %s ] %s@%s (#%02d) ( %s )\n" "$(date)" ${USER} "${BOX}" ${ii} "vagrant-reload" | tee -a "${LOG_FILE}" ; ii=$((++ii))
### sudo shutdown -h now 2>&1 | tee -a "${LOG_FILE}"
