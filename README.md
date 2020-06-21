# Kops - Terraform

This repository contains code to deploy kops cluster for installing ElasticSearch   

# Features

  - Maintain kops in a fully automated way
  - Maintain state using Terraform
  - Dependencies installed via Ansibel

### Tech

Kops - Terraform uses a number of open source projects to work properly:

* Ansible as configuration management
* Terraform as IAC
* AWS as the Infrastructure
* Kops for administering k8s clusters
* Bash scripts for some post installation tasks

### Prerequisites
1. Ansible
2. Python
3. AWS CLI
4. Configure AWS CLI with credentials 

### Installation
Run the following playbook to create a kubernetes cluster.
```
ansible-playbook -i <inventory file> site.yml
```
The playbook creates the kops cluster but doesn't assign certs to the loadbalancer in order to do that run the below bash script
```
bash kubectx.sh
```
After the machines become ready you should be able to run the `kubectl` commands

Lastly to create elasticsearch cluster run the following command.

```
bash create-es-cluster.sh
```
