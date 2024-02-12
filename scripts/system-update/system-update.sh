#!/usr/bin/env bash

start(){
    echo "---------------Start update---------------"
    apt update -y
    apt upgrade -y
    apt autoremove -y
    echo "---------------End update-----------------"
}

gen-config-file(){
    if [ -e ${config_file} ];then
        cat ${config_file} 1> ${config_file}_old
    fi
    cat > ${config_file} <<EOF

EOF
}

check_root(){
    is_root=$(whoami)
    if [ ${is_root} != "root" ]; then
	    echo "run as root"
	    exit 2
    fi
}

check_and_run (){
    check_root
    start    
}

if [ "${1}" == "gen-config-file" ]; then
    gen-config-file
else
    check_and_run
fi
