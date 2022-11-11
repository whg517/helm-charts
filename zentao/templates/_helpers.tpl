{{/*
Expand the name of the chart.
*/}}
{{- define "zentao.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "zentao.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "zentao.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "zentao.labels" -}}
helm.sh/chart: {{ include "zentao.chart" . }}
{{ include "zentao.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "zentao.selectorLabels" -}}
app.kubernetes.io/name: {{ include "zentao.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "zentao.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "zentao.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
zentao.persistence.mysql.accessModes
*/}}
{{- define "zentao.persistence.mysql.accessModes" -}}
{{- with .Values.persistence.mysql.accessModes -}}
{{- range . -}}
  - {{ . | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
zentao.persistence.zentao.accessModes
*/}}
{{- define "zentao.persistence.zentao.accessModes" -}}
{{- with .Values.persistence.zentao.accessModes -}}
{{- range . -}}
  - {{ . | quote }}
{{- end }}
{{- end }}
{{- end }}


{{- define "zentao.secretName" -}}
{{- if .Values.secret.mysql.existSecret -}}
  {{- printf "%s" (tpl .Values.secret.mysql.existSecret $) -}}
{{- else -}}
  {{ include "zentao.fullname" . }}
{{- end }}
{{- end }}


{{/*
mysql root password
*/}}
{{- define "zentao.mysql.rootPassword" -}}
{{- if .Values.secret.mysql.rootPassword }}
    {{- .Values.secret.mysql.rootPassword -}}
{{- else -}}
    {{- randAlphaNum 14 -}}
{{- end -}}
{{- end -}}