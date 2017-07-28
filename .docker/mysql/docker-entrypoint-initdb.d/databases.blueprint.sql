{{- range $database := .Values.Kickoff.mysql.databases }}
CREATE DATABASE IF NOT EXISTS `{{ $database }}` ;
GRANT ALL ON `{{ $database }}`.* TO '{{ $.Values.Kickoff.mysql.user }}'@'%' ;
{{- end }}
FLUSH PRIVILEGES ;