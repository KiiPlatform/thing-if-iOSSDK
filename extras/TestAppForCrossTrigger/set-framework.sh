#!/bin/sh

pushd ../../ThingIFSDK; make; popd
mkdir -p frameworks
cp -r ../../ThingIFSDK/build/Release-iphonesimulator/ThingIFSDK.framework ./frameworks/
