#!/bin/bash

ARGUMENT_LIST=(
    "log-path"
    "log-error-path"
)

opts=$(getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)

eval set --${opts}

while true ; do
    case "$1" in
        --log-path)
            case "$2" in
                "") echo "ERROR: LOG_PATH not specified. Set up BOX:SYNC_PATH in config.yaml"; exit 1 ;;
                *) LOG_PATH=$2; echo "==> LOG_PATH: ${LOG_PATH}"; shift 2 ;;
            esac ;;
        --log-error-path)
            case "$2" in
                "") echo "ERROR: LOG_ERROR_PATH not specified. Set up BOX:SYNC_PATH in config.yaml"; exit 1 ;;
                *) LOG_ERROR_PATH=$2; echo "==> LOG_ERROR_PATH: ${LOG_ERROR_PATH}"; shift 2 ;;
            esac ;;
        *)
            break
            ;;
    esac
done

mes="$(date +"%y-%m-%d %T")"
printf "START: ${mes}\n\n" > ${LOG_PATH}
printf "START: ${mes}\n\n" > ${LOG_ERROR_PATH}

echo "==> Enabling ssh clear text auth"
sed -i 's/PasswordAuthentication no//g' /etc/ssh/sshd_config 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}

echo "==> Enabling sudo (adding the user to the wheel group)"
usermod -aG wheel vagrant 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}

echo "==> Disabling SELinux"
setenforce 0 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}
bash -c "cat <<EOF > /etc/selinux/config
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
EOF"

echo "==> Installing ansible"
yum -y install ansible 1>>${LOG_PATH} 2>>${LOG_ERROR_PATH}