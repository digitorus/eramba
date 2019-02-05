# Dockerized Eramba, Governance, Risk & Compliance

This image is originally based on k0st/alpine-eramba.

## Usage

Use docker compose to create a new database and application server with Eramba and all the required Apache and PHP modules.

Download the docker-compose.yml file:
```
wget https://raw.githubusercontent.com/digitorus/eramba/master/docker-compose.yml
```

Change the username and passwords in the environment of the docker-compose.yml file:
```
    - MYSQL_DATABASE=erambadb
    - MYSQL_ROOT_PASSWORD=erambarootpass
    - MYSQL_USER=erambadb
    - MYSQL_PASSWORD=erambapass
```

Start docker compose to create the environment:
```
docker-compose up 
```
