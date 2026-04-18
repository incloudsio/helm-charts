# Elassandra Helm Charts

This repository contains Helm charts related to Elassandra and companion services.

## Current Elassandra Chart

The current Elassandra chart source is:

- `charts/elassandra`

Application source, Docker build, and product documentation live in:

- `https://github.com/incloudsio/elassandra`

## Use The Chart Today

Until this repository is published as a Helm repository or OCI registry, install from a checkout:

```bash
git clone https://github.com/incloudsio/helm-charts.git
helm install elassandra ./helm-charts/charts/elassandra
```

For Azure / AKS with the pushed ACR image:

```bash
helm upgrade --install elassandra ./helm-charts/charts/elassandra \
  --namespace elassandra \
  --create-namespace \
  -f ./helm-charts/charts/elassandra/values-azure.yaml
```

## Other Charts

This repository also contains related charts such as:

- `charts/elassandra-operator`
- `charts/elassandra-datacenter`
- `charts/fluent-bit`
- `charts/storageclass`

## Recommended Publishing Path

The cleanest long-term publishing options are:

1. publish packaged charts through GitHub Pages at a domain such as `charts.elassandra.org`
2. publish the chart as an OCI artifact in a registry such as ACR or GHCR

OCI is generally the cleaner option for modern Helm distribution because it avoids maintaining a separate `index.yaml` repository flow.

## Publishing To `charts.elassandra.org`

This repository now includes a GitHub Actions workflow at:

- `.github/workflows/publish-pages.yml`

The workflow:

- lints every chart under `charts/*`
- packages each chart into `.tgz`
- merges with any existing `gh-pages` `index.yaml`
- regenerates `index.yaml` with `https://charts.elassandra.org`
- writes `CNAME`
- publishes the result to the `gh-pages` branch

### What To Configure In GitHub

After pushing these repo-side changes, set the following in GitHub:

1. `Settings` -> `Pages`
   - Source: `Deploy from a branch`
   - Branch: `gh-pages`
   - Folder: `/ (root)`

2. `Settings` -> `Actions` -> `General`
   - Workflow permissions: `Read and write permissions`

3. Ensure your DNS has:
   - `charts.elassandra.org CNAME incloudsio.github.io`

### Resulting User Flow

Once the first publish succeeds, users can install from your domain with:

```bash
helm repo add elassandra https://charts.elassandra.org
helm repo update
helm install elassandra elassandra/elassandra
```
