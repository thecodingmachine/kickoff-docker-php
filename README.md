[![PHP 7.0](https://img.shields.io/badge/PHP-7.1-green.svg)](apache/Dockerfile#L1)
[![Composer latest](https://img.shields.io/badge/Composer-latest-green.svg)](apache/Dockerfile#6)
[![MySQL 5.7](https://img.shields.io/badge/MySQL-5.7-green.svg)](docker-compose.yml.template#L23)
[![Node.js 4.x](https://img.shields.io/badge/Node.js-6.9-green.svg)](apache/Dockerfile#L9)
[![npm 2.x](https://img.shields.io/badge/npm-3.10-green.svg)](apache/Dockerfile#L9)
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
* `docker-compose.yml.template` which contains the run configuration of the Apache and MySQL containers plus some of the environment variables defined in `.env.template`.
* `docker-compose-nginx.yml.template` which contains the run configuration of the NGINX container plus some of the environment variables defined in `.env.template`.

The command `make prepare` will create the `docker-compose.yml` and `docker-compose-nginx.yml` files using the environment variables' values defined in the `.env` file.

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
| export                          | This command will dump the database into two SQL files located at `mysql/dumps`. The files will be named as `yourdatabasename.sql` and `yourdatabasename.Y-m-d:H:M:S.sql`.                         |
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

It will enable Xdebug on the Apache container. Use it only for your development environment!

# SSL support

Open your `.env` file in your favorite editor, set the variable `WITH_SSL=1` and run `make kickoff`. 

It will enable SSL on the NGINX container. Make sure that you have defined the correct path to your certifications in `CERTS_PATH`!

You will find more information on how to make SSL work here: https://github.com/jwilder/nginx-proxy#ssl-support

If you're using SSL Certificate Chains, we advise you to read the official NGINX documentation: https://www.nginx.com/resources/admin-guide/nginx-ssl-termination/#cert_chains

# Multiple environments on the same host

As you long as each `PROXY_NAME` variables in your `.env` files have the same value, you are able to run as many environments as you need. 

Make sure that you have defined a different `APACHE_VIRTUAL_HOST` value for each of your Apache containers.

Also, use only letters (no whitespaces, special characters and so on) for the `PROXY_NAME` variable's value!

# Dive in

* [Use Xdebug with PhpStorm](docs/xdebug.md)
* [Use MySQL Workbench to manage your database](docs/mysql_workbench.md)
* [Install a Postfix container](docs/postfix.md)
* [Install Gulp](docs/gulp.md)
* [Install Mouf framework](docs/mouf_framework.md) 

# Known issues

**Should I use this in production?**

This project aims to help you starting a PHP development environment on Docker. As the `www-data` apache container user shares the same `uid` as your current user, we do not recommend using this project for your production environment.

**docker-compose failed to parse my yaml file**

Make sure that your file's indents are corrects!

**I've added a make command, but it's not working**

Make sure that your `Makefile` uses tab indents! In PhpStorm, click on `Edit > Convert Indents > To Tabs`.

**My web application is not really fast on MacOS**

Yep, this seems to be a current limitation of Docker on MacOS (see [#8076](https://forums.docker.com/t/file-access-in-mounted-volumes-extremely-slow-cpu-bound/8076)).

**Xdebug is not working on MacOS**

* If you have php-fpm installed on your machine, the port 9000 might already be used. You have to change the `xdebug.remote_port` variable's value with `1000` and updates your IDE configuration for Xdebug.
* Add the `xdebug.idekey` variable with your corresponding value in the `ext-xdebug.ini` file. You might also have to update the `xdebug.remote_host` variable's value with the IP address of your container (`docker inspect YOUR_APACHE_CONTAINER_NAME`).
