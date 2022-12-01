# mysql-docker
Running Mysql with Docker Compose and a backup mechanism

# Setup
1. Create a `.env` file with the variables the Docker containers are expecting.
```
MYSQL_ROOT_PASSWORD=
S3_ENDPOINT=
S3_ACCESS_KEY=
S3_SECRET_KEY=
S3_BUCKET=
```

2. `docker-compose up -d`

# References 
- https://ricardolsmendes.medium.com/mysql-mariadb-with-scheduled-backup-jobs-running-in-docker-1956e9892e78
- https://gist.github.com/andsens/3736393