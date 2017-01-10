# @IgnoreInspection BashAddShebang

# kickoff-docker-php makefile

include ./.env

# BUILDING
#------------------------------------------------------
prepare:
	./bin/_prepare;
	./bin/_whalesay --say "Your docker-compose files are ready!";

build:
	docker-compose -f docker-compose.yml build;
	./bin/_whalesay --say "Apache container (${APACHE_CONTAINER_NAME}) has been built!";

down:
	./bin/_down;
	./bin/_whalesay --say "Apache (${APACHE_CONTAINER_NAME}) and MySQL (${MYSQL_CONTAINER_NAME}) containers have been stopped!";

up:
	docker-compose -f docker-compose.yml up -d;
	./bin/_whalesay --say "Apache (${APACHE_CONTAINER_NAME}) and MySQL (${MYSQL_CONTAINER_NAME}) containers are running!";

nginx-down:
	docker-compose -p ${NGINX_PROXY_NAME} -f docker-compose-nginx.yml down;
	./bin/_whalesay --say "NGINX (${NGINX_CONTAINER_NAME}) container has been stopped!";

nginx-up:
	docker-compose -p ${NGINX_PROXY_NAME} -f docker-compose-nginx.yml up -d;
	./bin/_whalesay --say "NGINX (${NGINX_CONTAINER_NAME}) container is running!";

kickoff: down prepare build nginx-up up;
	./bin/_whalesay --say "You're ready to go!";

# UTILS
#------------------------------------------------------
shell:
	./bin/_shell --container_name ${APACHE_CONTAINER_NAME} --service_name "Apache";

shell-nginx:
	./bin/_shell --container_name ${NGINX_CONTAINER_NAME} --service_name "NGINX";

shell-mysql:
	./bin/_shell --container_name ${MYSQL_CONTAINER_NAME} --service_name "MySQL";

mysql-cli:
	./bin/_mysql_cli;

tail:
	./bin/_tail --container_name ${APACHE_CONTAINER_NAME} --service_name "Apache";

tail-nginx:
	./bin/_tail --container_name ${NGINX_CONTAINER_NAME} --service_name "NGINX";

tail-mysql:
	./bin/_tail --container_name ${MYSQL_CONTAINER_NAME} --service_name "MySQL";

export:
	./bin/_export;

import:
	./bin/_import;

composer:
	./bin/_composer --command $(cmd);

npm:
	./bin/_npm --command $(cmd);