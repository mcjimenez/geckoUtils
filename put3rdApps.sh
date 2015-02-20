#!/bin/sh

LOCAL_3APPS_DIR=/home/cjc/dev/893800
REMOTE_3APPS_BASE_DIR=/data/local/svoperapps
REMOTE_3APPS_BASE_DST_DIR=/persist/svoperapps
CONF=singlevariantconf.json

APPS="accWeather importer.owd.tid.es puzzle.owd.tid.es sudoku.owd.tid.es calculator tidMarketplace operatorresources operatorResourcesLatam operatorResourcesSpain" 

PWD=`pwd`

adb shell mkdir ${REMOTE_3APPS_BASE_DIR}
adb shell rm -r ${REMOTE_3APPS_BASE_DIR}/*
adb shell rm -r ${REMOTE_3APPS_BASE_DST_DIR}
adb push ${LOCAL_3APPS_DIR}/${CONF} ${REMOTE_3APPS_BASE_DIR}

for app in ${APPS}
do
  echo ${app}
  adb shell mkdir ${REMOTE_3APPS_BASE_DIR}/${app}
  cd ${LOCAL_3APPS_DIR}/${app}
  for fich in `ls *`
  do
    adb push ${fich} ${REMOTE_3APPS_BASE_DIR}/${app}
  done
done

cd ${PWD}
