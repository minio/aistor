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
# This script downloads DirectPV plugin.
#

set -o errexit
set -o nounset
set -o pipefail

version="5.0.1"

function init() {
    if [ "$#" -gt 1 ]; then
        cat <<EOF
USAGE:
  download-plugin.sh [VERSION]

ARGUMENT:
VERSION    DirectPV plugin version to download (default: $version)

EXAMPLE:
$ download-plugin.sh
EOF
        exit 255
    elif [ "$#" -eq 1 ]; then
        version="$1"
    fi
}

function main() {
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m)
    case "${arch}" in
        x86_64) arch="amd64" ;;
        aarch64) arch="arm64" ;;
        ppc64le) arch="ppc64le" ;;
        *) echo "ERROR: unsupported architecture ${arch}" >&2; exit 1 ;;
    esac

    curl -sfLo /usr/local/bin/kubectl-directpv "https://dl.min.io/aistor/directpv/release/${os}-${arch}/kubectl-directpv_${version}"
    chmod a+x /usr/local/bin/kubectl-directpv
}

init "$@"
main "$@"
