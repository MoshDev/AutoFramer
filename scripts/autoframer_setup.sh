#!/bin/bash
# set -e

function proceedFun() {
	current_user=$(whoami)
	autoframer_preferences=/Users/$current_user/Library/Autoframer

	current_dir=$(pwd)

    cp -r $autoframer_preferences/ $current_dir
}

while true; do
	read -p "This will add some files to your project, proceed? (yes/no):" yn
	case $yn in
		[Yy]*)
			proceedFun
			break
			;;
		[Nn]*) exit ;;
		*) echo "Please answer yes or no." ;;
	esac
done
