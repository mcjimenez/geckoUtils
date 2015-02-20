#!/bin/bash
PWD=`pwd`

UTILS_FILE="tools/update-tools/build-update-xml.py"
B2G_DIR="/home/cjc/dev/B2G_flame2"
DST_DIR="/var/www/updates/flame"
FOTA_XML="update_v123_full.xml"
OTA_XML="update_v123.xml"
SERV_URL="http://owd.tid.es/updates/flame"
FOTA_DST_NAME="fota-flame-update-v123-full.mar"
OTA_DST_NAME="fota-flame-update-v123.mar"

VER="35.0a1"

cd ${DST_DIR}
if [ $? -ne 0 ]; then
  echo "Could not change to dst dir (${DST_DIR}). Fix it and try again"
  exit 1
fi
rm -rf *

cd ${B2G_DIR}

# Create mar's
VARIANT=user build_sto3.sh gecko-update-fota-full
VARIANT=user build_sto3.sh gecko-update-fota

# Copy mar to dst dir
cp out/target/product/flame/fota-flame-update-full.mar ${DST_DIR}/${FOTA_DST_NAME}
cp out/target/product/flame/fota-flame-update.mar ${DST_DIR}/${OTA_DST_NAME}

# Create xml
${UTILS_FILE} -o ${DST_DIR}/${FOTA_XML} -u "${SERV_URL}/${FOTA_DST_NAME}" -V ${VER} out/target/product/flame/fota-flame-update-full.mar
${UTILS_FILE} -o ${DST_DIR}/${OTA_XML} -u "${SERV_URL}/${OTA_DST_NAME}" -V ${VER} out/target/product/flame/fota-flame-update.mar

DATE=`date '+%y%m%d%H%M%S'`
cd ${DST_DIR}
tar cvfz fota_${DATE}.tgz .

cd ${PWD}
