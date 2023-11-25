#!/usr/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
config_file=${script_dir}/backup-to-disks.config
source $config_file

start(){
    echo "===========START BACKUP TO DISKS============"
    mkdir -p ${MOUNT_DIR[$i]}
    rm -Rf ${MOUNT_DIR}[$i]/*
    
    if [ ! -z ${LUKS_KEY[$i]} ] && [ ! -z ${LUKS_UUID[$i]} ] ; then
        /usr/sbin/cryptsetup luksOpen /dev/disk/by-uuid/${LUKS_UUID[$i]} ${LUKS_NAME[$i]} --key-file ${LUKS_KEY[$i]}
        if [ $? != 0 ]; then
            echo "error to open luks volume ${LUKS_UUID[$i]}"
            return
        fi
    fi
    
    mount -t btrfs -o ${MOUNT_OPTIONS[$i]} /dev/mapper/${LUKS_NAME[$i]} ${MOUNT_DIR[$i]}
    if [ $? != 0 ]; then
        echo "error to mount to ${MOUNT_DIR[$i]}"
        return
    fi
    echo "==BACKUPS TO ${MOUNT_DIR[$i]}=="
    
    for j in ${BACKUP_DIR[$i]}; do
        echo "-----------------$j-----------------------"
        echo " "
        BACKUP_DESTINY=${MOUNT_DIR[$i]}${j}
        if [ -d ${j} ]; then
            mkdir -p ${BACKUP_DESTINY}
            rsync -Aavx ${j}/ ${BACKUP_DESTINY}/ --delete
        elif [ -f ${j} ]; then
            mkdir -p ${BACKUP_DESTINY}
            cat ${j} 1> ${BACKUP_DESTINY}_backup
        else
            if [ "${j}" == "CRONTAB" ]; then
                crontab -l 1> ${MOUNT_DIR[$i]}/crontab_${USER}
            else
                echo "${j} not exist"
            fi
        fi
        echo "---------------------------------------------"
        echo " "
        echo " "
    done

    umount ${MOUNT_DIR[$i]}
    if [ ! -z ${LUKS_KEY[$i]} ] && [ ! -z ${LUKS_UUID[$i]} ] ; then
        /usr/sbin/cryptsetup luksClose ${LUKS_NAME[$i]}
    fi
        echo "==========END BACKUP TO DISKS============="
}

gen-config-file(){
    if [ -e ${config_file} ];then
        cat ${config_file} 1> ${config_file}_old
    fi
    cat > ${config_file} <<EOF
LUKS_UUID[0]=
LUKS_KEY[0]=
LUKS_NAME[0]=
MOUNT_DIR[0]=
MOUNT_OPTIONS[0]=
BACKUP_DIR[0]=

EOF
}

check_and_run (){
    size=${#MOUNT_DIR[@]}
    for (( i=0; i<${size}; i++)); do
        if [ -z ${MOUNT_DIR[$i]} ]; then
            echo "MOUNT_DIR not declared in env file"
        elif [ -z ${MOUNT_OPTIONS[$i]} ]; then
            echo "MOUNT_OPTIONS not declared in env file"
        elif [ -z ${LUKS_NAME[$i]} ]; then
            echo "LUKS_NAME not declared in env file"
        elif [ -z ${MOUNT_DIR[$i]} ]; then
            echo "MOUNT_DIR not declared in env file"
        elif [ "${BACKUP_DIR[$i]}" == "" ]; then
            echo "BACKUP_DIR not declared in env file"
        else
            start
        fi
    done
}

if [ $1 == "gen-config-file" ]; then
    gen-config-file
else
    check_and_run
fi
