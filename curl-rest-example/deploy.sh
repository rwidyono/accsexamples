#!/bin/sh
. config.properties

# CREATE STORAGE CONTAINER
echo curl -i -X PUT \
  -u ${USER_ID}:${USER_PASSWORD} \
  https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-$ID_DOMAIN/$APP_NAME

curl -i -X PUT \
    -u ${USER_ID}:${USER_PASSWORD} \
    https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-$ID_DOMAIN/$APP_NAME

# PUT ARCHIVE IN STORAGE CONTAINER
echo curl -i -X PUT \
  -u ${USER_ID}:${USER_PASSWORD} \
  https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-$ID_DOMAIN/$APP_NAME/$ARCHIVE_FILE \
      -T $ARCHIVE_LOCAL
curl -i -X PUT \
  -u ${USER_ID}:${USER_PASSWORD} \
  https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-$ID_DOMAIN/$APP_NAME/$ARCHIVE_FILE \
      -T $ARCHIVE_LOCAL

# CREATE APPLICATION WITH DEPLOYMENT.JSON
echo curl -i -X POST  \
  -u ${USER_ID}:${USER_PASSWORD} \
  -H "X-ID-TENANT-NAME:${ID_DOMAIN}" \
  -H "Content-Type: multipart/form-data" \
  -F "name=${APP_NAME}" \
  -F "runtime=node" \
  -F "deployment=@deployment-1.json" \
  -F "subscription=Monthly" \
  -F archiveURL=${APP_NAME}/${ARCHIVE_FILE} \
  https://${APAAS_HOST}/paas/service/apaas/api/v1.1/apps/${ID_DOMAIN}

curl -i -X POST  \
  -u ${USER_ID}:${USER_PASSWORD} \
  -H "X-ID-TENANT-NAME:${ID_DOMAIN}" \
  -H "Content-Type: multipart/form-data" \
  -F "name=${APP_NAME}" \
  -F "runtime=node" \
  -F "deployment=@deployment-1.json" \
  -F "subscription=Monthly" \
  -F archiveURL=${APP_NAME}/${ARCHIVE_FILE} \
  https://${APAAS_HOST}/paas/service/apaas/api/v1.1/apps/${ID_DOMAIN}
