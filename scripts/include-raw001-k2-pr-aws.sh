# expected test data (total is 8 but we are testing or percent readiness of 90 - rounds to 7)
NODECOUNT=7

# make sure everything deployed ok
docker run \
  -e "KUBECONFIG=${WORKSPACE}/${K2_CLUSTER_NAME}/ci-pr-${ghprbPullId}/admin.kubeconfig" \
  -e "HELM_HOME=${WORKSPACE}/${K2_CLUSTER_NAME}/ci-pr-${ghprbPullId}/.helm" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  helm status kubedns | grep "STATUS\: DEPLOYED" || { echo 'kubedns release did not deploy'; exit 1; }

node_count=$(docker run \
  -e "KUBECONFIG=${WORKSPACE}/${K2_CLUSTER_NAME}/ci-pr-${ghprbPullId}/admin.kubeconfig" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  kubectl get nodes --no-headers | wc -l)
if [ "$node_count" -lt "${NODECOUNT}" ]; then echo 'node count ($node_count) is less than ${NODECOUNT}'; exit 1; fi

docker run \
  -e "KUBECONFIG=${WORKSPACE}/${K2_CLUSTER_NAME}/ci-pr-${ghprbPullId}/admin.kubeconfig" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  kubectl get pods --all-namespaces | grep tiller-deploy  || { echo 'tiller pod is not present'; exit 1; }

docker run \
  -e "KUBECONFIG=${WORKSPACE}/${K2_CLUSTER_NAME}/ci-pr-${ghprbPullId}/admin.kubeconfig" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  kubectl get services --all-namespaces | grep 'kube-system[[:space:]]*kube-dns' || { echo 'kubedns service is not present'; exit 1; }

docker run \
  -e "KUBECONFIG=${WORKSPACE}/${K2_CLUSTER_NAME}/ci-pr-${ghprbPullId}/admin.kubeconfig" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  kubectl get pods --all-namespaces | grep kube-dns || { echo 'kube dns pod is not present'; exit 1; }
