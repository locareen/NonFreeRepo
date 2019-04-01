#!/bin/sh
addrepo(){
    sudo sh -c "echo 'deb "$repo" "$channel" "$branch"' > /etc/apt/sources.list.d/'$group'.list"
    wget -O - "$key" |sudo apt-key add -
    sudo apt update
}

repo=$1

if [$repo == "ppa:*"]; then
    pkgname=$2
    sudo add-apt-repository "$repo"
else
    channel=$2
    branch=$3
    group=$4
    key=$5
    pkgname=$6
    option=$7

    if [$pkgname == "winehq-*"]; then
        sudo dpkg --add-architecture i386
        addrepo()
    elif [$2 =="-i"]; then
        pkgname=$1
    elif [$2 == "-g"]; then
        url=$1
        cd ~
        wget "$url"
        tar -zxvf flash_player_sa_linux.x86_64.tar.gz
        rm flash_player_sa_linux.x86_64.tar.gz
    elif [$2 == "-c"]; then
        package=$1
        cd /tmp
        curl "$key" | gpg --dearmor > microsoft.gpg
        sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c "echo 'deb "$repo" "$channel" "$branch"' > /etc/apt/sources.list.d/'$group'.list"
        sudo apt update
    else
        addrepo()
    fi
fi
if [$option == -r]; then
    sudo apt install --install-recommends "$pkgname"
else
    sudo apt install -y "$pkgname"
fi
if [$pkgname == "anbox-modules-dkms"]; then
    sudo modprobe ashmem_linux
    sudo modprobe binder_linux
    sudo snap install --devmode --beta anbox
    sudo apt install android-tools-adb
    sudo ldconfig
    LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libgtk3-nocsd.so.0 anbox launch --package=org.anbox.appmgr --component=org.anbox.appmgr.AppViewActivity
elif [$pkgname == "kdeconnect"]; then
    sudo ufw allow 1714:1764/udp
    sudo ufw allow 1714:1764/tcp
    sudo ufw reload
fi
