# Elassandra

Helm chart for running the current Elassandra line based on Apache Cassandra 4.0.x and OpenSearch 1.3.x.

## Chart Source

This chart is maintained in the shared chart repository:

- `https://github.com/incloudsio/helm-charts`

The Elassandra application source, Docker build, and product documentation live in:

- `https://github.com/incloudsio/elassandra`

## Install From Helm Repository

Add the published repository and install the chart:

```bash
helm repo add elassandra https://charts.elassandra.org
helm repo update
helm install elassandra elassandra/elassandra
```

Defaults are intentionally conservative:

- one Elassandra pod
- persistent storage enabled
- separate headless, CQL, and search services
- OpenSearch Dashboards disabled by default

## Minikube

Build and load the local image first:

```bash
./gradlew :distribution:docker:buildDockerImage
minikube image load elassandra:test
```

Then download the minikube preset and install from the Helm repository:

```bash
curl -Lo values-minikube.yaml https://raw.githubusercontent.com/incloudsio/helm-charts/master/charts/elassandra/values-minikube.yaml

helm install elassandra elassandra/elassandra \
  -f values-minikube.yaml
```

## Provider Presets

The chart includes shallow provider presets:

- `values-aws.yaml`
- `values-gcp.yaml`
- `values-azure.yaml`
- `values-minikube.yaml`

These presets focus on install-time defaults such as replica count, storage class,
resource sizing, and affinity. They do not configure cloud identity integrations.

Download the preset you want locally, then install from the Helm repository. Examples:

```bash
curl -Lo values-aws.yaml https://raw.githubusercontent.com/incloudsio/helm-charts/master/charts/elassandra/values-aws.yaml
helm install elassandra elassandra/elassandra \
  -f values-aws.yaml

curl -Lo values-gcp.yaml https://raw.githubusercontent.com/incloudsio/helm-charts/master/charts/elassandra/values-gcp.yaml
helm install elassandra elassandra/elassandra \
  -f values-gcp.yaml
```

## Azure / AKS

The Azure preset references:

- `elassandra.azurecr.io/elassandra:1.3.20`

If your AKS cluster is attached to the ACR:

```bash
az aks update \
  --resource-group <resource-group> \
  --name <aks-cluster> \
  --attach-acr elassandra

curl -Lo values-azure.yaml https://raw.githubusercontent.com/incloudsio/helm-charts/master/charts/elassandra/values-azure.yaml

helm upgrade --install elassandra elassandra/elassandra \
  --namespace elassandra \
  --create-namespace \
  -f values-azure.yaml
```

If you are not attaching the ACR, create an image pull secret and pass it to the chart:

```bash
kubectl create namespace elassandra

kubectl create secret docker-registry elassandra-acr \
  --namespace elassandra \
  --docker-server=elassandra.azurecr.io \
  --docker-username=<acr-username> \
  --docker-password=<acr-password>

curl -Lo values-azure.yaml https://raw.githubusercontent.com/incloudsio/helm-charts/master/charts/elassandra/values-azure.yaml

helm upgrade --install elassandra elassandra/elassandra \
  --namespace elassandra \
  -f values-azure.yaml \
  --set imagePullSecrets[0].name=elassandra-acr
```

## Dashboards

Dashboards are optional and disabled by default.

Enable them with the public upstream image:

```bash
helm install elassandra elassandra/elassandra \
  --set dashboards.enabled=true
```

If you mirror Dashboards into your own registry, override `dashboards.image.repository`
and `dashboards.image.tag` at install time.

## Validate The Chart Source

If you are working from a checkout, typical validation commands are:

```bash
git clone https://github.com/incloudsio/helm-charts.git
helm lint ./helm-charts/charts/elassandra
helm template elassandra ./helm-charts/charts/elassandra \
  -f ./helm-charts/charts/elassandra/values-minikube.yaml
```
