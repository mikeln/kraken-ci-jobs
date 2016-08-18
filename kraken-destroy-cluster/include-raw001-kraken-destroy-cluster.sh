#!/bin/bash

if [ "${DESTROY_CLUSTER}" = true ]; then
  ${WORKSPACE}/bin/kraken-connect.sh \
    --clustername "${KRAKEN_CLUSTER_NAME}" \
    --clustertype aws
 
  ${WORKSPACE}/bin/kraken-down.sh \
    --clustername "${KRAKEN_CLUSTER_NAME}" \
    --clustertype aws \
    --terraform_retries ${TERRAFORM_DESTROY_RETRIES}
fi
