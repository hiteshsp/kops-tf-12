#!/bin/bash
kops export kubecfg --name hiteshelk-cluster.k8s.local --state s3://hitesh-kops-state
kops rolling-update cluster --cloudonly --force --yes --state s3://hitesh-kops-state
