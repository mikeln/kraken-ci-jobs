#!/bin/bash

K2_ROOT=${K2_ROOT:-${WORKSPACE}}

## setup

# setup output dir
OUTPUT_DIR="${K2_ROOT}/output"
mkdir -p "${OUTPUT_DIR}/artifacts"

## run
export KUBE_ROOT=/var/lib/docker/gobuild/${KUBE_TESTS_DIR}
export KUBE_CONFORMANCE_KUBECONFIG=${WORKSPACE}/${K2_CLUSTER_NAME}/${K2_CLUSTER_NAME}/admin.kubeconfig
export KUBE_CONFORMANCE_OUTPUT_DIR=${OUTPUT_DIR}/artifacts

# TODO: unclear what part of k8s scripts require USER to be set
KUBERNETES_PROVIDER=aws USER=jenkins ./hack/parallel-conformance.sh ${KUBE_ROOT} | tee ${OUTPUT_DIR}/build-log.txt
# tee isn't exiting >0 as expected, so use the exit status of the script directly
conformance_result=${PIPESTATUS[0]}

exit ${conformance_result}
