#!/bin/bash

DOCKER="/usr/bin/docker"
DRYRUN=0

while [ "$#" -gt 0 ]; do
   flag=$1
   case $flag in
       --dry-run | -dry-run) DRYRUN=1 ;;
       -h | --h ) 
                   echo "$0 --dry-run # run in dry mode"
                   echo "$0                # run in prod mode"
                   exit 0 ;;
       * ) ;;
   esac
   shift
done

echo  "\n\n ====== Starting the Docker Clean Up Script ====== \n\n"

echo  "Step 1. Checking Docker images with imageID as 'None' "
noneImages=$($DOCKER images | grep -w "<none>" | awk '{print $3}')
if [ "${noneImages}" != "" ];then
        for nImages in ${noneImages}
        do
          echo ${nImages}
          if [ $DRYRUN -eq 0 ]; then
                ${DOCKER} rmi -f ${nImages}

                if [ $? -eq 0 ]; then
                        echo "\n - Docker image with ImageId: ${nImages} Deleted Successfully \n"
                else
                        echo "\n !! Error while deleting Docker image with ImageId: ${nImages} !!\n"
                fi
          fi
        done
else
        echo "\n == [Image ID with <none>]:No Docker Images to delete == \n"
fi
echo  "Step 2. Removing all stopped containers"
oldContainers=$($DOCKER ps -a | grep "Dead\|Exited" | awk '{print $1}')
if [ "$oldContainers" != "" ]; then
        for oContainers in $oldContainers
        do
          echo $oContainers
          if [ $DRYRUN -eq 0 ]; then
             $DOCKER rm ${oContainers} 
             if [ $? -eq 0 ]; then
                        echo "\n - [Dead|Exited] Docker container with ContainerID: ${oContainers} Deleted Successfully  \n" 
             else
                        echo "\n !! [Dead|Exited] Error while deleting Docker image with COntainedID: ${oContainers} !! \n" 
              fi
          fi
        done
else
  echo  "\n == There no Docker containers with status as 'Exited' == \n" 
fi


