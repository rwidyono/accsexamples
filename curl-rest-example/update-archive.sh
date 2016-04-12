#!/bin/sh
. config.properties

# PUT ARCHIVE IN STORAGE CONTAINER
curl -i -X PUT \
  -u ${USER_ID}:${USER_PASSWORD} \
  https://${ID_DOMAIN}.storage.oraclecloud.com/v1/Storage-$ID_DOMAIN/$APP_NAME/$ARCHIVE_FILE \
      -T $ARCHIVE_LOCAL

# UPDATE ARCHIVE FROM STORAGE
curl -i -X PUT  \
  -u ${USER_ID}:${USER_PASSWORD} \
  -H "X-ID-TENANT-NAME:${ID_DOMAIN}" \
  -H "Content-Type: multipart/form-data" \
  -F archiveURL=${APP_NAME}/${ARCHIVE_FILE} \
  https://${APAAS_HOST}/paas/service/apaas/api/v1.1/apps/${ID_DOMAIN}/${APP_NAME}
