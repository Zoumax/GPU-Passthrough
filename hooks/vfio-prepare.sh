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

## Sets dispmgr var as null ##
DISPMGR="null"

################################# Functions #################################

# Log message with timestamp
function log() {
  echo "$(date +"$DATE_FORMAT") : $*"
}

function stop_display_manager_if_running {
  if [[ -d /run/systemd/system ]]; then
    log "Distro is using Systemd"
    log "Display Manager = $DISPMGR"

    ## Stop display manager using systemd ##
    if systemctl is-active --quiet "$DISPMGR.service"; then
      echo "$DISPMGR" >/tmp/vfio-store-display-manager
      log "Stopping $DISPMGR.service"
      systemctl stop "$DISPMGR.service"
      log "Stopped $DISPMGR.service"
    fi
  else
    log "Distro is not using Systemd, can't stop display manager"
  fi
}

function detect_display_manager {
  if [[ -d /run/systemd/system ]]; then
    DISPMGR="$(grep 'ExecStart=' /etc/systemd/system/display-manager.service | awk -F'/' '{print $(NF-0)}')"
  fi
}

################################## Script ###################################

log "################################ Beginning of Prepare! ################################"

####################################################################################################################
## Checks to see if your running KDE. If not it will run the function to collect your display manager.            ##
## Have to specify the display manager because kde is weird and uses display-manager even though it returns sddm. ##
####################################################################################################################
if pgrep -l "plasma" | grep -q "plasmashell"; then
  log "Display Manager is KDE, running KDE clause!"
  DISPMGR="display-manager"
else
  log "Display Manager is not KDE!"
  detect_display_manager
fi

stop_display_manager_if_running

#########################
## Disable GPU drivers ##
#########################
: >/tmp/vfio-gpu-type

if lspci -nn | grep -e VGA | grep -s NVIDIA; then
  log "System has an NVIDIA GPU"
  echo "nvidia" >>/tmp/vfio-gpu-type
  
  ## Unload NVIDIA GPU drivers. This will automatically stop nvidia-persistenced.service. ##
  log "Unloading NVIDIA GPU drivers"
  modprobe -r nvidia_uvm
  modprobe -r nvidia_drm
  modprobe -r nvidia_modeset
  modprobe -r nvidia
  modprobe -r i2c_nvidia_gpu
  log "NVIDIA GPU Drivers Unloaded"
  
  ## Clear udev rules ##
  log "Clearing NVIDIA Udev Rules"
  mv /usr/lib/udev/rules.d/71-nvidia.rules /usr/lib/udev/rules.d/bak-71-nvidia.rules-bak
  log "Restarting udev"
  systemctl restart udev
  log "Restarted udev"
  sleep 1
fi

if lspci -nn | grep -e VGA | grep -s AMD; then
  log "System has an AMD GPU"
  echo "amd" >/tmp/vfio-gpu-type

  ## Unload AMD GPU drivers ##
  log "Unloading AMD GPU drivers"
  modprobe -r drm_kms_helper
  modprobe -r amdgpu
  modprobe -r radeon
  modprobe -r drm
  log "AMD GPU Drivers Unloaded"
fi

##########################
## Load VFIO-PCI driver ##
##########################
log "Loading VFIO drivers"
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
log "VFIO drivers Loaded"
log "################################ End of Prepare! ################################"
