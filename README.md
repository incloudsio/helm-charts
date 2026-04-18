# Elassandra Helm Charts

This repository contains Helm charts related to Elassandra and companion services.

## Current Elassandra Chart

The current Elassandra chart source is:

- `charts/elassandra`

Application source, Docker build, and product documentation live in:

- `https://github.com/incloudsio/elassandra`

## Use The Chart Today

The chart is published at `https://charts.elassandra.org`:

```bash
helm repo add elassandra https://charts.elassandra.org
helm repo update
helm install elassandra elassandra/elassandra
```

For Azure / AKS with the published ACR image, download the preset and install from the Helm repository:

```bash
curl -Lo values-azure.yaml https://raw.githubusercontent.com/incloudsio/helm-charts/master/charts/elassandra/values-azure.yaml

helm upgrade --install elassandra elassandra/elassandra \
  --namespace elassandra \
  --create-namespace \
  -f values-azure.yaml
```

## Other Charts

This repository also contains related charts such as:

- `charts/elassandra-operator`
- `charts/elassandra-datacenter`
- `charts/fluent-bit`
- `charts/storageclass`
