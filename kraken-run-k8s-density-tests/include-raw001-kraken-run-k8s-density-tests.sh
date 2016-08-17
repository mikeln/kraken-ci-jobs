#!/bin/bash

KRAKEN_ROOT=${KRAKEN_ROOT:-${WORKSPACE}}

## setup

# setup output dir
OUTPUT_DIR="${KRAKEN_ROOT}/output"
mkdir -p "${OUTPUT_DIR}/artifacts"

# ensure we have access to a kraken cluster
${KRAKEN_ROOT}/bin/kraken-connect.sh \
  --clustername "${KRAKEN_CLUSTER_NAME}" \
  --clustertype aws

# cluster access
KRAKEN_CLUSTER_DIR="${KRAKEN_ROOT}/bin/clusters/${KRAKEN_CLUSTER_NAME}"
KUBECONFIG=${KUBECONFIG:-"${KRAKEN_CLUSTER_DIR}/kube_config"}

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
export KUBE_ROOT=${KUBE_ROOT:-"/var/lib/docker/gobuild/${KUBE_TESTS_DIR}"}
export KUBE_DENSITY_KUBECONFIG=${KUBECONFIG}
export KUBE_DENSITY_SSH_USER="core"
export KUBE_DENSITY_SSH_KEY="${KRAKEN_CLUSTER_DIR}/id_rsa"
export KUBE_DENSITY_OUTPUT_DIR="${OUTPUT_DIR}/artifacts"
export KUBE_DENSITY_NUM_NODES=${NUMBER_OF_NODES}
# TODO: unclear what part of k8s scripts require USER to be set
USER=jenkins ${KRAKEN_ROOT}/hack/density.sh ${KUBE_ROOT} ${DENSITY} | tee ${OUTPUT_DIR}/build-log.txt
# tee isn't exiting >0 as expected, so use the exit status of the script directly
density_result=${PIPESTATUS[0]}

# save logs
${KRAKEN_ROOT}/hack/log-dump.sh --clustername ${KRAKEN_CLUSTER_NAME} --log-directory ${OUTPUT_DIR}/artifacts

## teardown

# remove leftover density namespaces
${KRAKEN_ROOT}/hack/namespace_cleanup.sh --etcd etcd --config ${KRAKEN_CLUSTER_DIR}/ssh_config --key ${KRAKEN_CLUSTER_DIR}/id_rsa

# unmark unschedulable nodes
for node in ${unschedulable_nodes}; do
  kubectl --kubeconfig=${KUBECONFIG} patch nodes ${node} -p '{"spec": {"unschedulable": false}}'
done

exit ${density_result}
