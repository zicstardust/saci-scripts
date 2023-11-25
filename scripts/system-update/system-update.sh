#!/usr/bin/env bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
config_file=${script_dir}/system-update.config
source $config_file

start(){
    echo "---------------Start update---------------"
    apt update -y
    apt upgrade -y
    apt autoremove -y

    directories=$(ls ${REPOS_DIR})
    for i in ${directories}; do
        sudo su -c "git -C ${REPOS_DIR}/${i} pull" ${OS_USER}
    done
    echo "---------------End update-----------------"
}

gen-config-file(){
    if [ -e ${config_file} ];then
        cat ${config_file} 1> ${config_file}_old
    fi
    cat > ${config_file} <<EOF
OS_USER=
REPOS_DIR=

EOF
}

check_and_run (){
    if [ -z ${REPOS_DIR} ]; then
        echo "REPOS_DIR not declared in config file"
        exit 2
    elif [ -z ${OS_USER} ]; then
        echo "OS_USER not declared in config file"
        exit 2
    else
        start
    fi
}

if [ "${1}" == "gen-config-file" ]; then
    gen-config-file
else
    check_and_run
fi
