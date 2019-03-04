# morgue

## Description
Dockerized version of [Etsy/Morgue](https://github.com/etsy/morgue) application for postmortems.
Shipped without Database - use your own instead.

## Get started
```
docker build -t <IMAGE_TAG> .
docker run -dit -p 80:80 -e DB_HOST=mysql -e DB_PSWD=<YOUR_MYSQL_ROOT_PASSWORD> -e MRG_PSWD=<YOUR_MYSQL_MORGUE_PASSWORD> -e TZ="<YOUR_TIMEZONE>" <IMAGE_TAG>
```
## Example
### Build docker image:
```
docker build -t nsprng/morgue:latest .
```
### Run MySQL: 
```
docker run -d --name db4morgue -e MYSQL_ROOT_PASSWORD=mysqlpassword mysql:5.7.25
```
### Run Morgue:
```
docker run -dit --name morgue -h morgue -p 80:80 --link db4morgue:mysql -e DB_HOST=mysql -e DB_PSWD=mysqlpassword -e MRG_PSWD=morguepassword -e TZ="Europe/London" nsprng/morgue:latest
```
