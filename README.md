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
* [`helm` CLI tool](https://helm.sh/docs/intro/install/)
* `oc` CLI tool if you are using Openshift

### Environment

You can run AIStor on Kubernetes providers such as

- Redhat Openshift
- Upstream Kubernetes
- Google Kubernetes Engine
- Amazon Elastic Kubernetes Service
- Azure Kubernetes Service

Other Kubernetes providers may also work.

# Helm

## Helm charts Repo

AIStor Helm repo is the official MinIO AIStor Helm repo. You can add it with the following command:
```shell
helm repo add aistor https://aistor.min.io/
helm repo update
```

WHen you add the repo, you can see the available charts with the following command:
```shell
helm search repo aistor
NAME                     	CHART VERSION	APP VERSION        	DESCRIPTION                                       
aistor/aistor      	3.0.0        	v20250512190907.0.0	(Deprecated, please use operators chart) Helm c...
aistor/aistor-crd  	1.0.1        	v20250411230718.0.0	(Deprecated, please use operators chart) Helm c...
aistor/keymanager  	1.0.0        	                   	Helm chart for MinIO AIStor Key Manager           
aistor/object-store	1.0.2        	                   	Helm chart for MinIO AIStor Object Store          
aistor/operators   	3.0.0        	v20250512190907.0.0	Helm chart for MinIO AIStor Operators
```

## AIStor Operators

`aistor/operators` is the AIStor operators chart, by default, it will install only 2 operators:

* AIStor Object Store Operator
* AIStor AdminJob Operator

You can install the AIStor operators with the following commands:

```shell

helm install --namespace aistor \
  --create-namespace operators aistor/operators \
  --set global.license="<your-license-key>"
NAME: operators
LAST DEPLOYED: Tue May 20 16:03:59 2025
NAMESPACE: aistor
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing AIStor Operators v20250512190907.0.0. Your release
is named "operators".

The following operators have been installed:
- adminjob-operator
- object-store-operator

A license has been installed.
```

### AIStor Object Store

Now you are ready to create your own AIStor object store, get the values.yaml file from the chart and edit it to your needs.

```shell
helm show values aistor/object-store > values.yaml
```

Finally, create the object store with the following command:

```shell
helm install my-objectstore aistor/object-store -n my-objectstore --create-namespace -f values.yaml 
```

## AIStor Key Manager Operator

The AIStor Key Manager Operator is responsible for managing the AIStor Key Manager.
To install the AIStor Key Manager Operator, you can use the following command:

```shell
helm install --namespace aistor --create-namespace operators aistor/operators \
  --set global.license="<your-license-key>" \
  --set operators.object-store.disabled=true \
  --set operators.adminjob.disabled=true \
  --set operators.keymanager.disabled=false
NAME: operators
LAST DEPLOYED: Tue May 20 16:10:54 2025
NAMESPACE: aistor
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing AIStor Operators v20250512190907.0.0. Your release
is named "operators".

The following operators have been installed:
- keymanager-operator

A license has been installed.
```

### AIStor Key Manager

Once Key Manager Operator is installed, you can create your own AIStor Key Manager, get the values.yaml file from the chart and edit it to your needs.

```shell
helm show values aistor/keymanager > values.yaml
```

Next, you want to create the HSM master key, in order to do that, you need to create it running the `minkms` command, this is possible running it from the container:

```shell
docker run quay.io/minio/aistor/minkms:latest --soft-hsm
hsm:aes256:9GvcPRfJ3j2jOKJlvlo0I3drwfWWYYCWnjbmTECNq/U=% 
```

Finally, create the Key Manager with the following command:

```shell
helm install my-keymanager aistor/keymanager -n my-keymanager --create-namespace --set  hsm.hsm="hsm:aes256:9GvcPRfJ3j2jOKJlvlo0I3drwfWWYYCWnjbmTECNq/U=%"
```

## AIStor AIHub Operator
The AIStor AIHub Operator is responsible for managing the AIStor AIHub.
To install the AIStor AIHub Operator, you can use the following command:

```shell
helm install --namespace aistor --create-namespace operators aistor/operators \
  --set global.license="<your-license-key>" \
  --set operators.object-store.disabled=true \
  --set operators.adminjob.disabled=true \
  --set operators.aihub.disabled=false
NAME: operators
LAST DEPLOYED: Tue May 20 16:14:10 2025
NAMESPACE: aistor
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing AIStor Operators v20250512190907.0.0. Your release
is named "operators".

The following operators have been installed:
- aihub-operator

A license has been installed.
```

## AIStor Prompt Operator
The AIStor Prompt Operator is responsible for managing the AIStor Prompt.
To install the AIStor Prompt Operator, you can use the following command:

```shell
helm install --namespace aistor --create-namespace operators aistor/operators \
  --set global.license="<your-license-key>" \
  --set operators.object-store.disabled=true \
  --set operators.adminjob.disabled=true \
  --set operators.prompt.disabled=false
NAME: operators
LAST DEPLOYED: Tue May 20 16:15:47 2025
NAMESPACE: aistor
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing AIStor Operators v20250512190907.0.0. Your release
is named "operators".

The following operators have been installed:
- prompt-operator

A license has been installed.
```

## AIStor WARP Operator

The AIStor WARP Operator is responsible for managing the AIStor WARP.
To install the AIStor WARP Operator, you can use the following command:

```shell
helm install --namespace aistor --create-namespace operators aistor/operators \
  --set global.license="<your-license-key>" \
  --set operators.object-store.disabled=true \
  --set operators.adminjob.disabled=true \
  --set operators.warp.disabled=false
NAME: operators
LAST DEPLOYED: Tue May 20 16:16:25 2025
NAMESPACE: aistor
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing AIStor Operators v20250512190907.0.0. Your release
is named "operators".

The following operators have been installed:
- warp-operator

A license has been installed.
```

# Openshift Operator Hub

You can also install the AIStor operators from the Openshift Operator Hub.

## AIStor Object Store Operator Bundle

The Object Store Operator bundle includes the following Operators:

* AIStor Object Store Operator
* AIStor AdminJob Operator

As part of the Bundle installation, the following Custom Resource Definitions (CRDs) are installed:

* ObjectStore
* AdminJob
* PolicyBinding

To Install the AIStor Object Store Operator Bundle, follow these steps:

```shell
# 1) Create aistor namespace
oc new-project aistor

# 2) Install AIStor Object Store Operator bundle
oc apply -f https://raw.githubusercontent.com/minio/aistor/master/resources/OperatorHub/ObjectStore/Subscription.yaml
```

## AIStor Key Manager Operator Bundle
The Key Manager Operator bundle includes the following Operators:
* AIStor Key Manager Operator

As part of the Bundle installation, the following Custom Resource Definitions (CRDs) are installed:
* KeyManager

To Install the AIStor Key Manager Operator Bundle, follow these steps:

```shell
# 1) Create aistor namespace
oc new-project aistor
# 2) Install AIStor Key Manager Operator bundle
oc apply -f https://raw.githubusercontent.com/minio/aistor/master/resources/OperatorHub/KeyManager/Subscription.yaml
```

# Kustomize

### Install all AIStor Operators with the following `kubectl` command

Install all AIStor operators at once with Kustomize.

```shell
kubectl apply --server-side -k https://min.io/k8s/aistor
```

Or install one AIStor operator selectively

```shell
# 1) Create aistor namespace
kubectl apply --server-side -f https://raw.githubusercontent.com/minio/aistor/master/resources/namespace.yaml

# 2) Install AIStor Object Store Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resources/operators/base/object-store

# 3) Install AIStor AdminJob Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resources/operators/base/adminjob

# 4) Install AIStor AIHub Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resources/operators/base/aihub

# 5) Install AIStor Key Manager Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resources/operators/base/keymanager

# 6) Install AIStor Prompt Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resources/operators/base/prompt

# 7) Install AIStor WARP Operator
kubectl apply --server-side -k https://min.io/k8s/aistor/resources/operators/base/warp
```

### Where to get a license?

For customers, you can get the license from https://subnet.min.io/.

If you register to [Minio subscription learning platform](https://min.io/training#training-nav) you get a [60 days trial license](https://min.io/training/learningsubscription?ref=blog.min.io#subscription-trial-license).

Finally, create a license secret for AIStor to enable the operators, edit the file in [license.yaml](resources/license.yaml) and include the AIStor license to it.

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


### Help and support

CRD's fields docs are available in the [docs](https://github.com/minio/aistor/tree/master/docs) folder.

For help and support open a ticket in SUBNET https://subnet.min.io/.