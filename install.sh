#!/usr/bin/env bash

#check flag --user
if [ "$1" == "--user" ]; then
    systemd_dir=${home}/.config/systemd
    systemd_units_dir=${systemd_dir}/user
    mkdir -p ${systemd_units_dir}
else
    systemd_dir=/etc/systemd
    systemd_units_dir=${systemd_dir}/system
fi
install(){
    cd /tmp
    git clone https://github.com/zicstardust/saci-scripts.git
    scripts=$( ls /tmp/saci-scripts/scripts )
    for i in $scripts; do
        mv saci-scripts/scripts/${i}/${i}.service ${systemd_units_dir}
        mv saci-scripts/scripts/${i}/${i}.timer ${systemd_units_dir}
        mv saci-scripts/scripts/${i}/${i}.sh ${systemd_dir}
        chmod +x ${systemd_dir}/${i}.sh
    done
    rm -Rf /tmp/saci-scripts
    if [ "$1" == "--user" ]; then
        systemctl --user daemon-reload
    else
        systemctl daemon-reload
    fi
}

install
