drone_kubectl

```
docker run --rm \
  -e PLUGIN_K8S_CLUSTER_SERVER=https://172.16.99.99:6443 \
  -e PLUGIN_K8S_CLUSTER_CERT=LS0tLS1CRUdJT... \
  -e PLUGIN_K8S_USER_TOKEN=ZXlKaGJHY2... \
  molon/drone_kubectl
```