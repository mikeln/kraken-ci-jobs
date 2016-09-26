# expected test data 
NODECOUNT=8
APISERVERCOUNT=3
CONTROLLERCOUNT=3
PROXYCOUNT=8
SCHEDULERCOUNT=3
DNSCOUNT=1
TILLERCOUNT=1

# make sure everything deployed ok
docker run -it \
  -e "KUBECONFIG=/k2/jenkins-pr-${ghprbPullId}/admin.kubeconfig" \
  -e "HELM_HOME=/k2/jenkins-pr-${ghprbPullId}/.helm" \
  -v ${WORKSPACE}:/k2 \
  ${K2_CONTAINER_IMAGE} \
  helm status kubedns | grep "Status\: DEPLOYED" || { echo 'kubedns release did not deploy'; exit 1; }

node_count=$(docker run -it \
  -e "KUBECONFIG=/k2/jenkins-pr-${ghprbPullId}/admin.kubeconfig" \
  -v ${WORKSPACE}:/k2 \
  ${K2_CONTAINER_IMAGE} \
  kubectl get nodes --no-headers | wc -l)

if [ "$node_count" -ne "${NODECOUNT}" ]; echo 'node count is incorrect'; exit 1; fi

docker run -it \
  -e "KUBECONFIG=/k2/jenkins-pr-${ghprbPullId}/admin.kubeconfig" \
  -v ${WORKSPACE}:/k2 \
  ${K2_CONTAINER_IMAGE} \
  kubectl get services --all-namespaces | grep 'kube-system[[:space:]]*kube-dns' || { echo 'kubedns service is not present'; exit 1; }

api_count=$(docker run -it \
  -e "KUBECONFIG=/k2/jenkins-pr-${ghprbPullId}/admin.kubeconfig" \
  -v ${WORKSPACE}:/k2 \
  ${K2_CONTAINER_IMAGE} \
  kubectl get pods --all-namespaces | grep kube-apiserver-ip | wc -l)
if [ "$api_count" -ne "${APICOUNT}" ]; echo 'api server pod count is incorrect'; exit 1; fi

controller_count=$(docker run -it \
  -e "KUBECONFIG=/k2/jenkins-pr-${ghprbPullId}/admin.kubeconfig" \
  -v ${WORKSPACE}:/k2 \
  ${K2_CONTAINER_IMAGE} \
  kubectl get pods --all-namespaces | grep kube-controller-manager | wc -l)
if [ "$controller_count" -ne "${CONTROLLERCOUNT}" ]; echo 'controller manager pod count is incorrect'; exit 1; fi

proxy_count=$(docker run -it \
  -e "KUBECONFIG=/k2/jenkins-pr-${ghprbPullId}/admin.kubeconfig" \
  -v ${WORKSPACE}:/k2 \
  ${K2_CONTAINER_IMAGE} \
  kubectl get pods --all-namespaces | grep kube-proxy-ip | wc -l)
if [ "$proxy_count" -ne "${PROXYCOUNT}" ]; echo 'kube proxy pod count is incorrect'; exit 1; fi

scheduler_count=$(docker run -it \
  -e "KUBECONFIG=/k2/jenkins-pr-${ghprbPullId}/admin.kubeconfig" \
  -v ${WORKSPACE}:/k2 \
  ${K2_CONTAINER_IMAGE} \
  kubectl get pods --all-namespaces | grep kube-scheduler-ip | wc -l)
if [ "$scheduler_count" -ne "${SCHEDULERCOUNT}" ]; echo 'scheduler pod count is incorrect'; exit 1; fi

dns_count=$(docker run -it \
  -e "KUBECONFIG=/k2/jenkins-pr-${ghprbPullId}/admin.kubeconfig" \
  -v ${WORKSPACE}:/k2 \
  ${K2_CONTAINER_IMAGE} \
  kubectl get pods --all-namespaces | grep kube-dns | wc -l)
if [ "$dns_count" -ne "${DNSCOUNT}" ]; echo 'kube dns count is incorrect'; exit 1; fi

tiller_count=$(docker run -it \
  -e "KUBECONFIG=/k2/jenkins-pr-${ghprbPullId}/admin.kubeconfig" \
  -v ${WORKSPACE}:/k2 \
  ${K2_CONTAINER_IMAGE} \
  kubectl get pods --all-namespaces | grep tiller-deploy | wc -l)
if [ "$tiller_count" -ne "${TILLERCOUNT}" ]; echo 'tiller pod count is incorrect'; exit 1; fi
