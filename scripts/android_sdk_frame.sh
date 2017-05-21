#!/bin/bash
# set -e
# to run this script on remote server
# ssh root@host_ip_address 'bash -s' < android_sdk_framer.sh

counter=0

function printAndSleep() {
	((counter++))
	echo
	echo "########################################################"
	echo "$counter: $1"
	echo "########################################################"
	echo

	if [ -z $2 ]; then
		sleep 1
	else
		sleep $2
	fi
}

# update apt
printAndSleep "Updating apt"
apt-get -y update

# install jdk8
JAVA_VER=$(java -version 2>&1 | sed -n ';s/.* version "\(.*\)\.\(.*\)\..*"/\1\2/p;')
if [ "$JAVA_VER" -ge 18 ]; then
	printAndSleep "Java $JAVA_VER Found"
else
	printAndSleep "Installing OpenJdk 8"
	apt-get -y install openjdk-8-jdk
fi

if [ ! -d "$HOME/android-sdk/" ]; then

	# install unzip tool
	printAndSleep "installing unzip tool"
	apt-get -y install unzip

	# download android linux sdk tools
	printAndSleep "Downloading linux android sdk tools"
	wget -nc -O sdk-tools-linux.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip

	# create sdk directory
	mkdir -p android-sdk

	# unzip android linux sdk tools
	printAndSleep "unzipping linux android sdk tools"
	unzip -o sdk-tools-linux.zip -d android-sdk

	[ ! -f $HOME/.android/repositories.cfg ] && echo "### User Sources for Android SDK Manager" >>$HOME/.android/repositories.cfg && echo "count=0" >>$HOME/.android/repositories.cfg

	# navigate into our directory
	cd android-sdk/

	printAndSleep "Accepting Android SDK licenses"
	mkdir -p licenses/
	echo -e "\n8933bad161af4178b1185d1a37fbf41ea5269c55" >"licenses/android-sdk-license"
	echo -e "\n84831b9409646a918e30573bab4c9c91346d8abd" >"licenses/android-sdk-preview-license"

	printAndSleep "Installing android sdk packages"
	declare -a arr=("build-tools;25.0.3" "cmake;3.6.3155560" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository" "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" "lldb;2.3" "patcher;v4" "platform-tools" "platforms;android-25")

	for package in "${arr[@]}"; do
		printAndSleep "Installing $package"
		./tools/bin/sdkmanager "$package"
	done

	printAndSleep "Checking for Android SdkManager updates..."
	./tools/bin/sdkmanager --update

	printAndSleep "Adding ANDROID_HOME_SCRIPT to environmental variables"

	ANDROID_HOME_SCRIPT=$(pwd)

	echo "" >>~/.bashrc
	echo "export ANDROID_HOME_SCRIPT=\"$(pwd)\"" >>~/.bashrc
	echo "" >>~/.bashrc
	echo "export PATH=\"${PATH}:${ANDROID_HOME_SCRIPT}/tools/:${ANDROID_HOME_SCRIPT}/platform-tools/\"" >>~/.bashrc

	echo -n "You need to logout to environmental variables take effect."
	read -n 1 -s -p "Press any key to continue"

else

	printAndSleep "Checking for Android SdkManager updates..."
	.$ANDROID_HOME_SCRIPT/tools/bin/sdkmanager --update
fi
