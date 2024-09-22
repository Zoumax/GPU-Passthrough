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

log "################################ Beginning of Stopped! ################################"

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

log "################################ End of Stopped! ################################"
