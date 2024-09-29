#!/bin/bash

#---------------------------------------------#
# Author: vishwaranjan pandey
# Call/Whatsapp: +91-9717809862
#---------------------------------------------#


DOCKER="/usr/bin/docker"
DRYRUN=0

while [ "$#" -gt 0 ]; do
    flag=$1
    case $flag in 
        --dry-run | -dry-run ) DRYRUN=1 ;;
        -h | --h )
                    echo "$0 --dry-run    # to run in dry mode"
                    echo "$0              # to run in production mode"
                    exit 0 ;;
        * ) ;;
esac
shift
done


echo  "\n\n ====== Starting the Docker Clean Up Script ====== \n\n"

echo  "Step 1. Checking Docker images with imageID as 'None' "

nonImages=$($DOCKER images | grep -w "<none>" | awk '{print $3}')

if [ "${nonImages}" != "" ]; then

    for nImage in ${nonImages}
    do
    echo " $nonImages "
        if [ $DRYRUN -eq 0 ]; then
            ${DOCKER} rmi -f ${nImage}

            if [ $? -eq 0 ]; then
                echo "\n - Docker image with ImageId: ${nImages} Deleted Successfully \n"
            else
                echo "\n !! Error while deleting Docker image with ImageId: ${nImages} !!\n"
            fi
        fi
    done
else
     echo "\n == [ Image ID with <none> ]: No Docker Image To Delete == \n"
fi
echo  "Step 2. Removing all stopped containers"

containerID=$($DOCKER ps -a | grep -w "Dead\|Exited" | awk '{print $1}')

if [ "${containerID}" != "" ]; then
    for Ocontainer in ${containerID} 
    do 
    echo "$containerID"
        if [ $DRYRUN -eq 0 ]; then
            $DOCKER rm ${Ocontainer} 
            if [ $? -eq 0 ]; then
                echo "\n - [Dead|Exited] Docker container with ContainerID: ${Ocontainer} Deleted Successfully  \n"
	    else
		   echo "\n !! [Dead|Exited] Error while deleting Docker image with COntainedID: ${Ocontainer} !! \n"  
	    fi
        fi
    done
else 
    echo  "\n == There no Docker containers with status as "Exited" == \n" 
fi



echo  "Step 3. Deleting old images which are two months old "

oldImages=$($DOCKER images | awk '{print $3,$4,$5}' | grep '[5-9]\{1\}\ weeks\|years\|months' | awk '{print $1}')

if [ "${oldImages}" != "" ]; then
    for oImage in $oldImages
    do
     echo "$oldImages"
        if [ $DRYRUN -eq 0 ]; then
             $DOCKER rmi -f ${oImage}
            if [ $? -eq 0 ]; then
                echo "\n -  Docker image with ImageId: ${oImage} Delted Successfully \n"
             else
                echo "\n !! Error while deleting Docker image with ImageId: ${oImage} !! \n"
            fi
        fi
     done
 else
      echo  "\n == No Docker dangaling Images to delete == \n"
fi

echo  "Step 4. Deleting dangling images "
dangalingImages=$($DOCKER images -qf dangling=true)
if [ "$dangalingImages" != "" ]; then
        for dImages in ${dangalingImages}
        do
               echo $dImages
                if [ $DRYRUN -eq 0 ]; then
                   ${DOCKER} rmi -f ${dImages} 
                    if [ $? -eq 0 ]; then
                        echo "\n -  Docker image with ImageId: ${dImages} Delted Successfully \n" 
                    else
                        echo "\n !! Error while deleting Docker image with ImageId: ${dImages} !! \n" 
                     fi
                fi
        done
else
        echo  "\n == No Docker dangaling Images to delete == \n"
fi


echo  "Step 5. Clean up unused docker volumes"
unUsedVolumes=$($DOCKER volume ls -qf dangling=true)
if [ "$unUsedVolumes" != "" ]; then
        for uVolumes in ${unUsedVolumes}
        do
               echo $uVolumes
                if [ $DRYRUN -eq 0 ]; then
                  ${DOCKER} rmi -f ${uVolumes} 
                   if [ $? -eq 0 ]; then
                        echo "\n - Docker volume with VolumeId: ${uVolumes} Delted Successfully \n" 
                   else
                        echo "\n!! Error while deleting Docker volume with VolumeId: ${uVolumes} !! \n" 
                   fi
                fi
        done
else
        echo  "\n== No Docker volumes to delete =="
fi

echo "\n====== END OF SCRIPT  ====== \n\n"


