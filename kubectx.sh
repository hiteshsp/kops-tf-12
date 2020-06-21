#!/bin/bash
kops export kubecfg --name omarelk-cluster.k8s.local --state s3://omar-kops-state
kops rolling-update cluster --cloudonly --force --yes --state s3://omar-kops-state
