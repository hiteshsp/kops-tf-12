#!/bin/bash
set -e
TF_OUTPUT=$(terraform output -json)
CLUSTER_NAME="$(echo ${TF_OUTPUT} | jq -r .kubernetes_cluster_name.value)"
kops toolbox template --name ${CLUSTER_NAME} --values <( echo ${TF_OUTPUT}) --template cluster-template.yml --format-yaml > cluster.yml
STATE="s3://$(echo ${TF_OUTPUT} | jq -r .kops_s3_bucket.value)"
kops replace -f cluster.yml --state ${STATE} --name ${CLUSTER_NAME} --force
kops create secret --name ${CLUSTER_NAME} sshpublickey admin -i /home/ubuntu/.ssh/id_rsa.pub --state ${STATE}
kops update cluster --target terraform --state ${STATE} --name ${CLUSTER_NAME} --out ../
cd ../
terraform init && terraform 0.12upgrade -yes
terraform apply -auto-approve
#kops export kubecfg --name ${CLUSTER_NAME} --state ${STATE}
#kubectl config set-cluster ${CLUSTER_NAME} --server=https://api.${CLUSTER_NAME}
#kops update cluster ${CLUSTER_NAME} --state ${STATE} --yes
#kops rolling-update cluster --cloudonly --force --yes --state ${STATE}
#sleep 3m
#kops validate cluster ${CLUSTER_NAME} --state ${STATE}
set +e
