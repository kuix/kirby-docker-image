## Docker Image for Kirby CMS

The image based on the original `php:7.2-apache` image but added some extra apache module which necessary for run Kirby CMS. The following modifications added:

* MySQL module added
* Apache ModRewrite module enabled
* Apache SSL module enabled

### Usage

Define your environment variables based on `.env.example` file. After that place a compose file with the following content. This compose file will start two container:

* An Apache and PHP container to server Kirby
* A MySQL container optional

```
version: '2'
services:
    apache-php:
        image: kuix/kirby
        volumes:
            - ./:/var/www/html
        ports:
          - "80:80"
          - "443:443"
        env_file:
            - .env
        links:
            - mysql
    mysql:
        image: mysql:5.5
        volumes:
            - ./data/mysql:/var/lib/mysql
        ports:
            - "3306:3306"
        env_file:
              - .env
```

### Generate SSL Certificate

You should run certification generation on your production server with the following command:

```docker run -it --rm -p 443:443 -p 80:80 --name certbot -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" certbot/certbot certonly -d DOMAIN_NAME1 -d DOMAIN_NAME2```