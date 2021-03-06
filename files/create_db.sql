{{- range .Values.envs }}
{{- with . }}
{{ $configMapFullName := printf "apollo-configmap-%s" . -}}
{{ $configDBSuffix := printf "%s" . -}}
{{ $configServiceFullName := printf "apollo-config-service-%s" . -}}
{{ $adminServiceFullName := printf "apollo-admin-service-%s" . -}}

CREATE USER IF NOT EXISTS '{{ $.Values.configdb.userName }}'@'%' IDENTIFIED by '{{ $.Values.configdb.password }}';

create database IF NOT EXISTS {{ $.Values.configdb.dbName }}{{ $configDBSuffix}} DEFAULT CHARACTER SET = utf8mb4;
grant all on {{ $.Values.configdb.dbName }}{{ $configDBSuffix}}.* to  {{ $.Values.configdb.userName }}@'%';
FLUSH PRIVILEGES;

{{- end }}
{{ end }}

create database IF NOT EXISTS {{ $.Values.portaldb.dbName }} DEFAULT CHARACTER SET = utf8mb4;
grant all on {{ $.Values.portaldb.dbName }}.* to  {{ $.Values.configdb.userName }}@'%';
FLUSH PRIVILEGES;