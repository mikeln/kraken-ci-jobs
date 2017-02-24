#!/bin/bash

KRAKEN_ROOT=${KRAKEN_ROOT:-${WORKSPACE}}

## setup

# setup output dir
OUTPUT_DIR="${KRAKEN_ROOT}/output"
mkdir -p "${OUTPUT_DIR}/artifacts"

# setup gopath
export GOPATH="${WORKSPACE}/go"
mkdir -p "${GOPATH}"

# ensure we have access to a kraken cluster
${WORKSPACE}/bin/kraken-connect.sh \
  --clustername "${KRAKEN_CLUSTER_NAME}" \
  --clustertype aws

## run
export KUBE_ROOT=/var/lib/docker/gobuild/${KUBE_TESTS_DIR}
export KUBE_CONFORMANCE_KUBECONFIG=${WORKSPACE}/bin/clusters/${KRAKEN_CLUSTER_NAME}/kube_config
export KUBE_CONFORMANCE_OUTPUT_DIR=${OUTPUT_DIR}/artifacts

# TODO: unclear what part of k8s scripts require USER to be set
KUBERNETES_PROVIDER=aws USER=jenkins ./hack/parallel-conformance.sh ${KUBE_ROOT} | tee ${OUTPUT_DIR}/build-log.txt
# tee isn't exiting >0 as expected, so use the exit status of the script directly
conformance_result=${PIPESTATUS[0]}

# save logs
${KRAKEN_ROOT}/hack/log-dump.sh --clustername ${KRAKEN_CLUSTER_NAME} --log-directory ${OUTPUT_DIR}/artifacts

exit ${conformance_result}
