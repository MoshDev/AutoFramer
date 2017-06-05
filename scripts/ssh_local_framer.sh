#!/bin/bash
# set -xe

host_ip_address=$1
host_name=$2
username=$3
output_dir=$4
[[ -z $output_dir ]] && output_dir=~/.ssh/

if [ -z $host_ip_address ]; then
	echo -n "Enter your remote machine ip address:"
	read host_ip_address
fi

if [ -z $host_name ]; then
	echo -n "Enter your Host alias name:"
	read host_name
fi

if [ -z $username ]; then
	echo -n "Enter your username to be created on the remote machine:"
	read username
fi

mkdir -p $ssh_path

ssh-keygen -t rsa -b 4096 -C $username -N "" -f "$ssh_path/id_rsa_$username"

cat <<EOT >>$ssh_path/config

  Host $host_name
  User $username
  HostName $host_ip_address
  Port 22
  IdentityFile ~/.ssh/id_rsa_$username
  PreferredAuthentications publickey
  ControlMaster auto
  ControlPath /tmp/%r@%h:%p
  ControlPersist 1h
EOT
