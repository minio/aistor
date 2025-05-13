# API Reference

## Packages
- [sts.min.io/v1alpha1](#stsminiov1alpha1)


## sts.min.io/v1alpha1

Package v1alpha1 - The following parameters are specific to the `sts.min.io/v1alpha1` MinIO Policy Binding CRD API
PolicyBinding is an Authorization mechanism managed by the Minio Operator.
Using Kubernetes ServiceAccount JSON Web Tokens the binding allow a ServiceAccount to assume temporary IAM credentials.
For more complete documentation on this object, see the https://docs.min.io/minio/k8s/reference/minio-operator-reference.html#minio-operator-yaml-reference[MinIO Kubernetes Documentation].
PolicyBinding is added as part of the MinIO Operator v5.0.0. +



#### Application



Application defines the `Namespace` and `ServiceAccount` to authorize the usage of the policies listed



_Appears in:_
- [PolicyBindingSpec](#policybindingspec)

| Field | Description | Default | Validation |
| --- | --- | --- | --- |
| `namespace` _string_ | *Required* + |  |  |
| `serviceaccount` _string_ | *Required* + |  |  |


#### PolicyBinding



PolicyBinding is a https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/[Kubernetes object] describing a MinIO PolicyBinding.



_Appears in:_
- [PolicyBindingList](#policybindinglist)

| Field | Description | Default | Validation |
| --- | --- | --- | --- |
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |  |  |
| `spec` _[PolicyBindingSpec](#policybindingspec)_ | *Required* +<br /><br />The root field for the MinIO PolicyBinding object. |  |  |




#### PolicyBindingSpec



PolicyBindingSpec (`spec`) defines the configuration of a MinIO PolicyBinding object. +



_Appears in:_
- [PolicyBinding](#policybinding)

| Field | Description | Default | Validation |
| --- | --- | --- | --- |
| `application` _[Application](#application)_ | *Required* +<br /><br />The Application Property identifies the namespace and service account that will be authorized |  |  |
| `policies` _string array_ | *Required* + |  |  |




#### PolicyBindingUsage



PolicyBindingUsage are metrics regarding the usage of the policyBinding



_Appears in:_
- [PolicyBindingStatus](#policybindingstatus)

| Field | Description | Default | Validation |
| --- | --- | --- | --- |
| `authotizations` _integer_ |  |  |  |


