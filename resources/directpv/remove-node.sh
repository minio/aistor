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

declare NODE

function delete_resource() {
    resource="$1"
    selector="directpv.min.io/node=${NODE}"

    # unset the finalizers
    kubectl get "${resource}" --selector="${selector}" -o custom-columns=NAME:.metadata.name --no-headers | while read -r name; do
        kubectl patch "${resource}" "${name}" -p '{"metadata":{"finalizers":null}}' --type=merge
    done
    
    # delete the objects
    kubectl delete "${resource}" --selector="${selector}" --ignore-not-found=true
}

function init() {
    if [[ $# -ne 1 ]]; then
        cat <<EOF
usage: remove-node.sh <NODE>

This script forcefully removes all the DirectPV resources from the node.
CAUTION: Remove operation is irreversible and may incur data loss if not used cautiously.
EOF
        exit 255
    fi

    if ! which kubectl >/dev/null 2>&1; then
        echo "kubectl not found; please install"
        exit 255
    fi

    NODE="$1"

    if kubectl get --ignore-not-found=true csinode "${NODE}" -o go-template='{{range .spec.drivers}}{{if eq .name "directpv-min-io"}}{{.name}}{{break}}{{end}}{{end}}' | grep -q .; then
        echo "node ${NODE} is still in use; remove node ${NODE} from DirectPV DaemonSet and try again"
        exit 255
    fi
}

function main() {
    delete_resource directpvvolumes
    delete_resource directpvdrives
    delete_resource directpvinitrequests
    kubectl delete directpvnode "${NODE}" --ignore-not-found=true
}

init "$@"
main "$@"
