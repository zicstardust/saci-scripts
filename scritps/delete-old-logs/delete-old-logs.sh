#!/usr/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
config_file=${script_dir}/delete-old-logs.config
source $config_file

start(){
    find ${LOG_DIR} -mtime +${LOG_RETENTION_DAYS} -exec rm {} \;
}

gen-config-file(){
    if [ -e ${config_file} ];then
        cat ${config_file} 1> ${config_file}_old
    fi
    cat > ${config_file} <<EOF
LOG_DIR=
LOG_RETENTION_DAYS=

EOF
}

check_and_run (){
    if [ -z ${LOG_DIR} ]; then
        echo "LOG_DIR not declared in env file"
        return
    elif [ -z ${LOG_RETENTION_DAYS} ]; then
        echo "LOG_RETENTION_DAYS not declared in env file"
        return
    else
        start
    fi
}

if [ $1 == "gen-config-file" ]; then
    gen-config-file
else
    check_and_run
fi
