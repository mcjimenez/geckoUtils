#!/bin/bash

echo "IN:"
git branch -v | grep "\*"

if [ $# -gt 0 ] ; then
  echo "$1:"
  git branch -v | grep -i $1
fi
