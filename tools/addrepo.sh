#!/bin/sh
repo=$1
channel=$2
branch=$3
group=$4
key=$5
pkgname=$6
sudo sh -c "echo 'deb "$repo" "$channel" "$branch"' > /etc/apt/sources.list.d/'$group'.list"
wget -O - "$key" |sudo apt-key add -
sudo apt update && sudo apt install -y "$pkgname"