# expected test data (total is 8 but we are testing or percent readiness of 90 - rounds to 7)
NODECOUNT=15

node_count=$(docker run \
  -e "KUBECONFIG=${WORKSPACE}/${K2_CLUSTER_NAME}/ci-pr-${ghprbPullId}-gke/admin.kubeconfig" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  kubectl get nodes --no-headers | wc -l)
if [ "$node_count" -ne "${NODECOUNT}" ]; then echo "node count ($node_count) is not equal to ${NODECOUNT}"; exit 1; fi

docker run \
  -e "KUBECONFIG=${WORKSPACE}/${K2_CLUSTER_NAME}/ci-pr-${ghprbPullId}-gke/admin.kubeconfig" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  kubectl get pods --all-namespaces | grep tiller-deploy  || { echo 'tiller pod is not present'; exit 1; }
