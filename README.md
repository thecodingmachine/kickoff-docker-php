<p align="center">
    <img src="https://user-images.githubusercontent.com/8983173/28176182-c45b1196-67f6-11e7-8d96-fd1aefd3fcab.png" alt="kickoff-docker-php's logo" width="200" height="200" />
</p>
<h3 align="center">kickoff-docker-php</h3>
<p align="center">A complete stack for your PHP project powered by Docker</p>
<p align="center">
    <a href="https://github.com/thecodingmachine/kickoff-docker-php/tree/master"><img src="https://img.shields.io/badge/beta-2.0-yellow.svg" alt="Beta release: 2.0"></a>
    <a href="https://github.com/thecodingmachine/kickoff-docker-php/tree/v1.0.3"><img src="https://img.shields.io/badge/stable-1.0.3-green.svg" alt="Stable release: 1.0.3"></a>
</p>

---

This project started with a bunch of shell-script files and a simpler stack (Apache, MySQL, NGINX as a reverse-proxy). 
As we needed a cross-platform solution to kickoff our PHP projects under Docker, I've worked on a tool ([Orbit](https://github.com/gulien/orbit))
to replace my Makefile and the shell-script files. 

The current version is the result of these efforts. As it does not aim to be the ultimate solution for powering PHP applications
under Docker, it provides a lot of nice features as shown below :smile:.
 
If you're interested, you can still take a look at the [first version](https://github.com/thecodingmachine/kickoff-docker-php/tree/v1.0.3)!

# Menu

* [Features](#features)
* [Philosophy](#philosophy)
* [Install](#install)
* [Quick start](#quick-start)
* [How does it works?](#how-does-it-works)
* [Dive in](#dive-in)
* [Contributing](#contributing)
* [Credits](#credits)

## Features

* **Cross-platform:** Windows, Mac, Linux
* **A complete stack:** NGINX, PHP-FPM 7.1, MySQL 5.7, phpMyAdmin, Redis, RabbitMQ and more
* **Centralized logging** with Graylog
* Automatic **HTTPS** on your local environment
* A powerful **reverse-proy** ([Traefik](https://traefik.io/)) which can handle automatic HTTPS (via [Let's Encrypt](https://letsencrypt.org/))
on your production environment
* **Performance gains** on Mac and Windows using [Docker Sync](http://docker-sync.io/) or Docker for Mac's user-guided cache
* **Customizable** thanks to [Orbit](https://github.com/gulien/orbit)

And more to come! :smiley:

## Philosophy

In our opinion, each project should have its own technical environment and our local environment should be as close
as possible to our distant environment to avoid unpleasant surprise while deploying our applications.

We're working on a lof of projects at [TheCodingMachine](https://www.thecodingmachine.com/) and we usually have to switch
from one project to another. Before Docker, this means that we also had to switch our entire stack like the PHP version, 
install a new service like RabbitMQ and so on. It was quite a waste of time.

Still, even if Docker is not that hard to understand and configure, there was a gap to fulfill to make it **really easy**
to use. That's why we started to work on *kickoff-docker-php*.

### TL;DR

* One project = one technical environment
* A local environment as close as possible to your distant environment
* Switching quickly between your projects
* Easy to use

## Install

Download and install [Docker](https://docs.docker.com/engine/installation/) (**>= 17.06**) for your platform.

**Note:** This project won't work using the legacy desktop solution, aka *Docker Toolbox*.

On Linux, you also have to install [Docker compose](https://docs.docker.com/compose/install/) (**>= 1.14.0**) as it does not
come with by default. Also add your current user to the `docker` group and don't forget to logout/login from your current 
session.

Then download and install [Orbit](https://github.com/gulien/orbit), a tool for generating files from templates and 
running commands.

You may now fork this project and clone it or download the latest release from the [releases page](../../releases).

### Optional install for performance gains with Docker Sync (Mac and Windows)

Download and install the latest release of [Docker Sync](http://docker-sync.io/).

**Note:** On Windows, it only works with Windows Subsystem for Linux.

## Quick start

Once you've downloaded this project, move to the root directory of this project and copy the file `.env.blueprint` and paste it to a file
named `.env`.

| Linux/Mac                	| Windows                    	|
|--------------------------	|----------------------------	|
| `cp .env.blueprint .env` 	| `copy .env.blueprint .env` 	|

**Note:** If you wish to enable *Docker Sync*, don't forget to set `ENABLE_DOCKER_SYNC` to `true` in your `.env` file.

Now open your hosts file...
 
| Linux/Mac              | Windows                                                                                             |
|------------------------|-----------------------------------------------------------------------------------------------------|
| `sudo nano /etc/hosts` | Run Notepad as administrator and open the file located at `C:\Windows\System32\drivers\etc\hosts`   |
 
...and add the following lines at the end of the file:

```
127.0.0.1   my-awesome-project.local
127.0.0.1   www.my-awesome-project.local
127.0.0.1   traefik.my-awesome-project.local
127.0.0.1   phpadmin.my-awesome-project.local
127.0.0.1   rabbitmq.my-awesome-project.local
127.0.0.1   graylog.my-awesome-project.local
```
 
Good :smiley:? We're now done with the configuration! :metal:

Last but not least, **shutdown your local Apache or anything which could use your 80 and 443 ports**, and run:

```
orbit run kickoff
```

The installation might take some time, so go for a coffee break! :coffee: 

Once everything has been installed, open your favorite web browser and copy / paste https://www.my-awesome-project.local 
and check if everything is OK!

## How does it works?

This project is mainly composed of templates (`*.blueprint.*`) which will be used to generate files thanks to [Orbit](https://github.com/gulien/orbit)
and values provided by `kickoff.yml` and `.env` configuration files.

### Project structure

```
├── .docker # Docker and kickoff related files
│   ├── .bin            # internal scripts
│   ├── .misc           # files which print a nice rocket
│   ├── .orbit          # Orbit sub configuration files
│   ├── graylog         # Graylog related configuration files
│   ├── mysql           # MySQL related configuration files
│   ├── nginx           # NGINX related configuration files
│   ├── php-fpm         # PHP-FPM related configuration files
│   ├── toolbox         # Toolbox related configuration files and the Toolbox's generated files
│   └── traefik         # Traefik related configuration files
└── app # The source code of your PHP application
```

**Tip:** Your `app` folder should be a git submodule.

### Configuration files

| File          | Description                                    |
|---------------|------------------------------------------------|
| `kickoff.yml` | Contains data like the MySQL user and so on.   |
| `.env`        | Contains all sensitive data like passwords.    |
| `orbit.yml`   | Contains the Orbit's commands of this project. |

Don't hesitate to take a look at those files, as they are provided with nice comments!

### Main Orbit's commands

| Command              | Description                                                                                                             |
|----------------------|-------------------------------------------------------------------------------------------------------------------------|
| `orbit run kickoff`  | Generates all configuration files, builds the containers and starts them.                                               |
| `orbit run shutdown` | Stops all the containers.                                                                                               |
| `orbit run toolbox`  | Connects through ash to the toolbox container. This is where you're able to run `composer`, `npm` and  `yarn` commands. |

## Dive in

### Toolbox

The Toolbox is a container which has many roles. Its PHP configuration is identical to the PHP-FPM configuration, but it also
adds Composer and NodeJS. We provided a simple command to connect to it: `orbit run toolbox`.

Once you're in the container, you're able to install your PHP dependencies with `composer` and install your frontend dependencies
with `yarn`.

It also generates useful files:

* The self-signed certificate on your local environment
* The .htdigest file for authentication to the Traefik dashboard on environments <> `local`
* The SHA2 password and secret pepper for Graylog authentication

Last but not least, it checks that your Graylog is ready to receive logs from others containers.

#### Configuration

| Variable                 | Location | Description                                                               |
|--------------------------|----------|---------------------------------------------------------------------------|
| ENABLE_DOCKER_SYNC       | `.env`   | If true, enable Docker Sync to fix performance issues on Mac and Windows. |
| TOOLBOX_PHP_MEMORY_LIMIT | `.env`   | Sets the PHP CLI memory limit.                                            |

#### Commands

| Command                   | Description                                                                                                                                         |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `orbit run toolbox-build` | Generates the Toolbox container configuration files and builds it. If `ENABLE_DOCKER_SYNC=true`, also generates the Docker Sync configuration file. |
| `orbit run toolbox-up`    | Starts the Toolbox container. It should be the first to start.                                                                                      |
| `orbit run toolbox-down`  | Stops the Toolbox container. It should be the last to stop.                                                                                         |
| `orbit run toolbox`       | Connects through ash to the Toolbox container.                                                                                                      |

### Traefik (reverse-proxy)

The [Traefik](https://traefik.io/) container is used as a reverse-proxy: it's the entry door which will redirect clients requests
to the correct frontend.

It provides a nice dashboard (https://traefik.my-awesome-project.local/) which requires an authentication on environments <> `local`.

#### Configuration

| Variable          | Location      | Description                                                                                            |
|-------------------|---------------|--------------------------------------------------------------------------------------------------------|
| traefik.user      | `kickoff.yml` | The Traefik user used for generating the .htdigest file. Only required for environments <> `local`.    |
| TRAEFIK_LOG_LEVEL | `.env`        | Defines the log level of the Traefik container.                                                        |
| TRAEFIK_PASSWORD  | `.env`        | The password of the user defined in the `kickoff.yml` file. Only required for environments <> `local`. |

#### Commands

| Command                 | Description                                                                       |
|-------------------------|-----------------------------------------------------------------------------------|
| `orbit run proxy-build` | Generates the Traefik container configuration files.                              |
| `orbit run proxy-up`    | Starts the Traefik container. It should be start after the Toolbox container.     |
| `orbit run proxy-down`  | Stops the Traefik container. It should be stop just before the Toolbox container. |

### Graylog

The [Graylog](https://www.graylog.org/) containers centralize the Docker's logs of the NGINX, PHP-FPM, MySQL, phpMyAdmin, Redis and RabbitMQ
containers. It's actually composed of three containers: Elasticsearch, MongoDB and the Graylog server.

You may access to the Graylog dashboard (https://graylog.my-awesome-project.local/) using the credentials provided in your configuration files.

#### Configuration

| Variable                 | Location      | Description                                                 |
|--------------------------|---------------|-------------------------------------------------------------|
| graylog.user             | `kickoff.yml` | The Graylog root user.                                      |
| GRAYLOG_PASSWORD         | `.env`        | The password of the user defined in the `kickoff.yml` file. |
| GRAYLOG_SERVER_JAVA_OPTS | `.env`        | The Java options for the Graylog server.                    |
| GRAYLOG_ES_JAVA_OPTS     | `.env`        | The Java options for Elasticsearch.                         |

#### Commands

| Command                   | Description                                                                          |
|---------------------------|--------------------------------------------------------------------------------------|
| `orbit run graylog-build` | Generates the Graylog containers configuration files.                                |
| `orbit run graylog-up`    | Starts the Graylog containers. They should be start after the Traefik container.     |
| `orbit run graylog-down`  | Stops the Graylog containers. They should be stop just before the Traefik container. |

---

The following containers compose the main services of your PHP application.

#### Commands

| Command           | Description                                                                                                                                                      |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `orbit run build` | Generates the configuration files of your services and builds the NGINX and PHP-FPM containers.                                                                  |
| `orbit run up`    | Starts the NGINX, PHP-FPM, MySQL, Redis and RabbitMQ containers. On `local` environment, also starts the phpMyAdmin container. They should be the last to start. |
| `orbit run down`  | Stops the NGINX, PHP-FPM, MySQL, Redis and RabbitMQ containers. On `local` environment, also stops the phpMyAdmin container. They should be the first to stop.   |

### NGINX with PHP-FPM

The NGINX and PHP-FPM containers works together; indeed, the first will ask PHP-FPM to run our PHP files.

The NGINX configuration located at `.docker/nginx/conf.d/php-fpm.conf` provides good security defaults. Still, you might 
have to update it according to the PHP framework you wish to use.

Your PHP application will be accessible under https://my-awesome-project.local/ and https://www.my-awesome-project.local/.

**Note:** on `local` environment, you're also able to use Xdebug.

#### Configuration

| Variable             | Location | Description                                     |
|----------------------|----------|-------------------------------------------------|
| PHP_FPM_MEMORY_LIMIT | `.env`   | Sets both the PHP CLI and PHP-FPM memory limit. |

### MySQL

The MySQL container is the DBMS of this stack.

In your PHP-FPM container, the hostname of the MySQL DBMS is equal to `mysql`. Also, just use the port `3306` and the
credentials defined in the `kickoff.yml` and `.env` files.

There are also three ways to manage MySQL:

* On `local` environment, you may access to the phpMyAdmin dashboard (https://phpadmin.my-awesome-project.local/); you will
automatically be connected as `root`
* By running `orbit run mysql-cli`: it will open the MySQL cli and connect you as `root` (on environments <> `local`, it will ask 
you the MySQL root password)
* By mapping the container's port `3306` to a host port, you are able to use a more powerful tool like MySQL Workbench using
`127.0.0.1` as host and the port defined in the variable `MYSQL_HOST_PORT_TO_MAP` in your `.env` file

#### Configuration

| Variable                   | Location      | Description                                                                                                                                                                               |
|----------------------------|---------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| mysql.user                 | `kickoff.yml` | The MySQL user of your PHP application.                                                                                                                                                   |
| mysql.databases            | `kickoff.yml` | List of the databases of your PHP application. If they do not exist, they will be created when the MySQL container starts. The previous user will have all privileges on these databases. |
| MYSQL_PASSWORD             | `.env`        | The password of the user defined in the `kickoff.yml` file.                                                                                                                               |
| MYSQL_ROOT_PASSWORD        | `.env`        | The MySQL root password.                                                                                                                                                                  |
| MYSQL_ENABLE_PORTS_MAPPING | `.env`        | If true, it will map the port `3306` of the MySQL container with the host port defined below.                                                                                             |
| MYSQL_HOST_PORT_TO_MAP     | `.env`        | The host port to map.                                                                                                                                                                     |

#### Commands

| Command               | Description                                                                                         |
|-----------------------|-----------------------------------------------------------------------------------------------------|
| `orbit run mysql-cli` | Opens the MySQL cli as `root`. On environments <> `local`, it will ask you the MySQL root password. |

### Redis

Redis is the database cache of this stack and it has been configured as the default session handler for PHP.

The hostname of Redis in your PHP-FPM container is equal to `redis`. To configure Redis to be the cache handler of your PHP
application, you should refer to the documentation provided by your PHP framework.

**Note:** you should not use [predis](https://github.com/nrk/predis), as [phpredis](https://github.com/phpredis/phpredis) 
is installed by default.

#### Configuration

| Variable       | Location | Description                                |
|----------------|----------|--------------------------------------------|
| REDIS_PASSWORD | `.env`   | The auth used to access to the Redis DBMS. |

### RabbitMQ

RabbitMQ is the message broker of this stack.

The hostname of RabbitMQ in your PHP-FPM container is equal to `rabbitmq`. To configure RabbitMQ to be the message broker of 
your PHP application, you should refer to the documentation provided by your PHP framework.

You may access to the RabbitMQ dashboard (https://rabbitmq.my-awesome-project.local/) using the credentials provided in your configuration files.

#### Configuration

| Variable          | Location      | Description                                                 |
|-------------------|---------------|-------------------------------------------------------------|
| rabbitmq.user     | `kickoff.yml` | The RabbitMQ user of your PHP application.                  |
| RABBITMQ_PASSWORD | `.env`        | The password of the user defined in the `kickoff.yml` file. |

## Contributing

Please read our [contributing guidelines](.github/CONTRIBUTING.md) for instructions.

If you've found a security vulnerability, please e-mail directly: j dot neuhart dot thecodingmachine dot com.
Provide enough information to verify the bug and make a patch!

## Credits

* NGINX and PHP-FPM configuration files from [Cerenit](https://code.cerenit.fr/cerenit/docker-grav)
* MySQL utf8mb4 encoding from [this blog article](https://mathiasbynens.be/notes/mysql-utf8mb4)
* Icon by Nikita Kozin from the Noun Project

---

Would you like to update this documentation ? Feel free to open an [issue](../../issues).
