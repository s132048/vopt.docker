CREATE DATABASE djangodb
  WITH OWNER admin
  TEMPLATE template0
  TABLESPACE  pg_default
  ENCODING 'UTF8'
  LC_COLLATE  'C'
  LC_CTYPE  'C'
  CONNECTION LIMIT -1;
CREATE USER djangouser
  WITH PASSWORD 'djangouserpass';
GRANT ALL PRIVILEGES
  ON DATABASE djangodb
  to djangouser;
