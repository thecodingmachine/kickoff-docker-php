[![PHP 7.0](https://img.shields.io/badge/PHP-7.0-green.svg)](apache/Dockerfile#L1)
[![Composer latest](https://img.shields.io/badge/Composer-latest-green.svg)](apache/Dockerfile#L21)
[![MySQL 5.7](https://img.shields.io/badge/MySQL-5.7-green.svg)](docker-compose.yml.template#L35)
[![Node.js 4.x](https://img.shields.io/badge/Node.js-4.x-orange.svg)](apache/Dockerfile#L29)
[![npm 2.x](https://img.shields.io/badge/npm-2.x-orange.svg)](apache/Dockerfile#L29)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

# Goal

This project will help you to start a PHP project with Docker, thanks to some useful make commands.

# Prerequisites

Install Docker (**>= 1.12**) for MacOSX / Linux following the official instructions: https://docs.docker.com/engine/installation

Install docker-compose (**>= 1.8.0**) for MacOSX / Linux following the official instructions: https://docs.docker.com/compose/install

**Important: for now, we do not recommend using Windows.**

# Quick start

**Important: make sure you're not using `root` user. Your current user must be a sudoer and be able to run docker commands.**

First, fork this project and clone it or download the tarball using:

```
curl -L https://github.com/thecodingmachine/kickoff-docker-php/archive/master.tar.gz > kickoff-docker-php.tar.gz
```

Once done, move to the root directory of this project and run:

```
cp .env.template .env
```

Now open the file located at `/etc/hosts` (on MacOS / Linux) and add the following line at the end of the file:

```
127.0.0.1   dev.yourproject.com
```
 
Good :smiley:? We're now done with the configuration! :metal:

Last but not least, shutdown your local Apache or anything which could use your 80 and 443 ports, and run:

```
make kickoff
```

The installation might take some time, so go for a coffee break! :coffee: 

Once everything has been installed, open your favorite web browser and copy / paste http://dev.yourproject.com and check if everything is OK!

# How does it work?

There are three important files:

* `.env.template` which contains environment variables with default values. These values should not be used directly, that's why you have to run `cp .env.template .env`.
* `docker-compose.yml.template` which contains the run configuration of the Apache and MySQL containers plus the environment variables defined in `.env.template`.
* `docker-compose-nginx.yml.template` which contains the run configuration of the NGINX container plus the environment variables defined in `.env.template`.

The command `make kickoff` will create the `docker-compose.yml` and `docker-compose-nginx.yml` files using the environment variables' values defined in the `.env` file.

For security concern, these three files are not versioned, because they contain sensible data like the MySQL database password and so on.

# Make commands

| Command                         | Description                                                                                                                                                                                        |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| prepare                         | Creates the `docker-compose.yml` and `docker-compose-nginx.yml` files using the environment variables specified in the `.env` file.                                                                |
| build                           | Builds the Apache container.                                                                                                                                                                       |
| down                            | Stops the Apache and MySQL containers, deletes their network and cleans the docker cache.                                                                                                          |
| up                              | Ups the Apache and MySQL containers.                                                                                                                                                               |
| nginx-down                      | Stops the NGINX container and deletes its network.                                                                                                                                                 |
| nginx-up                        | Ups the NGINX container.                                                                                                                                                                           |
| kickoff                         | Combo of down, prepare, build, nginx-up and up commands.                                                                                                                                           |
| composer cmd=*yourcommand*      | Allows you to run a composer command. Ex: `make composer cmd=install`, `make composer cmd=update`, ...                                                                                             |
| npm cmd=*yourcommand*           | Allows you to run a npm command. Ex: `make npm cmd=install`, `make npm cmd="install --save-dev gulp"`, ...                                                                                         |
| export                          | This command will dump the database into a SQL file located at `mysql/dumps`. If there is a pre-existing `yourdatabasename.sql` file, it will rename it to `yourdatabasename.Y-m-d:H:M:S.sql`.     |
| import                          | This command will drop the database, recreate it and then run the `yourdatabasename.sql` file.                                                                                                     |
| shell                           | Connects through bash to the Apache container.                                                                                                                                                     |
| shell-nginx                     | Connects through bash to the NGINX container.                                                                                                                                                      |
| shell-mysql                     | Connects through bash to the MySQL container.                                                                                                                                                      |
| mysql-cli                       | Opens the MySQL cli.                                                                                                                                                                               |
| tail                            | Displays the docker's logs of the Apache container.                                                                                                                                                |
| tail-nginx                      | Displays the docker's logs of the NGINX container.                                                                                                                                                 |
| tail-mysql                      | Displays the docker's logs of the MySQL container.                                                                                                                                                 |

# Xdebug support

Open your `.env` file in your favorite editor, set the variable `WITH_XDEBUG=1` and run `make kickoff`. 

It will enable Xdebug on the apache container, but we recommend to enable it only for your development environment!

# SSL support

Open your `.env` file in your favorite editor, set the variable `WITH_SSL=1` and run `make kickoff`. 

It will enable SSL on the NGINX container. Make sure that you have defined the correct path to your certifications in `CERTS_PATH`!

You will find more information on how to make SSL work here: https://github.com/jwilder/nginx-proxy#ssl-support

If you're using SSL Certificate Chains, we advise you to read the official NGINX documentation: https://www.nginx.com/resources/admin-guide/nginx-ssl-termination/#cert_chains

# Multiple environments on the same host

As you long as each `PROXY_NAME` variables in your `.env` files have the same value, you are able to run as many environments as you need. 

Make sure that you have defined a different `APACHE_VIRTUAL_HOST` value for your Apache containers.

# Dive in

* [Use Xdebug with PhpStorm](docs/xdebug.md)
* [Use MySQL Workbench to manage your database](docs/mysql_workbench.md)
* [Install a Postfix container](docs/postfix.md)
* [Install Gulp](docs/gulp.md)
* [Install Mouf framework](docs/mouf_framework.md) 

# Known issues

*A make command failed to run entirely*

Sometimes, you need to re-run a make command, especially the commands `make build`, `make kickoff`, `make composer cmd=install`, `make import`.

*docker-compose failed to parse my yaml file*

Make sure that your file's indents are corrects!

*I've added a make command, but it's not working*

Make sure that your `Makefile` uses tab indents! In PhpStorm, click on `Edit > Convert Indents > To Tabs`.

*My web application is not really fast while developing on MacOS*

Yep, this seems to be a current limitation of Docker on MacOS. But don't worry, it will be way faster on a Linux distribution (like your production server).