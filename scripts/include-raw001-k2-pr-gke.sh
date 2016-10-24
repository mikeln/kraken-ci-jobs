# expected test data (total is 8 but we are testing or percent readiness of 90 - rounds to 7)
NODECOUNT=5

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
  kubectl get services --all-namespaces | grep 'default[[:space:]]*podpincher' || { echo 'podpincher service is not present'; exit 1; }

docker run \
  -e "KUBECONFIG=${WORKSPACE}/${K2_CLUSTER_NAME}/ci-pr-${ghprbPullId}/admin.kubeconfig" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  kubectl get pods --all-namespaces | grep podpincher || { echo 'podpincher pod is not present'; exit 1; }
