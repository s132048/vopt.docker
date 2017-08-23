#!/bin/bash

VM="vopt"
IMAGE_NAME="veranostech/vopt"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

trap '[ "$?" -eq 0 ] || read -p "Looks like something went wrong... Press any key to continue..."' return

# for windows with docker toolbox
# =====================================================================================================================

dos2unix.exe ./.docker-entrypoint.sh ./6379-docker.conf ./supervisord.conf

DOCKER_MACHINE="/c/Program Files/Docker Toolbox/docker-machine.exe"

if [ ! -z "$VBOX_MSI_INSTALL_PATH" ]; then
  VBOXMANAGE="${VBOX_MSI_INSTALL_PATH}VBoxManage.exe"
else
  VBOXMANAGE="${VBOX_INSTALL_PATH}VBoxManage.exe"
fi

if [ ! -f "${DOCKER_MACHINE}" ] || [ ! -f "${VBOXMANAGE}" ]; then
  echo "Either VirtualBox or Docker Machine are not installed. Please re-run the Toolbox Installer and try again."
  return 1
fi

"${VBOXMANAGE}" list vms | grep \""${VM}"\" &> /dev/null
VM_EXISTS_CODE=$?

set -e

if [ ${VM_EXISTS_CODE} -eq 1 ]; then
  "${DOCKER_MACHINE}" rm -f "${VM}" &> /dev/null || :
  rm -rf ~/.docker/machine/machines/"${VM}"
  "${DOCKER_MACHINE}" create -d virtualbox --virtualbox-disk-size "50000" "${VM}"
fi

echo $("${DOCKER_MACHINE}" status ${VM} 2>&1)
VM_STATUS="$("${DOCKER_MACHINE}" status ${VM} 2>&1)"
if [ "${VM_STATUS}" != "Running" ]; then
  "${DOCKER_MACHINE}" start "${VM}"
  yes | "${DOCKER_MACHINE}" regenerate-certs "${VM}"
fi

eval "$("${DOCKER_MACHINE}" env --shell=bash ${VM})"

docker () {
  MSYS_NO_PATHCONV=1 docker.exe $@
}
export -f docker
# =====================================================================================================================

read -p "tag (default \"latest\"): " TAG
if [ -z "$TAG" ]; then
  TAG=latest
fi

COMMAND="docker build --rm=true -t $IMAGE_NAME:$TAG . 2>&1 | tee $(date +"%Y%m%d-%H%M%S").log"

eval ${COMMAND}

exec "${BASH}" --login -i
