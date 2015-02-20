#!/bin/sh -x

CD_ORG=`pwd`
TMP_DIR=/Volumes/b2g/tmp/omni
OMNI_JA_PATH=/system/b2g
OMNI_JA=omni.ja

SRC_F=/Volumes/b2g/dev/mozilla-central/dom/apps/src/Webapps.jsm
DST_F=modules/Webapps.jsm

cd ${TMP_DIR}
rm -rf *
adb pull ${OMNI_JA_PATH}/${OMNI_JA}  .
unzip ${OMNI_JA} >/dev/null 2>&1
rm ${OMNI_JA}

