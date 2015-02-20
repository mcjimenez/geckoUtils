#!/bin/sh 

# Simple script (emphasis on SIMPLE) to install an application. It takes as a parameter the zip that has the application
mkdir tmp
cd tmp
ROOT_DIR_DB=/data/b2g/mozilla
DB_DIR=`adb shell "ls -d ${ROOT_DIR_DB}/*.default 2>/dev/null" | sed "s/default.*$/default/g"`
CPREF=prefs.js

if [ "${DB_DIR}" = "" ]; then
  echo "Profile directory does not exists. Please start the b2g proccess at least once before running this script."
  exit 1
fi

NUM_LINES=`echo $DB_DIR|wc -w`
if [ $NUM_LINES -gt 1 ]
then
  echo "There's more than one profile directory. Please clean up (delete!) the invalid ones and try again"
  exit 1
fi

#Sobreescrir ficheros con certs

adb shell stop b2g
echo "Resetting phone 'first-run' state"
adb pull ${DB_DIR}/prefs.js ./prefs_tf.js
grep -vE '(gecko\.buildID|dom\.webapps\.firstRunWithSIM|ftu\.ril\.data\.enabled)' prefs_tf.js > pref_touched.js
adb push pref_touched.js ${DB_DIR}/prefs.js
adb shell rm -r /data/local/webapps/*
#/system/b2g/defaults/settings.json
adb shell start b2g

cd ..
rm -rf tmp
echo "Finished." 
