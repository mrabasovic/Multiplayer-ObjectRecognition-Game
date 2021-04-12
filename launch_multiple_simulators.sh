#!/bin/sh

#  launch_multiple_simulators.sh
#  mobilnoracunarstvo
#
#  Created by mladen on 10.4.21..
#  

xcrun simctl shutdown all # Remove this line if you dont need to launch every time

path=$(find ~/Library/Developer/Xcode/DerivedData/mobilnoracunarstvo-*/Build/Products/Debug-iphonesimulator -name "mobilnoracunarstvo.app" | head -n 1)
echo "${path}"

filename=MultiSimConfig.txt
grep -v '^#' $filename | while read -r line
do
xcrun simctl boot "$line" # Boot the simulator with identifier hold by $line var
xcrun simctl install "$line" "$path" # Install the .app file located at location hold by $path var at booted simulator with identifier hold by $line var
xcrun simctl launch "$line" com.mrqefwqef.mobilnoracunarstvo # Launch .app using its bundle at simulator with identifier hold by $line var
done
