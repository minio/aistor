#!/usr/bin/env bash
#
# MinIO, Inc. CONFIDENTIAL
#
# [2014] - [2025] MinIO, Inc. All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains the property
# of MinIO, Inc and its suppliers, if any.  The intellectual and technical
# concepts contained herein are proprietary to MinIO, Inc and its suppliers
# and may be covered by U.S. and Foreign Patents, patents in process, and are
# protected by trade secret or copyright law. Dissemination of this information
# or reproduction of this material is strictly forbidden unless prior written
# permission is obtained from MinIO, Inc.

set -e -C -o pipefail

declare NAME
declare -a DRIVE_LABELS

function init() {
    if [[ $# -lt 2 ]]; then
        cat <<EOF
USAGE:
  create-storage-class.sh <NAME> <DRIVE-LABELS> ...

ARGUMENTS:
  NAME           new storage class name.
  DRIVE-LABELS   drive labels to be attached.

EXAMPLE:
  # Create new storage class 'fast-tier-storage' with drive labels 'directpv.min.io/tier: fast'
  $ create-storage-class.sh fast-tier-storage 'directpv.min.io/tier: fast'
EOF
        exit 255
    fi

    NAME="$1"
    shift
    DRIVE_LABELS=( "$@" )

    for val in "${DRIVE_LABELS[@]}"; do
        if ! [[ "${val}" =~ ^directpv.min.io/.* ]]; then
            echo "invalid label ${val}; label must start with 'directpv.min.io/'"
            exit 255
        fi
    done

    if ! which kubectl >/dev/null 2>&1; then
        echo "kubectl not found; please install"
        exit 255
    fi
}

function main() {
    kubectl apply -f - <<EOF
allowVolumeExpansion: true
allowedTopologies:
- matchLabelExpressions:
  - key: directpv.min.io/identity
    values:
    - directpv-min-io
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  finalizers:
  - foregroundDeletion
  labels:
    application-name: directpv.min.io
    application-type: CSIDriver
    directpv.min.io/created-by: kubectl-directpv
    directpv.min.io/version: v1beta1
  name: ${NAME}
parameters:
  csi.storage.k8s.io/fstype: xfs
$(printf '  %s\n' "${DRIVE_LABELS[@]}")
provisioner: directpv-min-io
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
EOF
}

init "$@"
main "$@"
