# DirectPV

Here are DirectPV security profiles, helper scripts and `kustomize` resources.

## Security Profiles
* apparmor.profile - DirectPV [AppArmor](https://apparmor.net/) profile for Kubernetes. If it is used, it is required to pass respective pod annotations to `Node Server` DaemonSet.
* seccomp.json - DirectPV [Seccomp](https://en.wikipedia.org/wiki/Seccomp) profile for Kubernetes. If it is used, it is required to pass profile filename to `Node Server` DaemonSet.

## Helper scripts
* create-storage-class.sh - A bash script to create custom storage class for DirectPV.
* download-plugin.sh - A bash script to download the latest or specific version of DirectPV plugin.
* push-images.sh - A bash script to push DirectPV and its sidecars container images to private repository.
* remove-node.sh - A bash script to remove DirectPV node.
* repair.sh - A bash script to repair DirectPV drive.
* replace.sh - A bash script to replace a faulty DirectPV drive.
