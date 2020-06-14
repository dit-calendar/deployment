* kubernetes
  * set up kubectl
    * `export KUBECONFIG=$HOME/Downloads/okteto-kube.config:${KUBECONFIG:-$HOME/.kube/config}`
    * `kubectl get all`
  * update pod `kubectl apply -f k8s.yml`