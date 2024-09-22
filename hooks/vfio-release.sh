#!/bin/bash

#############################################################################
##     ______  _                _  _______         _                 _     ##
##    (_____ \(_)              | |(_______)       | |               | |    ##
##     _____) )_  _   _  _____ | | _    _   _   _ | |__   _____   __| |    ##
##    |  ____/| |( \ / )| ___ || || |  | | | | | ||  _ \ | ___ | / _  |    ##
##    | |     | | ) X ( | ____|| || |__| | | |_| || |_) )| ____|( (_| |    ##
##    |_|     |_|(_/ \_)|_____) \_)\______)|____/ |____/ |_____) \____|    ##
##                                                                         ##
#############################################################################
###################### Credits ###################### ### Update PCI ID'S ###
## Lily (PixelQubed) for editing the scripts       ## ##                   ##
## RisingPrisum for providing the original scripts ## ##   update-pciids   ##
## Void for testing and helping out in general     ## ##                   ##
## .Chris. for testing and helping out in general  ## ## Run this command  ##
## WORMS for helping out with testing              ## ## if you dont have  ##
## BrainStone for general script cleanup           ## ## names in you're   ##
##################################################### ## lspci feedback    ##
## The VFIO community for using the scripts and    ## ## in your terminal  ##
## testing them for us!                            ## ##                   ##
##################################################### #######################

################################# Variables #################################

## Adds current time to var for use in echo for a cleaner log and script ##
DATE_FORMAT="%Y-%m-%d %H:%M:%S.%3N"

################################# Functions #################################

# Log message with timestamp
function log() {
  echo "$(date +"$DATE_FORMAT") : $*"
}

################################## Script ###################################

log "################################ Beginning of Release! ################################"
#sleep 10
############################
## Unload VFIO-PCI driver ##
############################
log "Unloading VFIO drivers"
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio
log "VFIO drivers unloaded"
if grep -q "nvidia" "/tmp/vfio-gpu-type"; then

  ## Retain udev rules ##
  log "Retaining NVIDIA Udev Rules"
  mv /usr/lib/udev/rules.d/bak-71-nvidia.rules-bak /usr/lib/udev/rules.d/71-nvidia.rules
  log "Restarting udev"
  systemctl restart udev
  log "Restarted udev"
  
  ## Load NVIDIA drivers. This will automatically start nvidia-persistenced.service.##
  log "Loading NVIDIA GPU Drivers"
  modprobe i2c_nvidia_gpu
  modprobe nvidia
  modprobe nvidia_modeset
  modprobe nvidia_drm
  modprobe nvidia_uvm
  log "NVIDIA GPU Drivers Loaded"
  #sleep 1
  #log "Show nvidia-persistenced.service Status"
  #systemctl status nvidia-persistenced
  #log "nvidia-persistenced.service Status Shown"
fi

if grep -q "amd" "/tmp/vfio-gpu-type"; then
  ## Load AMD drivers ##
  log "Loading AMD GPU Drivers"
  modprobe drm
  modprobe amdgpu
  modprobe radeon
  modprobe drm_kms_helper
  log "AMD GPU Drivers Loaded"
fi

#############################
## Restart Display Manager ##
#############################
while read -r DISPMGR; do
  if [[ -d /run/systemd/system ]]; then
    ## Make sure the variable got collected ##
    log "Var has been collected from file: $DISPMGR"
    
    log "Starting $DISPMGR.service"
    systemctl start "$DISPMGR.service"
    log "$DISPMGR.service Started"
  fi
done </tmp/vfio-store-display-manager

log "################################ End of Release! ################################"
