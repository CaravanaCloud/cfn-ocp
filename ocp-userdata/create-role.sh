#!/bin/bash -xe

export AWS_PAGER=""

OCP_INSTALL_ROLE="ocp-install-role"
OCP_INSTALL_POLICY="ocp-install-policy"
OCP_INSTALL_PROFILE="ocp-install-profile"

aws iam create-role --role-name "$OCP_INSTALL_ROLE" \
    --assume-role-policy-document "file://ocp-install-trust.json"

aws iam attach-role-policy --role-name "$OCP_INSTALL_ROLE" \
    --policy-arn "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"  

aws iam create-instance-profile \
    --instance-profile-name "$OCP_INSTALL_PROFILE"

aws iam add-role-to-instance-profile \
    --instance-profile-name "$OCP_INSTALL_PROFILE" \
    --role-name "$OCP_INSTALL_ROLE"

echo "done"