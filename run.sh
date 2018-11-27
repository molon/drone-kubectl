#!/bin/bash
# Inspired by https://github.com/honestbee/drone-kubernetes/blob/master/update.sh

# env or secrets
if [ ! -z ${PLUGIN_K8S_CLUSTER_SERVER} ]; then
  K8S_CLUSTER_SERVER=$PLUGIN_K8S_CLUSTER_SERVER
fi

if [ ! -z ${PLUGIN_K8S_CLUSTER_CERT} ]; then
  K8S_CLUSTER_CERT=${PLUGIN_K8S_CLUSTER_CERT}
fi

if [ ! -z ${PLUGIN_K8S_USER_TOKEN} ]; then
  K8S_USER_TOKEN=$PLUGIN_K8S_USER_TOKEN
fi

echo $'-----\nkubectl init\n-----\n'

# cluster
if [ ! -z ${K8S_CLUSTER_CERT} ]; then
  echo ${K8S_CLUSTER_CERT} | base64 -d > ca.crt
  kubectl config set-cluster bar --server=${K8S_CLUSTER_SERVER} --certificate-authority=ca.crt --embed-certs=true
else
  echo "WARNING: Using insecure connection to cluster"
  kubectl config set-cluster bar --server=${K8S_CLUSTER_SERVER} --insecure-skip-tls-verify=true
fi

DECODE_K8S_USER_TOKEN=$(echo ${K8S_USER_TOKEN} | base64 -d)

# user
kubectl config set-credentials foo --token=${DECODE_K8S_USER_TOKEN}

# context
kubectl config set-context foo@bar --cluster=bar --user=foo
kubectl config use-context foo@bar 

echo $'\n-----\nkubectl version\n-----\n'

# test ok
kubectl version

# eval cmds
echo $'\n----\neval cmds\n----'

IFS=',' read -ra CMD <<< "${PLUGIN_CMDS}"
for i in "${CMD[@]}"; do
    echo $'\n+ '$i
    eval "$i"
done