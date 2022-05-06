# Docker Symfony

Docker-symfony is the environment that gives you all you need to develop with Symfony framework.

The complete stack is made by the following images:
- `app`: the PHP-FPM container in wich the app is mounted
- `webserver`: the Nginx webserver container
- `db`: the MySQL database container
- `phpmyadmin`: the PhpMyAdmin container to manage the database
- `mailserver`: the MailDev smtp server container

## Installation

1. Create an `.env` from the `.env.dist` file.

```bash
cp .env.dist .env
```

2. Build and run containers

```bash
docker-compose build
docker-compose up -d
```

3. Update your system hosts file

```bash
echo "$(docker network inspect bridge | grep Gateway | grep -o -E '([0-9]{1,3}\.){3}[0-9]{1,3}') symfony.local" | sudo tee -a /etc/hosts
```

4. Prepare your Symfony app

    - Update `.env` file
    
    ```env
    DATABASE_URL="mysql://user:password@db:3306/test?serverVersion=5.7&charset=utf8mb4"

    MAILER_DSN=smtp://mailserver:8001
    ```

    - Composer install and create database

    ```bash
    docker-compose exec app composer install
    docker-compose exec app bin/console doctrine:database:create
    docker-compose exec app bin/console doctrine:schema:update --force
    ```

## Usage

Just run `docker-compose up -d`, then go to:

- [symfony.local](http://symfony.local)
- [phpmyadmin](http://symfony.local:8080)
- [maildev](http://symfony.local:8001)