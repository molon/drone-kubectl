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

# cluster
if [ ! -z ${K8S_CLUSTER_CERT} ]; then
  echo ${K8S_CLUSTER_CERT} | base64 -d > ca.crt
  kubectl config set-cluster bar --server=${K8S_CLUSTER_SERVER} --certificate-authority=ca.crt
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

echo $'\n-----\nkubectl init completed\n-----\n'

# test ok
kubectl version


echo $'\n----\n'
echo ${PLUGIN_CMDS}
echo $'\n----\n'

# exec bash
echo $'\n----\nexec bash shell\n----\n'

if [[ -n ${PLUGIN_BASH_SHELL} && -n ${PLUGIN_BASH_SHELL_PATH} ]]; then
    echo $'bash_shell and bash_shell_path are all not empty, use bash_shell'
fi

if [[ -n ${PLUGIN_BASH_SHELL} ]]; then
    echo ${PLUGIN_BASH_SHELL} | bash
elif [[ -n ${PLUGIN_BASH_SHELL_PATH} ]]; then
    bash ${PLUGIN_BASH_SHELL_PATH}
else
    echo $'bash_shell and bash_shell_path are all empty, no shell to exec'
fi