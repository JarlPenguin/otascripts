#!/bin/bash

device=$1
(return 0 2>/dev/null) && export sourced=1 || export sourced=0
if [ "$sourced" == "0" ]; then
    echo "Script not being sourced. Please source it instead of executing it directly."
    exit 1
fi
if [ "$device" == "" ]; then
    echo "Device not defined.
Usage: setup.sh <device codename>"
    exit 1
fi
echo "Updating details for "$device"..."
source prev_"$device".sh
date=$(date +%Y%m%d)
if [ "$device" == "generic" ]; then
else
curl https://download.exynos5420.com/LineageOS-14.1/"$device"/lineage-14.1-"$date"-UNOFFICIAL-"$device".zip -o lineage-"$device".zip
fi

# MD5 Sum
if [ "$device" == "generic" ]; then
export md5sum=$(md5sum test.txt|sed "s|..test.*||g")
else
export md5sum=$(md5sum lineage-"$device".zip | sed "s|..lineage-.*||g")
fi
sed -i "s|$prev_md5sum|$md5sum|g" "$device".json
echo "export prev_md5sum="$md5sum"" >> prev_"$device".sh

# Size
if [ "$device" == "generic" ]; then
export size=$(ls -l test.txt | cut -d " " -f5)
else
export size=$(ls -l lineage-"$device".zip | cut -d " " -f5)
fi
sed -i "s|$prev_size|$size|g" "$device".json
echo "export prev_size="$size"" >> prev_"$device".sh

# Date time
if [ "$device" == "generic" ]; then
else
rm -rf system
unzip lineage-"$device".zip system/build.prop
fi
export builddate=$(cat system/build.prop | grep ro.build.date.utc | sed 's|ro.build.date.utc=||g')
sed -i "s|$prev_builddate|$builddate|g" "$device".json
echo "export prev_builddate="$builddate"" >> prev_"$device".sh
rm -rf system

# File name
if [ "$device" == "generic" ]; then
export filename="test.txt"
else
export filename=lineage-14.1-"$date"-UNOFFICIAL-"$device".zip
fi
sed -i "s|$prev_filename|$filename|g" "$device".json
echo "export prev_filename="$filename"" >> prev_"$device".sh

# URL
if [ "$device" == "generic" ]; then
export url=""
git checkout -- system/build.prop
git add prev* *.json
git commit -m "Automatic json update"
git push