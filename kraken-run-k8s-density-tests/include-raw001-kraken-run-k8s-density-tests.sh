#!/bin/bash

KRAKEN_ROOT=${KRAKEN_ROOT:-${WORKSPACE}}
KRAKEN_CLUSTER_DIR="${KRAKEN_ROOT}/bin/clusters/${KRAKEN_CLUSTER_NAME}"
KUBECONFIG=${KUBECONFIG:-"${KRAKEN_CLUSTER_DIR}/kube_config"}

## setup

# ensure kraken-connect has been called so kube_config is present
${KRAKEN_ROOT}/bin/kraken-connect.sh \
  --clustername "${KRAKEN_CLUSTER_NAME}" \
  --clustertype aws \
    --dmname "${PIPELET_DOCKERMACHINE}" \
    --dmshell bash

# identify unschedulable nodes
unschedulable_regex="node-001"
node_label_csv_list="kraken-node"
unschedulable_nodes=$(kubectl --kubeconfig=${KUBECONFIG} get nodes -L ${node_label_csv_list} | grep ${unschedulable_regex} | awk '{ print $1 }')

# mark unschedulable nodes
for node in ${unschedulable_nodes}; do
  kubectl --kubeconfig=${KUBECONFIG} patch nodes ${node} -p '{"spec": {"unschedulable": true}}'
done

# cleanup any pre-existing density namespaces
KUBECONFIG=${KUBECONFIG} ${KRAKEN_ROOT}/hack/terminate-namespace.sh density

## run

# TODO: unclear what part of k8s scripts require USER to be set
# TODO: should we just drop test build functionality
KUBE_DENSITY_LOG=${KRAKEN_ROOT}/${BUILD_TAG}-${DENSITY}.log
export KUBE_ROOT=${KUBE_ROOT:-"/var/lib/docker/gobuild/${KUBE_TESTS_DIR}"}
export KUBE_DENSITY_KUBECONFIG=${KUBECONFIG}
export KUBE_DENSITY_NUM_NODES=${NUMBER_OF_NODES}
export KUBE_DENSITY_OUTPUT_DIR=${KRAKEN_ROOT}/output
export KUBE_SSH_USER="core"
export KUBE_SSH_KEY="${KRAKEN_CLUSTER_DIR}/id_rsa"
REBUILD_TESTS=false USER=jenkins ${KRAKEN_ROOT}/hack/density.sh ${KUBE_TESTS_BRANCH} ${DENSITY} | tee ${KUBE_DENSITY_LOG}
# tee isn't exiting >0 as expected, so use the exit status of the script directly
density_result=${PIPESTATUS[0]}

## teardown

# remove leftover density namespaces
${KRAKEN_ROOT}/hack/namespace_cleanup.sh --etcd etcd --config ${KRAKEN_CLUSTER_DIR}/ssh_config --key ${KRAKEN_CLUSTER_DIR}/id_rsa

# unmark unschedulable nodes
for node in ${unschedulable_nodes}; do
  kubectl --kubeconfig=${KUBECONFIG} patch nodes ${node} -p '{"spec": {"unschedulable": false}}'
done

exit ${density_result}
