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

#
# This script pushes DirectPV and its sidecar images to private registry.
#

set -o errexit
set -o nounset
set -o pipefail

declare registry

function init() {
    if [ "$#" -ne 1 ]; then
        cat <<EOF
USAGE:
  push-images.sh <REGISTRY>

ARGUMENT:
<REGISTRY>    Image registry without scheme prefix like 'http', 'docker' etc.

EXAMPLE:
$ push-images.sh registry.airgap.net/aistor
EOF
        exit 255
    fi
    registry="$1"

    if ! which skopeo >/dev/null 2>&1; then
        echo "skopeo not found; please install"
        exit 255
    fi
}

# usage: push_image <image>
function push_image() {
    image="$1"
    private_image="${image/quay.io\/minio/$registry}"
    echo "Pushing image ${image}"
    skopeo copy --multi-arch=all --preserve-digests "docker://${image}" "docker://${private_image}"
}

function main() {
    push_image "quay.io/minio/csi-node-driver-registrar:v2.13.0-0" # quay.io/minio/csi-node-driver-registrar@sha256:8f00013a19bd3bea021f3e96b093814fb110b383c0fd050d2a5309afb0ed0ccb
    push_image "quay.io/minio/csi-provisioner:v5.2.0-0" # quay.io/minio/csi-provisioner@sha256:24816a743663d153060f0c3fc30005f05bea23c8b0fd2551fd667042741e8562
    push_image "quay.io/minio/livenessprobe:v2.15.0-0" # quay.io/minio/livenessprobe@sha256:d8f7d431a2a148970dcb337f24b265d173bcee58bbeeae9af7ae60f01ce49be2
    push_image "quay.io/minio/csi-resizer:v1.13.1-0" # quay.io/minio/csi-resizer@sha256:fc0c1f9cbc0ebb16283c0e425c031041eedb0e8ebbe6a1adec3de41584548ce6
    push_image "quay.io/minio/directpv:v5.0.2" # quay.io/minio/directpv@sha256:9c752ba828d005fcaa2dafa5a4cd69e873f159f44f0c2329d052e47e928a0a77
}

init "$@"
main "$@"
