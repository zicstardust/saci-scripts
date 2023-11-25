#!/usr/bin/env bash

#script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#config_file=${script_dir}/system-update.config
#source $config_file

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

check_and_run (){
    start    
}

if [ "${1}" == "gen-config-file" ]; then
    gen-config-file
else
    check_and_run
fi
