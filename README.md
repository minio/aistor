# MinIO Enterprise Object Store

A unified management interface for all the MinIO Enterprise Store features:

- Observability
- Key Management
- Load Balancer
- Firewall
- Catalog
- WARP
- AdminJob
- Operator

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

1. Install AIStor with the following `kubectl` command

   ```shell
   kubectl apply -k https://min.io/k8s/eos
   ```

2. Use `kubectl proxy` to port forward the AIStor Console to access the User Interface

   ```shell
   kubectl -n aistor port-forward svc/aistor 8444:8444
   ```

3. In your browser, go to http://localhost:8444

4. AIStor Setup screen prompts for the license.

   ![The Setup screen asks for a license ](images/aistor-setup.png)

   To obtain your license, see the [SUBNET cluster registration page](https://subnet.min.io/cluster/register).

5. Create the initial Admin User and click `Finish Setup`.

   ![Register the first Admin user](images/aistor-admin-first-user.png)

   Provide the **email address** and **password** for the user.
   Enter the **password** twice.

6. Login with the created credentials.
   ![aistor-login.png](images/aistor-login.png)


7. Welcome to the AIstor dashboard!

   ![aistor-dashboard.png](images/aistor-dashboard.png)