#!/bin/bash
set +e
echo "####################################################"
echo "## 	  Welcome to Kops Installation :)	##"
echo "####################################################"
echo 
echo
echo
echo
echo "Generating a ssh keypair....."
ssh-keygen -b 2048 -t rsa -q -P "" -f "/home/$USER/.ssh/id_rsa" 0>&-
sleep 5
echo "Installing aws cli..."
sudo apt install awscli unzip -y
sleep 10
echo "Creating and configuring a S3 bucket ...."
aws s3api create-bucket --bucket $1
aws s3api put-bucket-versioning --bucket $1 --versioning-configuration Status=Enabled
echo
echo
export KOPS_STATE_STORE=s3://$1
echo "Installing kubectl & kops"
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl
curl -LO https://github.com/kubernetes/kops/releases/download/v1.17.0-alpha.4/kops-linux-amd64 && chmod +x kops-linux-amd64 && sudo mv kops-linux-amd64 /usr/local/bin/kops
sleep 10
echo
echo "Creating the kops cluster..."
kops create cluster \
--name $2 \
--zones us-east-1a \
--master-zones us-east-1a \
--node-count 1 \
--master-count 1 \
--node-size t3.micro \
--master-size t3.medium \
--ssh-public-key ~/.ssh/id_rsa.pub \
--topology private \
--networking calico \
--network-cidr 172.40.0.0/16 \
--target terraform \
--state s3://$1 \
--out . 
curl -LO https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip && unzip terraform_0.12.24_linux_amd64.zip && sudo mv terraform /usr/local/bin/
terraform init
sleep 5
terraform 0.12upgrade -yes
terraform apply -auto-approve
set -e
