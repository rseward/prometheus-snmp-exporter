#!/bin/bash

DOCKERFILE=Dockerfile
REPO_URI=celeborn.bluestone-consulting.net:5000
REPO_PROJECT=balin

. ./build.conf
echo "TAG=$TAG"
if [ -z $TAG ] ; then
    echo "export TAG=0.1.1; # and retry please"
    exit 1
fi

#TAG="0.1.0"
echo "====================================================================================="
echo "Building $REPO_PROJECT:$TAG"
echo "====================================================================================="

podman login --tls-verify=false celeborn.bluestone-consulting.net:5000

buildah bud --format docker -f $DOCKERFILE -t $REPO_PROJECT | tee build.out
if [ ${PIPESTATUS[0]} -ne 0 ] ; then
    echo "FATAL: Buildah build failed!"
    echo "It is possible you might need to 'sudo setenforce 0' for this to succeed under fedora. :-("
    ls -l build.out
    exit 1
fi;

buildah tag $REPO_PROJECT:latest $REPO_URI/$REPO_PROJECT:$TAG

if [ $? -ne 0 ] ; then
    echo "FATAL: Failed to tag image! Check it and see!"
    exit 2
fi;

imgid=$(buildah images --format="{{.ID}} {{.Name}}" | grep "localhost/$REPO_PROJECT\$" | cut -d ' ' -f 1 )

buildah push --tls-verify=false $imgid $REPO_URI/$REPO_PROJECT:$TAG

if [ $? -ne 0 ] ; then
    echo "FATAL: Failed to push image to $REPO_URI"
    exit 3
fi;

echo "You should be able to pull the image now."
echo "podman pull --tls-verify=false $REPO_URI/$REPO_PROJECT:$TAG"
