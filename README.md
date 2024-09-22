# GPU Passthrough Scripts

Scripts for passing a GPU from a Linux host to a Windows VM and back.

## Note: 
  Not for Single GPU!
  Not for Single GPU!
  Not for Single GPU!

## Thanks to:
  https://gitlab.com/risingprismtv/single-gpu-passthrough
  https://gitlab.com/BrainStone/single-gpu-passthrough

## Example Log
```
2024-09-22 22:04:17.976 : ################################ Beginning of Prepare! ################################
2024-09-22 22:04:17.987 : Display Manager is not KDE!
2024-09-22 22:04:17.989 : Distro is using Systemd
2024-09-22 22:04:17.989 : Display Manager = gdm3
2024-09-22 22:04:17.992 : Stopping gdm3.service
2024-09-22 22:04:18.358 : Stopped gdm3.service
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GA104 [GeForce RTX 3060 Ti] [10de:2486] (rev a1)
2024-09-22 22:04:18.365 : System has an NVIDIA GPU
2024-09-22 22:04:18.366 : Unloading NVIDIA GPU drivers
2024-09-22 22:04:18.637 : NVIDIA GPU Drivers Unloaded
2024-09-22 22:04:18.638 : Clearing NVIDIA Udev Rules
2024-09-22 22:04:18.639 : Restarting udev
2024-09-22 22:04:18.691 : Restarted udev
2024-09-22 22:04:19.700 : Loading VFIO drivers
2024-09-22 22:04:19.710 : VFIO drivers Loaded
2024-09-22 22:04:19.710 : ################################ End of Prepare! ################################
2024-09-22 22:04:21.838 : ################################ Beginning of Started! ################################
2024-09-22 22:04:21.838 : Var has been collected from file: gdm3
2024-09-22 22:04:21.839 : Starting gdm3.service
2024-09-22 22:04:22.334 : Started gdm3.service
2024-09-22 22:04:22.335 : ################################ End of Started! ################################
2024-09-22 22:05:13.729 : ################################ Beginning of Stopped! ################################
2024-09-22 22:05:13.742 : Display Manager is not KDE!
2024-09-22 22:05:13.743 : Distro is using Systemd
2024-09-22 22:05:13.744 : Display Manager = gdm3
2024-09-22 22:05:13.747 : Stopping gdm3.service
2024-09-22 22:05:15.673 : Stopped gdm3.service
2024-09-22 22:05:15.674 : ################################ End of Stopped! ################################
2024-09-22 22:05:15.877 : ################################ Beginning of Release! ################################
2024-09-22 22:05:15.878 : Unloading VFIO drivers
2024-09-22 22:05:15.990 : VFIO drivers unloaded
2024-09-22 22:05:15.992 : Retaining NVIDIA Udev Rules
2024-09-22 22:05:15.993 : Restarting udev
2024-09-22 22:05:16.034 : Restarted udev
2024-09-22 22:05:16.034 : Loading NVIDIA GPU Drivers
2024-09-22 22:05:17.296 : NVIDIA GPU Drivers Loaded
2024-09-22 22:05:17.298 : Var has been collected from file: gdm3
2024-09-22 22:05:17.298 : Starting gdm3.service
2024-09-22 22:05:17.466 : gdm3.service Started
2024-09-22 22:05:17.467 : ################################ End of Release! ################################
```
