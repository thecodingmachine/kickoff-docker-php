{{- range $database := .Values.Modules.mysql.databases }}
CREATE DATABASE IF NOT EXISTS `{{ $database }}` ;
GRANT ALL ON `{{ $database }}`.* TO '{{ $.Values.Modules.mysql.user }}'@'%' ;
{{- end }}
FLUSH PRIVILEGES ;