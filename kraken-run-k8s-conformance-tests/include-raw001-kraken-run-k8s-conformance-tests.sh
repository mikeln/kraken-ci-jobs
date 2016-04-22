#!/bin/bash
${WORKSPACE}/bin/kraken-connect.sh \
  --clustername "${KRAKEN_CLUSTER_NAME}" \
  --clustertype aws \
    --dmname "${PIPELET_DOCKERMACHINE}" \
    --dmshell bash
    
export KUBE_ROOT=/var/lib/docker/gobuild/${KUBE_TESTS_DIR}
export KUBE_CONFORMANCE_KUBECONFIG=${WORKSPACE}/bin/clusters/${KRAKEN_CLUSTER_NAME}/kube_config
export KUBE_CONFORMANCE_OUTPUT_DIR=${WORKSPACE}/output/conformance

KUBE_CONFORMANCE_LOG=${WORKSPACE}/kraken_${GIT_COMMIT}.log
# TODO: unclear what part of k8s scripts require USER to be set
USER=jenkins ./hack/conformance.sh ${KUBE_TESTS_BRANCH} | tee ${KUBE_CONFORMANCE_LOG}
# tee isn't exiting >0 as expected, so use the exit status of the script directly
exit ${PIPESTATUS[0]}
