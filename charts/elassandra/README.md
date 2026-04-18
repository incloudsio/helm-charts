# Elassandra

Helm chart for running the current Elassandra line based on Apache Cassandra 4.0.x and OpenSearch 1.3.x.

## Chart Source

This chart is maintained in the shared chart repository:

- `https://github.com/incloudsio/helm-charts`

The Elassandra application source, Docker build, and product documentation live in:

- `https://github.com/incloudsio/elassandra`

## Install From A Checkout

Clone the chart repository and install from the chart directory:

```bash
git clone https://github.com/incloudsio/helm-charts.git
helm install elassandra ./helm-charts/charts/elassandra
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

Then install the minikube preset:

```bash
helm install elassandra ./helm-charts/charts/elassandra \
  -f ./helm-charts/charts/elassandra/values-minikube.yaml
```

## Provider Presets

The chart includes shallow provider presets:

- `values-aws.yaml`
- `values-gcp.yaml`
- `values-azure.yaml`
- `values-minikube.yaml`

These presets focus on install-time defaults such as replica count, storage class,
resource sizing, and affinity. They do not configure cloud identity integrations.

Examples:

```bash
helm install elassandra ./helm-charts/charts/elassandra \
  -f ./helm-charts/charts/elassandra/values-aws.yaml

helm install elassandra ./helm-charts/charts/elassandra \
  -f ./helm-charts/charts/elassandra/values-gcp.yaml
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

helm upgrade --install elassandra ./helm-charts/charts/elassandra \
  --namespace elassandra \
  --create-namespace \
  -f ./helm-charts/charts/elassandra/values-azure.yaml
```

If you are not attaching the ACR, create an image pull secret and pass it to the chart:

```bash
kubectl create namespace elassandra

kubectl create secret docker-registry elassandra-acr \
  --namespace elassandra \
  --docker-server=elassandra.azurecr.io \
  --docker-username=<acr-username> \
  --docker-password=<acr-password>

helm upgrade --install elassandra ./helm-charts/charts/elassandra \
  --namespace elassandra \
  -f ./helm-charts/charts/elassandra/values-azure.yaml \
  --set imagePullSecrets[0].name=elassandra-acr
```

## Dashboards

Dashboards are optional and disabled by default.

Enable them with the public upstream image:

```bash
helm install elassandra ./helm-charts/charts/elassandra \
  --set dashboards.enabled=true
```

If you mirror Dashboards into your own registry, override `dashboards.image.repository`
and `dashboards.image.tag` at install time.

## Validate Before Installing

Typical validation commands:

```bash
helm lint ./helm-charts/charts/elassandra
helm template elassandra ./helm-charts/charts/elassandra \
  -f ./helm-charts/charts/elassandra/values-minikube.yaml
```
