#!/bin/bash -xe

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
  echo "Update system packages"
  yum -y update
  echo "Install logging agent"
  mkdir -p "/opt/aws/amazon-cloudwatch-agent/etc/"
  curl -s "https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm" --output "/tmp/amazon-cloudwatch-agent.rpm"
  curl -s "https://raw.githubusercontent.com/CaravanaCloud/cfn-ocp/main/ocp-userdata/ocp-install-cloudwatch.json" --output "/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json"
  rpm -Uvh "/tmp/amazon-cloudwatch-agent.rpm"
  rpm -qlp "/tmp/amazon-cloudwatch-agent.rpm"
  ls "/opt/aws"
  /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:///opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

  echo "Install openshift installer"
  echo "Run openshift installer"
  echo "Terminate instance"
  echo "user-data completed successfully."
  echo "done."