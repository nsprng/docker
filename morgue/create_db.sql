CREATE DATABASE morgue;
CREATE USER 'morgue' IDENTIFIED BY 'morgue';
GRANT ALL ON morgue.* TO 'morgue';
SET PASSWORD FOR 'morgue' = PASSWORD('MRG_PSWD');
