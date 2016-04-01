#!/bin/bash
${WORKSPACE}/bin/kraken-connect.sh \
  --clustername "${KRAKEN_CLUSTER_NAME}" \
  --clustertype aws \
    --dmname "${PIPELET_DOCKERMACHINE}" \
    --dmshell bash

export KUBE_ROOT=/var/lib/docker/gobuild/${KUBE_TESTS_DIR}
export KUBE_DENSITY_KUBECONFIG=${WORKSPACE}/bin/clusters/${KRAKEN_CLUSTER_NAME}/kube_config
export KUBE_DENSITY_NUM_NODES=${NUMBER_OF_NODES}

# mark node-001 as unschedulable
locked_node=$(kubectl --kubeconfig=${KUBE_DENSITY_KUBECONFIG} \
  --cluster=${KRAKEN_CLUSTER_NAME} get nodes | grep node-001 | awk '{ print $1 }')
kubectl --kubeconfig=${KUBE_DENSITY_KUBECONFIG} --cluster=${KRAKEN_CLUSTER_NAME} \
  patch nodes ${locked_node} -p '{"spec": {"unschedulable": true}}'

KUBECONFIG=${KUBE_DENSITY_KUBECONFIG} ${WORKSPACE}/hack/terminate-namespace.sh density
export KUBE_DENSITY_OUTPUT_DIR=${WORKSPACE}/output
KUBE_DENSITY_LOG=${WORKSPACE}/${BUILD_TAG}-${DENSITY}.log

# TODO: unclear what part of k8s scripts require USER to be set
# TODO: should we just drop test build functionality
REBUILD_TESTS=false USER=jenkins hack/density.sh ${KUBE_TESTS_BRANCH} ${DENSITY} | tee ${KUBE_DENSITY_LOG}

${WORKSPACE}/hack/namespace_cleanup.sh --etcd etcd --config ${WORKSPACE}/bin/clusters/${KRAKEN_CLUSTER_NAME}/ssh_config --key ${WORKSPACE}/bin/clusters/${KRAKEN_CLUSTER_NAME}/id_rsa

# tee isn't exiting >0 as expected, so use the exit status of the script directly
exit ${PIPESTATUS[0]}