#!/bin/sh

rm -rf iphone/build
python iphone/build.py

unzip -o iphone/com.atticoos.titanium.chromecast-iphone-1.0.0.zip -d ~/Library/Application\ Support/Titanium/
