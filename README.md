[![PHP 7.0](https://img.shields.io/badge/PHP-7.0-green.svg)](apache/Dockerfile#L1)
[![Composer latest](https://img.shields.io/badge/Composer-latest-green.svg)](apache/Dockerfile#L21)
[![MySQL 5.7](https://img.shields.io/badge/MySQL-5.7-green.svg)](docker-compose.yml.template#L35)
[![Node.js 4.x](https://img.shields.io/badge/Node.js-4.x-orange.svg)](apache/Dockerfile#L29)
[![npm 2.x](https://img.shields.io/badge/npm-2.x-orange.svg)](apache/Dockerfile#L29)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

# Goal

This project will help you starting a PHP project with Docker, thanks to some useful make commands.

# Prerequisites

Install Docker (**>= 1.10**) for MacOSX / Linux following the official instructions: https://docs.docker.com/engine/installation

Install docker-compose (**>= 1.8.0**) for MacOSX / Linux following the official instructions: https://docs.docker.com/compose/install

**Important: for now, we do not recommend using Windows.**

# Quick start

First, fork this project and clone it.

Once done, move to the root directory of this project and run:

```
cp Makefile.default Makefile
```

Open your freshly created `Makefile` in your favorite editor and update the following environment variables:

```
PROJECT_NAME=yourproject
DATABASE_NAME=database_name
ENV=dev
ENV_DOMAIN_NAME=dev.yourproject.com
WITH_XDEBUG=0
```

**Note:** if `WITH_XDEBUG=1`, it will enable Xdebug on the apache container. We also recommend to enable it only for your development environment!

Good? Now open the file located at `/etc/hosts` (on MacOS / Linux) and add the following line at the end of the file:

```
127.0.0.1   dev.yourproject.com
```

**Note:** make sure that the domain name matches the value defined for `ENV_DOMAIN_NAME`.
 
We're now done with the configuration! :metal:

Last but not least, shutdown your local Apache or anything which could use your 80 and 443 ports, and run:

```
make kickoff
```

The installation might take some time, so go for a coffee break! :coffee: 

Once everything has been installed, open your favorite web browser and copy / paste http://dev.yourproject.com and check if everything is OK!

# Make commands

| Command                         | Description                                                                                                                                                                                |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| prepare                         | Creates the `docker-compose.yml` file using the environment variables specified in the `Makefile`.                                                                                         |
| build                           | Builds the containers.                                                                                                                                                                     |
| down                            | Stops the containers, deletes their network and cleans the docker cache.                                                                                                                   |
| up                              | Stops the containers if they're running and then up them.                                                                                                                                  |
| kickoff                         | Combo of prepare, build, and up commands.                                                                                                                                                  |
| composer cmd=*yourcommand*      | Allows you to run a composer command. Ex: `make composer cmd=install`, `make composer cmd=update`, ...                                                                                     |
| npm cmd=*yourcommand*           | Allows you to run a npm command. Ex: `make npm cmd=install`, `make npm cmd="install --save-dev gulp"`, ...                                                                                 |
| export                          | This command will dump the database into a SQL file located at `mysql/dumps`. If there is a pre-existing `yourdatabasename.sql` file, it will rename it to `yourdatabasename.old.sql`.     |
| import                          | This command will drop the database, recreate it and then run the `yourdatabasename.sql` file.                                                                                             |
| shell                           | Connects through bash to the Apache container.                                                                                                                                             |
| shell-nginx                     | Connects through bash to the NGINX container.                                                                                                                                              |
| shell-mysql                     | Connects through bash to the MySQL container.                                                                                                                                              |
| mysql-cli                       | Opens the MySQL cli.                                                                                                                                                                       |
| tail                            | Displays the docker's logs of the Apache container.                                                                                                                                        |
| tail-e                          | Displays the error log of Apache.                                                                                                                                                          |
| tail-a                          | Displays the access log of Apache.                                                                                                                                                         |
| tail-nginx                      | Displays the docker's logs of the NGINX container.                                                                                                                                         |
| tail-mysql                      | Displays the docker's logs of the MySQL container.                                                                                                                                         |

# SSL support

In order to enable SSL, uncomment and update the following line in your `docker-compose.yml` file:

```
volumes:
  - ./nginx/nginx-custom.conf:/etc/nginx/conf.d/nginx_custom.conf:ro
  #- /the/path/to/certs:/etc/nginx/certs:ro
  - /var/run/docker.sock:/tmp/docker.sock:ro
```

You will find more information on how to make SSL work here: https://github.com/jwilder/nginx-proxy#ssl-support

Also, if you're using SSL Certificate Chains, we advise you to read the official NGINX documentation: https://www.nginx.com/resources/admin-guide/nginx-ssl-termination/#cert_chains

# Multiple environments on the same host

Let's say you need your testing and production environments to be on the same host.

Here is your current structure:

```
| testing.myproject
    | apache
    | ...
| www.myproject
    | apache
    | ...
```

You have two folders, one for your testing environment (`testing.myproject`) and another one for your production environment (`www.myproject`), each containing the source code of your project.

But the problem is that you can't use two `nginx-proxy` at the same time.

So just remove the `nginx-proxy` service in each `docker-compose.yml` files and create a new `docker-compose-nginx.yml` elsewhere containing:

```
version: '2'

services:

  nginx-proxy:
    image: jwilder/nginx-proxy
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./nginx-custom.conf:/etc/nginx/conf.d/nginx_custom.conf:ro
      - /the/path/to/certs:/etc/nginx/certs:ro
      - /var/run/docker.sock:/tmp/docker.sock:ro
    restart: unless-stopped
    container_name: nginx_proxy
    networks:
       - testing
       - prod

networks:
  testing:
    external:
      name: testingmyproject_testing
  prod:
    external:
      name: wwwmyproject_prod
```

**Note:** the name of an external network have to follow this format: `{projectfoldername}_{env}`. The `{env}` value must match the value specified in the considered `Makefile` and the `{projectfoldername}` value must match the project folder name without special characters, spaces, punctuations and so on.

You're structure now looks like this:

```
- nginx-custom.conf
- docker-composer-nginx.yml
| testing.myproject
    | apache
    | ...
| www.myproject
    | apache
    | ...
```

In order to make the proxy working, just run `docker-compose -f docker-compose-nginx.yml up -d`.

# Dive in

* [Use Xdebug with PhpStorm](docs/xdebug.md)
* [Use MySQL Workbench to manage your database](docs/mysql_workbench.md)
* [Use a Postfix container](docs/postfix.md)
* [Install Mouf framework](docs/mouf_framework.md) 

# Known issues

*A make command failed to run entirely*

Sometimes, you need to re-run a make command, especially the commands `make build`, `make kickoff`, `make composer cmd=install`, `make import`.

*docker-compose failed to parse my yaml file*

Make sure that you're file's indents are corrects!

*I've added a make command, but it's not working*

Make sure that your `Makefile` use tab indents! In PhpStorm, click on `Edit > Convert Indents > To Tabs`.

*My web application is not really fast while developing on MacOS*

Yep, this seems to be a current limitation of Docker on MacOS. But don't worry, it will be way faster on a Linux distribution (like your production server).