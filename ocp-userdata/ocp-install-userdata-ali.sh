#!/bin/bash -xe

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
  echo "Update system packages"
  yum -y update
  echo "Install logging agent"
  curl -s "https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm" --output "/tmp/amazon-cloudwatch-agent.rpm"
  rpm -Uvh "/tmp/amazon-cloudwatch-agent.rpm"
  echo "Install openshift installer"
  echo "Run openshift installer"
  echo "Terminate instance"
  echo "user-data completed successfully."
