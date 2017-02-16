# @IgnoreInspection BashAddShebang

# kickoff-docker-php makefile

include ./.env

# BUILDING
#------------------------------------------------------
prepare:
	./_bin/_prepare;

build:
	./_bin/_build;

down:
	./_bin/_down;

up:
	./_bin/_up;

proxy-down:
	./_bin/_reverse_proxy_down;

proxy-up:
	./_bin/_reverse_proxy_up;

kickoff:
	./_bin/_kickoff;

# UTILS
#------------------------------------------------------
shell:
	./_bin/_shell --container_name ${APACHE_CONTAINER_NAME} --service_name "Apache";

shell-proxy:
	./_bin/_shell --container_name ${REVERSE_PROXY_CONTAINER_NAME} --service_name "Reverse proxy";

shell-mysql:
	./_bin/_shell --container_name ${MYSQL_CONTAINER_NAME} --service_name "MySQL";

mysql-cli:
	./_bin/_mysql_cli;

tail:
	./_bin/_tail --container_name ${APACHE_CONTAINER_NAME} --service_name "Apache";

tail-proxy:
	./_bin/_tail --container_name ${REVERSE_PROXY_CONTAINER_NAME} --service_name "Reverse proxy";

tail-mysql:
	./_bin/_tail --container_name ${MYSQL_CONTAINER_NAME} --service_name "MySQL";

export:
	./_bin/_export;

import:
	./_bin/_import;

composer:
	./_bin/_composer --command $(cmd);

npm:
	./_bin/_npm --command $(cmd);