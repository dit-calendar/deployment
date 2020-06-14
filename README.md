* kubernetes
  * set up kubectl
    * `export KUBECONFIG=$HOME/Downloads/okteto-kube.config:${KUBECONFIG:-$HOME/.kube/config}`
    * `kubectl get all`
  * update pod `kubectl apply -f k8s.yml`
* heroku
  * build image
    * `docker build -t ditcalendar/okteto .`
  * deploy to heroku
    * `heroku container:push web --app dit-calendar-okteto`
    * `heroku container:release web --app dit-calendar-okteto`