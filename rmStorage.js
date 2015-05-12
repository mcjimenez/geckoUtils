#!/bin/bash
adb shell stop b2g
adb shell rm -r /data/local/storage
adb shell mkdir /data/local/storage
adb shell start b2g
