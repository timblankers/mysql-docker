#!/bin/sh

# Set constants
BACKUP_FOLDER=/opt/mysql/backup
NOW=$(date +"%FT%H%M")
FINALFILE=${BACKUP_FOLDER}/backup-${NOW}.sql.gz

GZIP=$(which gzip)
MYSQLDUMP=$(which mysqldump)
MYSQL=$(which mysql)

[ ! -d "$BACKUP_FOLDER/$NOW" ] && mkdir --parents $BACKUP_FOLDER/$NOW

# Dump all databases to separate files
databases=`$MYSQL --user=root --password=$MYSQL_ROOT_PASSWORD --host=$MYSQL_CONTAINER_NAME --batch --skip-column-names -e "SHOW DATABASES;" | grep -v 'mysql\|information_schema'`

for database in $databases; do
    $MYSQLDUMP \
    --user=root --password=${MYSQL_ROOT_PASSWORD} --host=$MYSQL_CONTAINER_NAME \
    --force \
    --quote-names --dump-date \
    --opt --single-transaction \
    --events --routines --triggers \
    --databases $database \
    --result-file="$BACKUP_FOLDER/$NOW/$database.sql"
done

# Merge dumps into one tar
cd $BACKUP_FOLDER
tar cvzf $FINALFILE $NOW/*.sql
rm -rf $BACKUP_FOLDER/$NOW
cd ~

# Upload tar to object storage
curl https://dl.min.io/client/mc/release/linux-amd64/mc \
  --create-dirs \
  -o $HOME/minio-binaries/mc

chmod +x $HOME/minio-binaries/mc
export PATH=$PATH:$HOME/minio-binaries/

mc alias set s3 "${S3_ENDPOINT}" "${S3_ACCESS_KEY}" "${S3_SECRET_KEY}" --api S3v4
mc cp --quiet $FINALFILE "s3/snapshots/"