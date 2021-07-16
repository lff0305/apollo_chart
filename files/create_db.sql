{{- range .Values.envs }}
{{- with . }}
{{ $configMapFullName := printf "apollo-configmap-%s" . -}}
{{ $configDBSuffix := printf "%s" . -}}
{{ $configServiceFullName := printf "apollo-config-service-%s" . -}}
{{ $adminServiceFullName := printf "apollo-admin-service-%s" . -}}

create database IF NOT EXISTS {{ $.Values.configdb.dbName }}-{{ $configDBSuffix}} DEFAULT CHARACTER SET = utf8mb4;
grant all on {{ $.Values.configdb.dbName }}{{ $configDBSuffix}}.* to  {{ $.Values.configdb.userName }}@'%' IDENTIFIED by '{{ $.Values.configdb.password }}';

{{- end }}
{{ end }}