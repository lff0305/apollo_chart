{{/* vim: set filetype=mustache: */}}

{{/*
Common labels
*/}}
{{- define "apollo.service.labels" -}}
{{- if .Chart.AppVersion -}}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}


{{/*
Common labels
*/}}
{{- define "apollo.portal.labels" -}}
{{- if .Chart.AppVersion -}}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}
