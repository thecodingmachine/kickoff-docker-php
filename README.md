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

**Note:** This document is still under progress.

# Menu

* [Features](#features)
* [Install](#install)
* [Quick start](#quick-start)
* [Configuration](#configuration)
* [Commands](#commands)
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

## Configuration

| File        | Description                                            |
|-------------|--------------------------------------------------------|
| .env        | Contains all sensitive data like passwords.            |
| kickoff.yml | Contains data like the user of MySQL, Redis and so on. |
| orbit.yml   | Contains the Orbit's commands of this project.         |

Don't hesitate to take a look at those files, as they are provided with nice comments!

## Commands

| Command              | Description                                                                                                             |
|----------------------|-------------------------------------------------------------------------------------------------------------------------|
| `orbit run kickoff`  | Generates all configuration files and starts the containers.                                                            |
| `orbit run shutdown` | Stops all the containers.                                                                                               |
| `orbit run toolbox`  | Connects through ash to the toolbox container. This is where you're able to run `composer`, `npm` and  `yarn` commands. |

Don't hesitate to take a look at `orbit.yml` file, as it is provided with nice comments!

## Credits

* NGINX and PHP-FPM configuration files from [Cerenit](https://code.cerenit.fr/cerenit/docker-grav)
* MySQL utf8mb4 encoding from [this blog article](https://mathiasbynens.be/notes/mysql-utf8mb4)
* Icon by Nikita Kozin from the Noun Project

---

Would you like to update this documentation ? Feel free to open an [issue](../../issues).
