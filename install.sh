#!/usr/bin/env bash

install(){
    cd /tmp
    git clone https://github.com/zicstardust/saci-scripts.git
    scripts=$( ls /tmp/saci-scripts/scripts )
    for i in $scripts; do
        mv saci-scripts/scripts/${i}/${i}.service /etc/systemd/system/
        mv saci-scripts/scripts/${i}/${i}.timer /etc/systemd/system/
        mv saci-scripts/scripts/${i}/${i}.sh /etc/systemd/
        chmod +x /etc/systemd/${i}.sh
    done
    rm -Rf /tmp/saci-scripts
    systemctl daemon-reload
}

install
