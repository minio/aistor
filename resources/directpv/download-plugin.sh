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

function check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "ERROR: This script must be run as root" >&2
        echo "Please run with sudo or as root user" >&2
        exit 1
    fi
}

function init() {
    # Check for root privileges first
    check_root

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
        arm64) arch="arm64" ;;
        *) echo "ERROR: unsupported architecture ${arch}" >&2; exit 1 ;;
    esac

    curl -fLo /usr/local/bin/kubectl-directpv "https://dl.min.io/aistor/directpv/release/${os}-${arch}/kubectl-directpv_${version}"
    chmod a+x /usr/local/bin/kubectl-directpv
}

init "$@"
main "$@"
