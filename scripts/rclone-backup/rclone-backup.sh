#!/usr/bin/env bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
config_file=${script_dir}/rclone-backup.config
source $config_file

start(){
    echo "=============Start rclone backup===================="
    if [ ${REMOTE_TO_LOCAL[$i]} == "S" ];then
        echo "---BACKUP FROM ${REMOTE[$i]}:${SOURCE_DIR[$i]} TO ${DESTINY_DIR[$i]}---"
        rclone sync "${REMOTE[$i]}:${SOURCE_DIR[$i]}" "${DESTINY_DIR[$i]}" -v
    else
        echo "---BACKUP FROM ${SOURCE_DIR[$i]} TO ${REMOTE[$i]}:${DESTINY_DIR[$i]}---"
        rclone sync "${SOURCE_DIR[$i]}" "${REMOTE[$i]}:${DESTINY_DIR[$i]}" -v
    fi
    echo "=============End rclone backup===================="
}

gen-config-file(){
    if [ -e ${config_file} ];then
        cat ${config_file} 1> ${config_file}_old
    fi
    cat > ${config_file} <<EOF
REMOTE_TO_LOCAL[0]=
REMOTE[0]=
SOURCE_DIR[0]=
DESTINY_DIR[0]=

EOF
}

check_and_run (){
    size=${#SOURCE_DIR[@]}
    for (( i=0; i<${size}; i++)); do
        start
    done
}

if [ $1 == "gen-config-file" ]; then
    gen-config-file
else
    check_and_run
fi
