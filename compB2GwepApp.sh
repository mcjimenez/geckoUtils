#!/bin/sh 

PWD=`pwd`
DIR_SRC=/home/cjc/dev/B2G_hama/objdir-m-c
DIR_SRC1=/home/cjc/dev/B2G_hama/objdir-m-c/dom/apps

cd ${DIR_SRC1}
make 

cd ${DIR_SRC}
make package

OMNI_JA_PATH=/system/b2g
OMNI_JA=omni.ja

SRC_F=${DIR_SRC}/dist/b2g/omni.ja

adb shell stop b2g
adb remount
adb push ${SRC_F} ${OMNI_JA_PATH}/${OMNI_JA}
#adb shell start b2g
cd ${PWD}
