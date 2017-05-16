#!/bin/bash
# to run this script on remote server
# ssh root@host_ip_address 'bash -s' < autoframer.sh

# set -xe


function printAndSleep() {
	echo
	echo "$1"
	echo
	if [ -z $2 ]; then
		sleep 1
	else
		sleep $2
	fi

}

printAndSleep "updating apt" 10

# update apt on remote machine
apt-get -y update

printAndSleep "installing OpenJdk 8" 10

# install jdk8
apt-get -y install openjdk-8-jdk

printAndSleep "installing unzip tool"

# install unzip tool
apt-get -y install unzip

printAndSleep "downloading linux android sdk tools"

# download android linux sdk tools
wget -nc -O sdk-tools-linux.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip

printAndSleep "creating our own sdk directory (android-sdk)"

# create sdk directory
mkdir android-sdk

printAndSleep "unzipping linux android sdk tools"

# unzip android linux sdk tools
unzip -o sdk-tools-linux.zip -d android-sdk/

printAndSleep "navigating into android-sdk dir"

# navigate into our directory
cd android-sdk/
pwd

printAndSleep "installing android sdk packages"

declare -a arr=("build-tools;25.0.3" "cmake;3.6.3155560" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository" "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" "lldb;2.3" "patcher;v4" "platform-tools" "platforms;android-25")

for package in "${arr[@]}"; do
	echo
	printAndSleep "Installing $package"
	echo "y" | ./tools/bin/sdkmanager "$package"
done

printAndSleep "Checking for Android SdkManager updates..."
./tools/bin/sdkmanager --update

echo $0
