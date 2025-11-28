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
    push_image "quay.io/minio/livenessprobe:v2.17.0-0" # quay.io/minio/livenessprobe@sha256:8f3b1bec9c87a832a3fe6e8b7f165e0ff048aef7373f9764f40efee456a00321
    push_image "quay.io/minio/csi-node-driver-registrar:v2.15.0-0" # quay.io/minio/csi-node-driver-registrar@sha256:c571b1462c6798725c0da58aab4896f910b38dc4ef48352ead3e4625d2d63a06
    push_image "quay.io/minio/csi-provisioner:v6.0.0-0" # quay.io/minio/csi-provisioner@sha256:fff8927753ef1a67278804897de5dda9fd47c48b27575d53daafb12ab7179446
    push_image "quay.io/minio/csi-resizer:v2.0.0-0" # quay.io/minio/csi-resizer@sha256:0640655cdf10b17bf50b304d5c3555135141b6bd3d79260a3ce389bf90d4e4bf
    push_image "quay.io/minio/directpv:v5.1.0" # quay.io/minio/directpv@sha256:76bb7e4d204f95fea9e05637f18b68de2e54543ed0e2f3c4eae330d72b304abb
}

init "$@"
main "$@"
