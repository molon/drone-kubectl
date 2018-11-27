# drone-kubectl

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

.drone.yml
```
pipeline:
  deploy:
    image: molon/drone-kubectl
    secrets: [k8s_cluster_server, k8s_cluster_cert, k8s_user_token]
    cmds:
      - |
        if [ -z ${DRONE_TAG} ]; then
          export IMAGE_TAG="${DRONE_COMMIT_SHA}"
        else
          export IMAGE_TAG="${DRONE_TAG}"
        fi
      - |
        sed -e "s/{{.APP_NAME}}/app_name/g" \
            -e "s/{{.IMAGE_TAG}}/$IMAGE_TAG/g" \
            mainifest.yml | kubectl -n staging apply -f -
      - kubectl -n staging get pods
```