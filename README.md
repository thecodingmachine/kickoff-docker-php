<div align="center">
<img src="./logo.png" alt="kickoff-docker-php logo" width="200" height="200" />
</div>

<h1 align="center">kickoff-docker-php</h1>

<div align="center">
<img src="https://img.shields.io/badge/PHP-7.1-green.svg" alt="PHP 7.1">
<img src="https://img.shields.io/badge/Composer-latest-green.svg" alt="Composer latest">
<img src="https://img.shields.io/badge/MySQL-5.7-green.svg" alt="MySQL 5.7">
<img src="https://img.shields.io/badge/Node.js-6.9-green.svg" alt="Node.js 6.9">
<img src="https://img.shields.io/badge/npm-3.10-green.svg" alt="npm 3.10">
<img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License MIT">
</div>

<br>

This project will help you to setup a **PHP project with Docker**, thanks to some useful make commands.

Think of it as a starter kit and update it at your convenience.

## Prerequisites

Docker (**>= 1.12**) for MacOS / Linux: https://docs.docker.com/engine/installation

Docker Compose (**>= 1.8.0**) for MacOS / Linux: https://docs.docker.com/compose/install

## Quick start

**Important for Linux users:** make sure you're not using `root` user. Your current user must be part of `sudo` and `docker` groups.

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

**Note:** Make sure that your domain name matches the `APACHE_VIRTUAL_HOST` variable's value located in the `.env` file.
 
Good :smiley:? We're now done with the configuration! :metal:

Last but not least, **shutdown your local Apache or anything which could use your 80 and 443 ports**, and run:

```
make kickoff
```

The installation might take some time, so go for a coffee break! :coffee: 

Once everything has been installed, open your favorite web browser and copy / paste http://dev.yourproject.com and check if everything is OK!

## Make commands

| Command                         | Description                                                                                                                                                                                        |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| prepare                         | Creates the `docker-compose.yml` and `docker-compose-reverse-proxy.yml` files using the variables's values specified in the `.env` file.                                                           |
| build                           | Builds the Apache container.                                                                                                                                                                       |
| down                            | Stops the Apache and MySQL containers, deletes their network and cleans the docker cache.                                                                                                          |
| up                              | Ups the Apache and MySQL containers.                                                                                                                                                               |
| proxy-down                      | Stops the reverse proxy container and deletes its network.                                                                                                                                         |
| proxy-up                        | Ups the reverse proxy container.                                                                                                                                                                   |
| kickoff                         | Combo of down, prepare, build, proxy-up and up commands.                                                                                                                                           |
| composer cmd=*yourcommand*      | Allows you to run a composer command. Ex: `make composer cmd=install`, `make composer cmd=update`, ...                                                                                             |
| npm cmd=*yourcommand*           | Allows you to run a npm command. Ex: `make npm cmd=install`, `make npm cmd="install --save-dev gulp"`, ...                                                                                         |
| export                          | This command will dump the database into two SQL files located at `mysql/dumps`. The files will be named as `yourdatabasename.sql` and `yourdatabasename.Y-m-d:H:M:S.sql`.                         |
| import                          | This command will drop the database, recreate it and then run the `yourdatabasename.sql` file.                                                                                                     |
| shell                           | Connects through bash to the Apache container.                                                                                                                                                     |
| shell-proxy                     | Connects through bash to the reverse proxy container.                                                                                                                                              |
| shell-mysql                     | Connects through bash to the MySQL container.                                                                                                                                                      |
| mysql-cli                       | Opens the MySQL cli.                                                                                                                                                                               |
| tail                            | Displays the Docker's logs of the Apache container.                                                                                                                                                |
| tail-proxy                      | Displays the Docker's logs of the reverse proxy container.                                                                                                                                         |
| tail-mysql                      | Displays the Docker's logs of the MySQL container.                                                                                                                                                 |

## Dive in

### How does it work?

There are three important files:

* `.env.template` which contains variables with default values.
* `docker-compose.yml.template` which contains the run configuration of the Apache and MySQL containers plus some of the variables defined in `.env.template`.
* `docker-compose-reverse-proxy.yml.template` which contains the run configuration of the reverse proxy container plus some of the variables defined in `.env.template`.

As these files are templates, they are not used directly. That's why you have to:

* run `cp .env.template .env` and update the variables' values in the `.env` file at your convenience.
* run `make kickoff` which runs `make prepare`: this command creates the `docker-compose.yml` and `docker-compose-reverse-proxy.yml` files using the variables' values defined in the `.env` file.

For security concern, these three files have been added in the `.gitignore` file as they contain sensible data like the MySQL database password and so on.

### Project structure

This project will run three containers:

1. A reverse proxy using the well-known [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) image.
2. An Apache container with PHP 7.1 (and core PHP libraries), Composer (for managing your PHP dependencies), Node.js and npm (for managing your frontend dependencies).
3. A MySQL container using MySQL 5.7.

<p align="center">
<img src="docs/images/readme1.png" alt="Containers and project structure" />
</p>

* The `apache/volume` folder is where your source code must be located. It is mapped with the `/var/www/html` folder on the Apache container.
* The `mysql/volume` has been created by the MySQL container. It is where your database is persisted on the host.

### Link your PHP application to your MySQL database

It is actually quite simple. In your Apache container, the hostname of the MySQL database is equal to the variable's value `MYSQL_SERVICE_NAME` defined in the `.env` file. Also, just use the port `3306` and the credentials defined in the `.env` file. 

### Manage your database

The simplest way is to access directly to the MySQL cli using `make mysql-cli`.

If you want to manage your database with a more powerful tool (like MySQL Workbench), open your `.env` file in your favorite editor, set the variable `MYSQL_ENABLE_PORTS_MAPPING=1`, update if needed the variable `MYSQL_HOST_PORT_TO_MAP` and finally run `make kickoff`.

You are now able to access on your host to your MySQL database using `127.0.0.1` and the port defined in the variable `MYSQL_HOST_PORT_TO_MAP`. See also: [Use MySQL Workbench to manage your database](docs/mysql_workbench.md)

### Xdebug support

Open your `.env` file in your favorite editor, set the variable `APACHE_ENABLE_XDEBUG=1` and run `make kickoff`. 

It will enable Xdebug on the Apache container. See also: [Use Xdebug with PhpStorm](docs/xdebug.md)

### SSL support

Open your `.env` file in your favorite editor, set the variable `REVERSE_PROXY_ENABLE_SSL=1` and run `make kickoff`. 

It will enable SSL on the reverse proxy container. Make sure that you have defined the correct path to your certifications in `REVERSE_PROXY_CERTS_PATH`!

You will find more information on how to make SSL work here: https://github.com/jwilder/nginx-proxy#ssl-support

If you're using SSL Certificate Chains, we advise you to read the official NGINX documentation: https://www.nginx.com/resources/admin-guide/nginx-ssl-termination/#cert_chains

### Multiple environments/projects on the same host

As you long as each `REVERSE_PROXY_NAME` and `REVERSE_PROXY_NETWORK` variables in your `.env` files have the same values, you are able to run as many environments/projects as you need. 

Make sure that you have defined a different `APACHE_VIRTUAL_HOST` value for each of your Apache containers.

### Install more PHP extensions

Open the `Dockerfile` located in the `apache` folder and [follow the official instructions](https://github.com/docker-library/docs/tree/master/php#how-to-install-more-php-extensions).

Once done, run `make kickoff` to rebuild your Apache container.

## Candies

* [Install a Postfix container](docs/postfix.md)
* [Install Gulp](docs/gulp.md)
* [Install Mouf framework](docs/mouf_framework.md) 

## FAQ / Known issues

**Should I use this in production?**

This project aims to help you starting a PHP development environment on Docker. As the `www-data` user in the Apache container shares the same `uid` as your current user, we do not recommend using this project for your production environment.

**I've added a make command, but it's not working**

Make sure that your `Makefile` uses tab indents! In PhpStorm, click on `Edit > Convert Indents > To Tabs`.

**My web application is not really fast on MacOS**

Yep, this seems to be a current limitation of Docker on MacOS (see [#8076](https://forums.docker.com/t/file-access-in-mounted-volumes-extremely-slow-cpu-bound/8076)).

**Xdebug is not working on MacOS**

You have to update the `xdebug.remote_host` variable's value with your IP address.

## Credits

* Icon by Nikita Kozin from the Noun Project
