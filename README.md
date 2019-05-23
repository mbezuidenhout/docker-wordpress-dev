# docker-wordpress-dev
Dockerfile for wordpress development on amd64

Use in conjunction with mailhog.

# Example docker-compose.yaml

```
version: '3.7'

services:
  wordpress:
    image: bezuidenhout/wordpress-dev
    ports:
     - '80:80'
     - '443:443'
    restart: always
    networks:
      bridge:
    volumes:
     - "/etc/localtime:/etc/localtime:ro"
     - ./wordpress:/var/www/html:delegated
    depends_on:
     - "mysql"
     - "mailhog"
    environment:
     - HTTPS_ENABLED=true
     - APACHE_RUN_UID=500
     - WORDPRESS_DB_USER=myuser
     - WORDPRESS_DB_PASSWORD=R4nD9mPA55w0rd
     - WORDPRESS_DB_NAME=mydb
     - WORDPRESS_DB_HOST=mysql
  mailhog:
    image: bezuidenhout/mailhog
    restart: always
    volumes:
     - "/etc/localtime:/etc/localtime:ro"
    ports:
     - 8025:8025 # web ui
    networks:
      bridge:
  mysql:
    image: linuxserver/mariadb
    ports:
     - '3306:3306'
    restart: always
    environment:
     - PUID=500
     - MYSQL_USER=myuser
     - MYSQL_PASSWORD=R4nD9mPA55w0rd
     - MYSQL_ROOT_PASSWORD=R4nD9mr007PA55w0rd
     - MYSQL_DATABASE=mydb
    volumes:
     - "/etc/localtime:/etc/localtime:ro"
     - ./mysql:/config/databases:cached
    networks:
      bridge:
networks:
  bridge:
```
