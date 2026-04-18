{{- define "elassandra.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "elassandra.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "elassandra.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "elassandra.labels" -}}
helm.sh/chart: {{ include "elassandra.chart" . }}
app.kubernetes.io/name: {{ include "elassandra.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "elassandra.selectorLabels" -}}
app.kubernetes.io/name: {{ include "elassandra.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "elassandra.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "elassandra.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{- define "elassandra.seedHost" -}}
{{- if .Values.elassandra.seeds -}}
{{- .Values.elassandra.seeds -}}
{{- else -}}
{{- printf "%s-0.%s-headless.%s.svc.cluster.local" (include "elassandra.fullname" .) (include "elassandra.fullname" .) .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{- define "elassandra.image" -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end -}}

{{- define "elassandra.dashboardsHosts" -}}
{{- if .Values.dashboards.opensearchHosts -}}
{{- toJson .Values.dashboards.opensearchHosts -}}
{{- else -}}
{{- printf "[\"http://%s-search:%d\"]" (include "elassandra.fullname" .) (int .Values.searchService.port) -}}
{{- end -}}
{{- end -}}
