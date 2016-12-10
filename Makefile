# @IgnoreInspection BashAddShebang

# kickoff-docker-php makefile

include ./.env

# BUILDING
#------------------------------------------------------
prepare:
	./bin/_prepare;
	./bin/_whalesay --say "Your docker-compose files are ready!";

build:
	docker-compose -p ${PROJECT_NAME} -f docker-compose.yml build;
	./bin/_whalesay --say "The Apache container has been built!";

down:
	./bin/_down;
	./bin/_whalesay --say "The Apache and MySQL containers have been stopped!";

up:
	docker-compose -p ${PROJECT_NAME} -f docker-compose.yml up -d;
	./bin/_whalesay --say "The Apache and MySQL containers are running!";

nginx-down:
	docker-compose -p ${PROXY_NAME} -f docker-compose-nginx.yml down;
	./bin/_whalesay --say "The NGINX container has been stopped!";

nginx-up:
	docker-compose -p ${PROXY_NAME} -f docker-compose-nginx.yml up -d;
	./bin/_whalesay --say "The NGINX container is running!";

kickoff: down prepare build nginx-up up;
	./bin/_whalesay --say "You're ready to go!";

# UTILS
#------------------------------------------------------
shell:
	docker exec -ti ${APACHE_CONTAINER} bash;

shell-nginx:
	docker exec -ti ${NGINX_CONTAINER} bash;

shell-mysql:
	docker exec -ti ${MYSQL_CONTAINER} bash;

mysql-cli:
	docker exec -ti ${MYSQL_CONTAINER} mysql -uroot -p${MYSQL_PASSWORD};

tail:
	docker logs -f ${APACHE_CONTAINER};

tail-nginx:
	docker logs -f ${NGINX_CONTAINER};

tail-mysql:
	docker logs -f ${MYSQL_CONTAINER};

export:
	./bin/_export;
	./bin/_whalesay --say "Export complete!";

import:
	./bin/_import;
	./bin/_whalesay --say "Import complete!";

composer:
	./bin/_composer --command $(cmd);

npm:
	docker exec -ti ${APACHE_CONTAINER} npm $(cmd);