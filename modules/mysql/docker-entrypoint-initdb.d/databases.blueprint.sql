{{- range $database := .Orbit.Modules.mysql.databases }}
CREATE DATABASE IF NOT EXISTS `{{ $database }}` ;
GRANT ALL ON `{{ $database }}`.* TO '{{ $.Orbit.Modules.mysql.user }}'@'%' ;
{{- end }}
FLUSH PRIVILEGES ;