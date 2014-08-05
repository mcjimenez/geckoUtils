#!/bin/bash

PWD=`pwd`
TMP_DIR="/tmp"

auxdir=`date "+%y%m%d%H%M%S"`

SETTING_FILE="chrome/chrome/content/settings.js"
ORG_LINE="let useDisableAdbTimer = true;\$"
DST_LINE="let useDisableAdbTimer = true; enableAdb = true; useDisableAdbTimer = false;"


function errorAndExit {
  echo "Temporal content on: ${TMP_DIR}/${auxdir}. Remove it"
  echo $1
  cd ${PWD}
  exit 1
}

echo "Start adb activation..."
cd ${TMP_DIR}

if [ $? -ne 0 ]; then
  errorAndExit "cannot access to tmp directory. Please solved it and try again"
fi

mkdir ${auxdir}
if [ $? -ne 0 ]; then
  errorAndExit "cannot create auxiliary directory (${TMP_DIR}/${auxdir}). Solve it and try again"
fi

cd ${auxdir}

adb pull /system/b2g/omni.ja .
if [ $? -ne 0 ]; then
  errorAndExit "cannot get omni.ja file from phone. Please verify you have adb access to the phone and try again"
fi

unzip omni.ja
if [ $? -ne 0]; then
  errorAndExit "cannot unzip onmi.ja"
fi

sed "s/${ORG_LINE}/${DST_LINE}/g" ${SETTING_FILE} > ${SETTING_FILE}.TMP
if [ $? -ne 0 ]; then
  errorAndExit "cannot change line ${ORG_LINE}"
fi

mv ${SETTING_FILE}.TMP ${SETTING_FILE}

rm omni.ja

zip -r omni.ja .
if [ $? -ne 0 ]; then
  errorAndExit "cannot regenerate onmi.ja"
fi

adb remount
if [ $? -ne 0 ]; then
  errorAndExit "cannot execute adb remount. please verify adb access and try again"
fi

adb push omni.ja /system/b2g/omni.ja
if [ $? -ne 0 ]; then
  errorAndExit "cannot copy omni.ja on the phone"
fi

cd ${PWD}

adb reboot

echo "Done!!"
