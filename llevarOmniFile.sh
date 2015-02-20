#!/bin/sh -x

CD_ORG=`pwd`
TMP_DIR=/Volumes/b2g/tmp/omni
OMNI_JA_PATH=/system/b2g
OMNI_JA=omni.ja

SRC_F=/Volumes/b2g/dev/mozilla-central/dom/apps/src/Webapps.jsm
DST_F=modules/Webapps.jsm

cd ${TMP_DIR}
zip -r ${OMNI_JA} * >/dev/null 2>&1
adb shell stop b2g
adb remount
adb shell rm ${OMNI_JA_PATH}/${OMNI_JA}
adb push ${OMNI_JA} ${OMNI_JA_PATH}/${OMNI_JA}
adb shell start b2g
cd ${CD_ORG}


