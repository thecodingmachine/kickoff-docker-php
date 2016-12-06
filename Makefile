# @IgnoreInspection BashAddShebang

# kickoff-docker-php makefile

source .env

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

tail-e:
	docker exec -ti ${APACHE_CONTAINER} tail -f /var/log/apache2/error.log;

tail-a:
	docker exec -ti ${APACHE_CONTAINER} tail -f /var/log/apache2/access.log;

tail-nginx:
	docker logs -f ${NGINX_CONTAINER};

tail-mysql:
	docker logs -f ${MYSQL_CONTAINER};

export:
	./bin/_export;

import:
	./bin/_import;

composer:
	./bin/_composer --command $(cmd);

npm:
	docker exec --user="custom_user" -ti ${APACHE_CONTAINER} npm $(cmd);

# BUILDING
#------------------------------------------------------
prepare:
	./bin/_prepare;

build:
	docker-compose -f docker-compose.yml build;

down:
	./bin/_down;

up:
	docker-compose -f docker-compose.yml up -d;

kickoff: down prepare build up