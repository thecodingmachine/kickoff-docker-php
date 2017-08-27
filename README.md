<p align="center">
    <img src="https://user-images.githubusercontent.com/8983173/29215277-a47c1e5e-7eaa-11e7-9b4b-9305a9f1661c.png" alt="kickoff-docker-php's logo" width="150" height="150" />
</p>
<h3 align="center">kickoff-docker-php</h3>
<p align="center">A complete stack for your PHP project powered by Docker</p>
<p align="center">
    <a href="https://github.com/thecodingmachine/kickoff-docker-php/tree/v2.0.0"><img src="https://img.shields.io/badge/stable-v2.0.0-green.svg" alt="Stable release: v2.0.0"></a>
    <a href="https://github.com/thecodingmachine/kickoff-docker-php/tree/master"><img src="https://img.shields.io/badge/unstable-master-orange.svg" alt="Unstable release: master"></a>
    <a href="https://travis-ci.org/thecodingmachine/kickoff-docker-php"><img src="https://img.shields.io/travis/thecodingmachine/kickoff-docker-php.svg?label=Travis+CI" alt="Travis CI"></a>
</p>

---

We're working on a lof of projects at [TheCodingMachine](https://www.thecodingmachine.com/) and we needed a tool to 
easily start a PHP project with Docker. That's why we started working on the *kickoff-docker-php* stack with the
following goals in mind:

* One project = one technical environment
* A `local` environment as close as possible to our distant environment
* Switching quickly between our projects
* Easy to use

# Menu

* [Features](#features)
* [Install](#install)
* [Quick start](#quick-start)
* [Orbit commands](#orbit-commands)
* [Project structure](#project-structure)
* [Configuration](#configuration)
* [Modules](#modules)
* [Advanced](#advanced)
* [Contributing](#contributing)
* [Credits](#credits)

## Features

* **Cross-platform:** Windows, Mac, Linux
* **A complete stack:** NGINX, PHP-FPM 7.1, MySQL 5.7, phpMyAdmin, Redis, RabbitMQ and more to come!
* **Centralized logging** with Graylog
* Automatic **HTTPS** on your local environment
* A powerful **reverse-proy** ([Traefik](https://traefik.io/)) which can handle automatic HTTPS (via [Let's Encrypt](https://letsencrypt.org/))
on your production environment
* **Performance gains** on Mac and Windows using [Docker Sync](http://docker-sync.io/) or Docker for Mac's user-guided cache
* **Lightweight** images, mostly based on Alpine
* **Easily configurable:** disable the modules you don't need, set your own users and so on!
* **Customizable** thanks to [Orbit](https://github.com/gulien/orbit)

And more! :smiley:

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

**Note:** On Windows, it only works with *Windows Subsystem for Linux*.

## Quick start

Once you've downloaded this project, move to the `config` folder and copy the file `.env.blueprint` and paste it to a file
named `.env`.

| Linux/Mac                	| Windows                    	|
|--------------------------	|----------------------------	|
| `cp .env.blueprint .env` 	| `copy .env.blueprint .env` 	|

**Note:** If you wish to enable Docker Sync, don't forget to set `ENABLE_DOCKER_SYNC` to `true` in your `.env` file.

In the same folder, open the file `project.yml` and set the following variables:

* `virtualhost.local` with your own virtual host
* `name` with your project name

Now open your `hosts` file...
 
| Linux/Mac              | Windows                                                                                             |
|------------------------|-----------------------------------------------------------------------------------------------------|
| `sudo nano /etc/hosts` | Run Notepad as administrator and open the file located at `C:\Windows\System32\drivers\etc\hosts`   |
 
...and add the following lines at the end of the file:

```
127.0.0.1   your-virtualhost.local
127.0.0.1   www.your-virtualhost.local
127.0.0.1   traefik.your-virtualhost.local
127.0.0.1   phpadmin.your-virtualhost.local
127.0.0.1   rabbitmq.your-virtualhost.local
127.0.0.1   graylog.your-virtualhost.local
```

**Tip:** Don't want to update your `hosts` file? Set `virtualhost.local` with `your-virtualhost.127.0.0.1.xip.io` 
in your `project.yml` file. Your applications will be available under `*.your-virtualhost.127.0.0.1.xip.io/`!
 
Good :smiley:? We're now done with the configuration! :metal:

Last but not least, move to the root directory, **shutdown your local Apache or anything which could use your 80 
and 443 ports**, and run:

```
orbit run kickoff
```

The installation might take some time, so go for a coffee break! :coffee: 

Once everything has been installed, open your favorite web browser and copy / paste https://www.your-virtualhost.local 
and check if everything is OK!

## Orbit commands

| Command                | description                                                                                                                                              |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `orbit run kickoff`    | Generates all configuration files, builds the NGINX and PHP-FPM images and starts the containers. It's a combo of `build`, `proxy-up` and `up` commands. |
| `orbit run shutdown`   | Stops all containers. It's a combo of  `down` and `proxy-down` commands.                                                                                 |
| `orbit run build`      | Generates all configuration files and builds the NGINX and PHP-FPM images.                                                                               |
| `orbit run proxy-up`   | Starts the Traefik container.                                                                                                                            |
| `orbit run up`         | Starts all containers without the Traefik container.                                                                                                     |
| `orbit run proxy-down` | Stops the Traefik container.                                                                                                                             |
| `orbit run down`       | Stops all containers without the Traefik container.                                                                                                      |
| `orbit run workspace`  | Connects through ash to the PHP-FPM container. This is where you're able to run useful commands like `composer` and `yarn`.                              |
| `orbit run mysql-cli`  | Opens the MySQL cli as `root`. On environments <> `local`, it will ask you the MySQL `root` password.                                                    |

## Project structure

```
├── config  # Kickoff related configuration files
├── modules # Modules related configuration files
└── app     # The source code of your PHP application
```

Only the configuration files of your modules and the application source code are directly mounted in the containers.
The data of modules like MySQL are stored inside named volumes. You can see those named volumes by running 
`docker volume ls` command. They are named using the project name, your current environment and the considered module.
If you want to locate those volumes on the host, run  `docker inspect {volume name}` command.

**Note:** For now, the credentials will only be set the first time the Graylog, MySQL, RabbitMQ containers are launched. 
If you want to update them after, use the considered dashboard. You could also delete the named volumes, but proceed with 
caution: it will delete all your data.

**Tip:** Your `app` folder should be a git submodule.

## Configuration

| File                 | Description                                                                          |
|----------------------|--------------------------------------------------------------------------------------|
| `config/project.yml` | Your project configuration values.                                                   |
| `config/modules.yml` | The cross-environments configuration values of your modules.                         |
| `config/app.yml`     | The cross-environments configuration values of your PHP application.                 |
| `config/.env`        | The sensitive and environment specific configuration values of your modules.         |
| `config/.app.env`    | The sensitive and environment specific configuration values of your PHP application. |
| `orbit.yml`          | The Orbit's commands of your project.                                                |

Don't hesitate to take a look at those files, as they are provided with nice comments!

## Modules

* [Toolbox](#toolbox)
* [Traefik](#traefik)
* [Graylog](#graylog)
* [NGINX](#nginx)
* [PHP-FPM](#php-fpm)
* [MySQL](#mysql)
* [Redis](#redis)
* [RabbitMQ](#rabbitmq)

### Toolbox

The Toolbox is a simple container which is used to:

* Generates the self-signed certificate on your `local` environment
* Generates the `.htdigest` file for authentication to the Traefik dashboard on environments <> `local`
* Generates the SHA2 password and secret pepper for Graylog authentication
* Checks if Graylog is ready to receive logs from others containers

### Traefik

The [Traefik](https://traefik.io/) container is used as a reverse-proxy: it's the entry door which will redirect clients requests
to the correct frontend.

It provides a nice dashboard (https://traefik.your-virtualhost.local/) which requires an authentication on environments <> `local`.

#### HTTPS

On your `local` environment, the Toolbox container will automatically generate a self-signed certificate according to the
virtual host specified in your `project.yml` file.

On others environment, we provided `TRAEFIK_CERT_FILE_PATH` and `TRAEFIK_KEY_FILE_PATH` variables in your `.env` file 
to let you specified the absolute path of your certifications. You could also customize the Traefik configuration located at 
`modules/traefik/traefik.blueprint.toml` with [ACME configuration](https://docs.traefik.io/toml/#acme-lets-encrypt-configuration)
to enable automatic HTTPS. 

#### Configuration

| Variable               | Location             | Description                                                                                                                                 |
|------------------------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| virtualhost.*          | `config/project.yml` | The virtual host to use according to your environments.                                                                                     |
| traefik.user           | `config/modules.yml` | The Traefik user used for generating the .htdigest file. Only required for environments <> `local`.                                         |
| TRAEFIK_PREFIX         | `config/.env`        | If `true`, your URLs will be prefixed with your current environment. This is useful if you wish to have many environments on the same host. |
| TRAEFIK_LOG_LEVEL      | `config/.env`        | Defines the log level of the Traefik container.                                                                                             |
| TRAEFIK_PASSWORD       | `config/.env`        | The password of the user defined in the `modules.yml` file. Only required for environments <> `local`.                                      |
| TRAEFIK_CERT_FILE_PATH | `config/.env`        | The `.crt` absolute file path. Only required for environments <> `local`.                                                                   |
| TRAEFIK_KEY_FILE_PATH  | `config/.env`        | The `.key` absolute file path. Only required for environments <> `local`.                                                                   |

### Graylog

The [Graylog](https://www.graylog.org/) containers centralize the Docker's logs of the NGINX, PHP-FPM, MySQL, 
phpMyAdmin, Redis and RabbitMQ containers. It's actually composed of three containers: Elasticsearch, MongoDB
and the Graylog server.

You may access to the Graylog dashboard (https://graylog.your-virtualhost.local/) using the credentials provided in your configuration files.

#### Configuration

| Variable                 | Location             | Description                                                                    |
|--------------------------|----------------------|--------------------------------------------------------------------------------|
| graylog.enable           | `config/modules.yml` | If `true`, enables Graylog.                                                    |
| graylog.user             | `config/modules.yml` | The Graylog `root` user.                                                       |
| GRAYLOG_PORT             | `config/.env`        | The port on which the Graylog server will receive logs from others containers. |
| GRAYLOG_PASSWORD         | `config/.env`        | The password of the user defined in the `modules.yml` file.                    |
| GRAYLOG_SERVER_JAVA_OPTS | `config/.env`        | The Java options for the Graylog server.                                       |
| GRAYLOG_ES_JAVA_OPTS     | `config/.env`        | The Java options for Elasticsearch.                                            |

### NGINX

NGINX is the web server of your PHP application.

The NGINX configuration located at `modules/nginx/conf.d/php-fpm.conf` provides good security defaults. Still, you might 
have to update it according to the PHP framework you wish to use.

### PHP-FPM

The PHP-FPM container has many roles. First, it handles requests from the NGINX container to execute your PHP files.
Then, it provides a complete set of tools to help you building your application. You can run them by connecting to it with
the `orbit run workspace` command.

Your PHP application will be accessible under https://your-virtualhost.local/ and https://www.your-virtualhost.local/.

#### Installed PHP extensions

apcu, bcmath, gd, intl, mbstring, mcrypt, pdo_mysql, phpredis, opcache, soap, xdebug (`local` environment only!), yaml,
zip and more!

You are able to find all installed PHP extensions by running `php -m` inside your workspace.

#### Available tools

*Composer* - https://getcomposer.org/

> Composer helps you declare, manage and install dependencies of PHP projects.

*prestissimo* - https://github.com/hirak/prestissimo

> composer parallel install plugin.

*npm* - https://www.npmjs.com/

> npm is the package manager for JavaScript and the world’s largest software registry.

*yarn* - https://yarnpkg.com/lang/en/

> FAST, RELIABLE, AND SECURE DEPENDENCY MANAGEMENT

*PHP Coding Standards Fixer* - http://cs.sensiolabs.org/

> The PHP Coding Standards Fixer tool fixes most issues in your code when you want to follow the PHP coding standards 
as defined in the PSR-1 and PSR-2 documents and many more.

#### Configuration

| Variable             | Location      | Description                                                |
|----------------------|---------------|------------------------------------------------------------|
| PHP_MEMORY_LIMIT     | `config/.env` | Defines the PHP memory limit of the PHP-FPM container.     |
| PHP_FPM_MEMORY_LIMIT | `config/.env` | Defines the PHP-FPM memory limit of the PHP-FPM container. |

### MySQL

The MySQL container is the DBMS of this stack.

In your PHP-FPM container, the hostname of the MySQL DBMS is equal to `mysql`. Also, just use the port `3306` and the
credentials defined in the `modules.yml` and `.env` files.

There are also three ways to manage MySQL:

* On `local` environment, you may access to the phpMyAdmin dashboard (https://phpadmin.your-virtualhost.local/); 
you will automatically be connected as `root`
* By running `orbit run mysql-cli`: it will open the MySQL cli and connect you as `root`. On environments <> `local`, 
it will ask you the MySQL `root` password
* By mapping the container's port `3306` to a host port, you are able to use a more powerful tool like MySQL Workbench
using `127.0.0.1` (or your server IP) as host and the port defined in the variable `MYSQL_HOST_PORT_TO_MAP` in your
`.env` file

#### Configuration

| Variable                   | Location             | Description                                                                                                                                                                               |
|----------------------------|----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| mysql.enable               | `config/modules.yml` | If `true`, enables MySQL.                                                                                                                                                                 |
| mysql.user                 | `config/modules.yml` | The MySQL user of your PHP application.                                                                                                                                                   |
| mysql.databases            | `config/modules.yml` | List of the databases of your PHP application. If they do not exist, they will be created when the MySQL container starts. The previous user will have all privileges on these databases. |
| MYSQL_PASSWORD             | `config/.env`        | The password of the user defined in the `modules.yml` file.                                                                                                                               |
| MYSQL_ROOT_PASSWORD        | `config/.env`        | The MySQL `root` password.                                                                                                                                                                |
| MYSQL_ENABLE_PORTS_MAPPING | `config/.env`        | If true, it will map the port `3306` of the MySQL container with the host port defined below.                                                                                             |
| MYSQL_HOST_PORT_TO_MAP     | `config/.env`        | The host port to map.                                                                                                                                                                     |

### Redis

Redis is the database cache of this stack and it has been configured as the default session handler for PHP.

The hostname of Redis in your PHP-FPM container is equal to `redis`. To configure Redis to be the cache handler of 
your PHP application, you should refer to the documentation provided by your PHP framework.

**Note:** You should not use [predis](https://github.com/nrk/predis), as [phpredis](https://github.com/phpredis/phpredis) 
is installed by default.

#### Configuration

| Variable       | Location             | Description                                |
|----------------|----------------------|--------------------------------------------|
| redis.enable   | `config/modules.yml` | If `true`, enables Redis.                  |
| REDIS_PASSWORD | `.env`               | The auth used to access to the Redis DBMS. |

### RabbitMQ

RabbitMQ is the message broker of this stack.

The hostname of RabbitMQ in your PHP-FPM container is equal to `rabbitmq`. To configure RabbitMQ to be the message 
broker of your PHP application, you should refer to the documentation provided by your PHP framework.

You may access to the RabbitMQ dashboard (https://rabbitmq.your-virtualhost.local/) using the credentials provided in 
your configuration files.

#### Configuration

| Variable          | Location             | Description                                                 |
|-------------------|----------------------|-------------------------------------------------------------|
| rabbitmq.enable   | `config/modules.yml` | If `true`, enables RabbitMQ.                                |
| rabbitmq.user     | `config/modules.yml` | The RabbitMQ user of your PHP application.                  |
| RABBITMQ_PASSWORD | `config/.env`        | The password of the user defined in the `modules.yml` file. |

## Advanced

### Restart strategy

On your `local` environment, your containers will not restart automatically.

On others environments, if you have enable Graylog, they will also not restart automatically. Indeed, we have to check 
that Graylog is ready to receive logs from others containers before we start them. In your production environment, you 
should configure your host to restart in the right order your containers after Docker startup. Indeed, your host provider
might restart your server from time to time. Of course, if Graylog is not enable, your containers have been configured 
to restart automatically. :wink:

### Many environments on the same host

Let's say you want your `staging` and `production` environments to run on the same host. You have cloned two projects,
one per environment.

First, check that you have the same virtual host on both environments. 

Then, start your production environment by running `orbit run kickoff`.

Once done, move to the `staging` environment project folder, and update the following variables in your `.env` file:

* `TRAEFIK_PREFIX` to `true`
* `GRAYLOG_PORT` to another port than the one used by your `production` environment
* If `MYSQL_ENABLE_PORTS_MAPPING=true` on both your environments, update `MYSQL_HOST_PORT_TO_MAP` in your `staging` 
environment to another port than the one used by your `production` environment

Last but not least, start your `staging` environment by running `orbit run build up`.

**Note:** don't run `kickoff` command, as we only want one Traefik container! 

If your virtual host is `my-awesome-project.com`, your `production` applications will be available under `*.my-awesome-project.com`
while your `staging` applications will be available under `*-staging.my-awesome-project.com`! :metal:

## Contributing

Please read our [contributing guidelines](.github/CONTRIBUTING.md) for instructions.

If you've found a security vulnerability, please e-mail directly: j dot neuhart dot thecodingmachine dot com.
Provide enough information to verify the bug and make a patch!

## Credits

* NGINX and PHP-FPM configuration files from [Cerenit](https://code.cerenit.fr/cerenit/docker-grav)
* MySQL utf8mb4 encoding from [this blog article](https://mathiasbynens.be/notes/mysql-utf8mb4)

---

Would you like to update this documentation ? Feel free to open an [issue](../../issues).