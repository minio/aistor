# AIStor

Hyperscale Object Store for AI

MinIO AIStor is designed to allow enterprises to consolidate all of
their data on a single, private cloud namespace. Architected using
the same principles as the hyperscalers, AIStor delivers performance
at scale at a fraction of the cost compared to the public cloud.

AIStor runs in Kubernetes.

## Pre-requisites

* An active Kubernetes environment running a [maintained version](https://kubernetes.io/releases/)
* [`kubectl` CLI tool](https://kubernetes.io/docs/tasks/tools/#kubectl)

### Environment

You can run AIStor on Kubernetes providers such as

- Redhat Openshift
- Google Kubernetes Engine
- Amazon Elastic Kubernetes Service
- Azure Kubernetes Service
- Upstream Kubernetes

Other Kubernetes providers may also work.

## Getting Started

### Install all AIStor Operators with the following `kubectl` command

Install all AIStor operators at once

```shell
kubectl apply --server-side -k https://min.io/k8s/aistor
```

Or install one AIStor operator selectively

```shell
# 1) Create aistor namespace
kubectl apply --server-side -f https://raw.githubusercontent.com/minio/aistor/master/resources/namespace.yaml

# 2) Install AIStor Object Store Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resorces/operators/base/object-store

# 3) Install AIStor AdminJob Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resorces/operators/base/adminjob

# 4) Install AIStor AIHub Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resorces/operators/base/aihub

# 5) Install AIStor AdminJob Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resorces/operators/base/keymanager

# 6) Install AIStor Prompt Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resorces/operators/base/prompt

# 7) Install AIStor WARP Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resorces/operators/base/warp
```


### Where to get a license?

For customers, you can get the license from https://subnet.min.io/.

If you register to [Minio subscription learning platform](https://min.io/training#training-nav) you get a [60 days trial license](https://min.io/training/learningsubscription?ref=blog.min.io#subscription-trial-license).

Finally, create a license secret for AIStor, edit the file in [license.yaml](resources/license.yaml) and include the AIStor license to it.

```yaml
apiVersion: v1
data:
  minio.license: <base 64 encoded license here>
kind: Secret
metadata:
  name: minio-license
  namespace: aistor
type: Opaque
```

```shell
kubectl apply --server-side -f  license.yaml
```

### Install with helm

```shell
helm repo add aistor https://aistor.min.io/
helm install --namespace aistor --create-namespace aistor aistor/aistor --set global.license=<your-license-key>
```
