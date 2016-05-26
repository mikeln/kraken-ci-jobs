#!/bin/bash

KRAKEN_ROOT=${KRAKEN_ROOT:-${WORKSPACE}}

${WORKSPACE}/bin/kraken-connect.sh \
  --clustername "${KRAKEN_CLUSTER_NAME}" \
  --clustertype aws \
    --dmname "${PIPELET_DOCKERMACHINE}" \
    --dmshell bash
    
export KUBE_ROOT=/var/lib/docker/gobuild/${KUBE_TESTS_DIR}
export KUBE_CONFORMANCE_KUBECONFIG=${WORKSPACE}/bin/clusters/${KRAKEN_CLUSTER_NAME}/kube_config
export KUBE_CONFORMANCE_OUTPUT_DIR=${WORKSPACE}/output/conformance

export KUBE_SSH_USER="core"
export KUBE_SSH_KEY="${KRAKEN_CLUSTER_DIR}/id_rsa"

# setup logging
KUBE_CONFORMANCE_LOG_DIR=${KRAKEN_ROOT}/kraken_${GIT_COMMIT}/
KUBE_CONFORMANCE_LOG=${KUBE_CONFORMANCE_LOG_DIR}/build-log.txt
mkdir -p ${KUBE_CONFORMANCE_LOG_DIR}

# TODO: unclear what part of k8s scripts require USER to be set
KUBERNETES_PROVIDER=aws USER=jenkins ./hack/parallel-conformance.sh ${KUBE_ROOT} | tee ${KUBE_CONFORMANCE_LOG}
# tee isn't exiting >0 as expected, so use the exit status of the script directly
exit ${PIPESTATUS[0]}

# save logs
${KRAKEN_ROOT}/hack/log-dump.sh --clustername ${KRAKEN_CLUSTER_NAME} --log-directory ${KUBE_CONFORMANCE_LOG_DIR}/artifacts
