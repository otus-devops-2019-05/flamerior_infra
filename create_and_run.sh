#! /bin/bash
#generating startup script
source ./generate_startup.sh

#creating instance with startup script
gcloud compute instances create reddit-app \
--boot-disk-size=10GB \
--image-family ubuntu-1604-lts \
--image-project=ubuntu-os-cloud \
--machine-type=g1-small \
--tags puma-server \
--restart-on-failure \
--zone us-central1-a \
--metadata-from-file startup-script=./startup.sh

#generating firewall rule
gcloud compute --project=infra-244206 firewall-rules create default-puma-server \
--direction=INGRESS --priority=1000 --network=default --action=ALLOW \
--rules=tcp:9292 \
--source-ranges=0.0.0.0/0 \
--target-tags=puma-server
