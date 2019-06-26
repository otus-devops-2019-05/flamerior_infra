#! /bin/bash
ID_PROJECT=infra-244206
INST_NAME=reddit
PORT=9292
TAGS=puma-server
IMAGE_FAMILY=reddit-full
DISK_SIZE=10GB
TYPE_MACHINE=f1-micro
ZONE=us-central1-a

gcloud compute instances create $INST_NAME \
--boot-disk-size=$DISK_SIZE \
--image-family $IMAGE_FAMILY \
--machine-type=$TYPE_MACHINE \
--tags $TAGS \
--restart-on-failure \
--zone $ZONE

gcloud compute --project=$ID_PROJECT firewall-rules create default-puma-server \
--direction=INGRESS --priority=1000 --network=default --action=ALLOW \
--rules=tcp:$PORT \
--source-ranges=0.0.0.0/0 \
--target-tags=$TAGS
