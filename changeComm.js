#!/bin/sh
RUTA=/home/cjc/tmp/communications
CONF=resources

#923444
#SRCCONF='/home/cjc/dev/893800/customization/customization.json /home/cjc/dev/893800/customization/{11111111-1111-1111-1111-latam}.json /home/cjc/dev/893800/customization/{22222222-2222-2222-2222-spain}.json'

#923443
#SRCCONF='/home/cjc/dev/893800/customization/customization.json /home/cjc/dev/893800/customization/known_networks_latam.json /home/cjc/dev/893800/customization/known_networks_spain.json'

#923449 || 969642 || 970929
SRCCONF='/home/cjc/dev/893800/customization/customization.json /home/cjc/dev/893800/customization/{11111111-1111-1111-1111-latam}.json /home/cjc/dev/893800/customization/data_icon_statusbar_latam.json /home/cjc/dev/893800/customization/data_icon_statusbar_spain.json'

#923455
#SRCCONF='/home/cjc/dev/893800/customization/customization.json /home/cjc/dev/893800/customization/keyboard_settings_spain.json'

actPath=`pwd`
cd ${RUTA}
rm -rf *
adb pull /system/b2g/webapps/communications.gaiamobile.org/application.zip .
unzip application.zip >/dev/null 2>&1
rm application.zip
cd ${CONF}
for fich in ${SRCCONF}; do
  cp ${fich} .
done;
cd ${RUTA}
zip -r application.zip * >/dev/null 2>&1
adb remount
adb push application.zip /system/b2g/webapps/communications.gaiamobile.org/application.zip
cd ${actPath}
