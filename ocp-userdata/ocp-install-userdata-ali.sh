#!/bin/bash -xe

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
  echo "Update system packages"
  yum -y update

  echo "Install cloudwatch agent"
  mkdir -p "/opt/aws/amazon-cloudwatch-agent/etc/"
  curl -s "https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm" --output "/tmp/amazon-cloudwatch-agent.rpm"
  curl -s "https://raw.githubusercontent.com/CaravanaCloud/cfn-ocp/main/ocp-userdata/ocp-install-cloudwatch.json" --output "/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
  rpm -Uvh "/tmp/amazon-cloudwatch-agent.rpm"
  rpm -qlp "/tmp/amazon-cloudwatch-agent.rpm"
  ls "/opt/aws"
  /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:///opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

  echo "Install openshift installer"
  mkdir -p '/tmp/openshift-installer'
  curl -s 'https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-install-linux.tar.gz' --output '/tmp/openshift-installer/openshift-install-linux.tar.gz' 
  tar zxvf '/tmp/openshift-installer/openshift-install-linux.tar.gz' -C '/tmp/openshift-installer' 
  mv '/tmp/openshift-installer/openshift-install' '/usr/local/bin/'
  rm '/tmp/openshift-installer/openshift-install-linux.tar.gz'

  echo "Load configuration from tags"
  mkdir -p '/tmp/ocp/openshift-installer'
  TAG_NAME="OCP_INSTALL_CONFIG"
  INSTANCE_ID=$(curl -s http://instance-data/latest/meta-data/instance-id)
  REGION=$(curl -s http://instance-data/latest/meta-data/placement/region)
  OCP_INSTALL_CONFIG_URL=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=$TAG_NAME" --region $REGION --query "Tags[0].Value" --output=text)
  
  echo "Dowloading install config [$OCP_INSTALL_CONFIG_URL]"
  curl -s "$OCP_INSTALL_CONFIG_URL" --output "/tmp/ocp/install-config.yaml"

  echo "Run installer"
  /usr/local/bin/openshift-installer
  
  echo "Terminate instance [$INSTANCE_ID]"
  aws ec2 terminate-instances --instance-ids $INSTANCE_ID --region $REGION
  
  echo "user-data completed successfully."
