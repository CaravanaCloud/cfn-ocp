#!/bin/bash -xe

export AWS_PAGER=""

OCP_INSTALL_AMI="ami-06cd52961ce9f0d85"
OCP_INSTALL_USERDATA="file://ocp-install-userdata-ali.sh"
OCP_INSTALL_INSTANCE_TYPE="t3.medium"
OCP_INSTALL_PROFILE="ocp-install-profile"
OCP_INSTALL_SUBNET="$OCP_INSTALL_SUBNET"
OCP_INSTALL_CONFIG="https://s3.ap-northeast-1.amazonaws.com/ap-northeast-1.openshift.caravana.cloud/install-config.yaml"

aws sts get-caller-identity

aws ec2 run-instances \
   --image-id "$OCP_INSTALL_AMI" \
   --user-data "$OCP_INSTALL_USERDATA" \
   --instance-type "$OCP_INSTALL_INSTANCE_TYPE" \
   --subnet-id "$OCP_INSTALL_SUBNET" \
   --iam-instance-profile "Name=$OCP_INSTALL_PROFILE" \
   --tag-specifications "ResourceType=instance,Tags=[{Key=OCP_INSTALL_CONFIG,Value=$OCP_INSTALL_CONFIG}]" \
   --output "json"
