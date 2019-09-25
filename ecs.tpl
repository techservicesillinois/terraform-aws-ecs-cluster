#!/bin/bash
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html/managing_containers/managing_storage_with_docker_formatted_containers

stop ecs
service docker stop

# cleanup devicemapper
dmsetup remove_all
vgremove --force docker

# setup our volume for overlay2 usage
mkfs -t ext4 -L docker -i 4096 -F /dev/xvdcz
rm -fr /var/lib/docker
mkdir /var/lib/docker

# mount /dev/xvdcz
echo "/dev/xvdcz /var/lib/docker  ext4 defaults,noatime  1   1" >> /etc/fstab
mount /var/lib/docker

# configure docker to use overlay2
echo 'DOCKER_STORAGE_OPTIONS="--storage-driver=overlay2"' > /etc/sysconfig/docker-storage

# enable splunk driver
echo ECS_AVAILABLE_LOGGING_DRIVERS='["splunk","awslogs"]' >> /etc/ecs/ecs.config

service docker start

# http://docs.aws.amazon.com/AmazonECS/latest/developerguide/bootstrap_container_instance.html
cat << 'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=${ecs_cluster_name}
EOF

# re-setup the ecs agent
# it uses an upstart script in /etc/init/ecs.conf, so we use 'start' to control it
rm -rf /var/lib/ecs/data/* /var/cache/ecs/*
start ecs
