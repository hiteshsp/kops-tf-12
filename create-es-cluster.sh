#!/bin/bash

helm repo add elastic https://helm.elastic.co
helm install elasticsearch elastic/elasticsearch --set service.type=LoadBalancer
