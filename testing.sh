#!/bin/bash
set -e

declare -a arr=("build-tools;25.0.3" "cmake;3.6.3155560" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository" "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2" "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" "lldb;2.3" "patcher;v4" "platform-tools" "platforms;android-25")
for i in "${arr[@]}"; do
	echo "AndroidSdkManager is Installing -> $i"
	sleep 1
	# echo "y" | ./tools/bin/sdkmanager "$i"
done
