#drone-kubectl

```
docker run --rm \
  -e PLUGIN_K8S_CLUSTER_SERVER=https://172.16.99.99:6443 \
  -e PLUGIN_K8S_CLUSTER_CERT=LS0tLS1CRUdJT... \
  -e PLUGIN_K8S_USER_TOKEN=ZXlKaGJHY2... \
  -e PLUGIN_CMDS='kubectl get pods -n staging,kubectl apply -f mainifest.yml' \
  molon/drone-kubectl
```

Get the `PLUGIN_K8S_CLUSTER_CERT` and `PLUGIN_K8S_USER_TOKEN`
```
kubectl -n {{serviceaccount namespace}} get secret $(kubectl -n {{serviceaccount namespace}} get secrets | grep {{serviceaccount name}} | awk -F " " '{print $1}') -o yaml | egrep 'ca.crt:|token:'
```