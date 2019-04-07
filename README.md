# morgue

## Description
Dockerized version of [Etsy/Morgue](https://github.com/etsy/morgue) application for postmortems.
Shipped without Database - use your own instead.

## Getting started
```bash
docker build -t <IMAGE_TAG> .
docker run -dit -p 80:80 --link <MYSQL_CONTAINER>:mysql \
  -e DB_HOST=<YOUR_MYSQL_HOST> -e DB_PSWD=<YOUR_MYSQL_ROOT_PASSWORD> \
  -e MRG_PSWD=<YOUR_MYSQL_MORGUE_PASSWORD> -e TZ="<YOUR_TIMEZONE>" <IMAGE_TAG>
```
## Example
### Build docker image:
```bash
docker build -t user/morgue:latest .
```
### Or pull my image from [Docker Hub](https://cloud.docker.com/u/nsprng/repository/docker/nsprng/morgue)
```bash
docker pull nsprng/morgue:1.0
```
### Run MySQL: 
```bash
docker run -d --name db4morgue -e MYSQL_ROOT_PASSWORD=mysqlpassword mysql:5.7.25
```
### Run Morgue:
```bash
docker run -dit -p 80:80 --link db4morgue:mysql \
  -e DB_HOST=mysql -e DB_PSWD=mysqlpassword \
  -e MRG_PSWD=morguepassword -e TZ="Europe/London" \
  --name morgue -h morgue user/morgue:latest
```
