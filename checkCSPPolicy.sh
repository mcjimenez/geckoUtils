#!/bin/bash

PATH_BASE=`pwd`
DIR_APPS=profile/webapps

workingDir=
domains="*.org maps marketplace marketplace-staging"

EVENTS="onclick ondblclick onmousedown onmousemove onmouseover onmouseout onmouseup onkeydown onkeypress onkeyup onabort onerror onload onresize onscroll onunload onblur onchange onfocus onreset onselect onsubmit ondragdrop onmove"

#********************************************************************************#
# helper functions
#********************************************************************************#


function addCarriageReturn {
  if [ "${searchResult}" != "" ];then
    searchResult="${searchResult}\n"
  fi
}

function lookupScript {
  scr="";
  src=`grep -En "<[[:space:]]*script.*>" $1 |grep -vE "[[:space:]]+src[[:space:]]*="`

  addCarriageReturn

  if [ "${src}" != "" ];then
    searchResult="${searchResult}--------------\nINLINE SCRIPTS\n--------------\n${src}"
  fi
}

function lookupEvents {
  allEvent="";

  for i in ${EVENTS}; do
    event=`grep -in "${i}[[:space:]]*=" $1`
    if [ "${event}" != "" ];then
      if [ "${event}" != "" ];then
        allEvent="${allEvent}\n${event}"
      else
        allEvent=${event}
      fi
    fi
  done

  addCarriageReturn

  if [ "${allEvent}" != "" ];then
    searchResult="${searchResult}---------------------\nINLINE EVENTS MANAGER\n---------------------\n${allEvent}"
  fi
}

function lookupURLjavascript {
  url=""
  url=`grep -in "javascript:" $1`

  addCarriageReturn

  if [ "${url}" != "" ];then
    searchResult="${searchResult}---------------\nJAVASCRIPT HREF\n---------------\n${url}"
  fi
}

function inflateApps {
  cd ${workingDir}
  for unz in ${domains}; do
    if [ -d $unz -a -f "$unz/application.zip" ]; then
      cd $unz;
      mkdir tmp  2>&1 > /dev/null;
      cp application.zip tmp  2>&1 > /dev/null;
      cd tmp  2>&1 > /dev/null;
      unzip -o application.zip 2>&1 > /dev/null;
      cd ../..;
    fi
  done;
}

function deleteUnzip {
#  cd ${PATH_BASE}/${DIR_APPS}
  cd ${workingDir}
  for dunz in ${domains}; do
    if [ -d $dunz -a -f "$dunz/application.zip" ]; then
      cd $dunz;
      rm -rf tmp;
      cd ..;
    fi
  done
}

function  showResult {
  if [ "${searchResult}" != "" ]; then
    echo "################################################################################";
    echo "APPLICATION: `echo ${1} | cut -d "/" -f 2`"
    echo "FILE: `echo ${1} | cut -d "/" -f 4-`"
    echo "${searchResult}" | sed -E 's/\\n/\n/g'
  fi
}

############################################
# MAIN
############################################

workingDir=${PATH_BASE}/${DIR_APPS}

if [ $# -gt 0 ]; then
  if [ $# -eq 1 ]; then
    workingDir=$1
  elif [ $# -eq 2 ]; then
    workingDir=$1
    domains=$2
  else
    echo "USE: $0 <parentDirectory> [<domains>]"
    echo "  Where :"
    echo "    <parentDirectory>: Parent Directory of the app directory which wont to test>"
    echo "    <domains>: Default Value is \"${domains}\". "
    echo "               Specifies the domain app name where it look for apps"
    echo "               If specific directory's app is appName.company.countryCode,"
    echo "               same example could be *.countryCode, *.company.countryCode or appName.company.countryCode"
    exit 1
  fi
fi

echo "SEARCH EXECUTED ON: ${workingDir}"
if [ ! -d "${workingDir}" ]; then
  if [ "${workingDir}" == "${PATH_BASE}/${DIR_APPS}" ]; then
    echo "$0 must be executed on parent directory of ${DIR_APPS}"
    exit 1;
  else
    echo "Directory (${workingDir}) not exists"
    exit 1;
  fi
fi

cd ${workingDir}

export searchResult="";

inflateApps;
find . -name *.html
for fich in `find . -name *.html`; do
  searchResult="";
  lookupEvents ${workingDir}/${fich}
  lookupScript ${workingDir}/${fich}
  lookupURLjavascript ${workingDir}/${fich}
  showResult ${fich}
done

deleteUnzip;

