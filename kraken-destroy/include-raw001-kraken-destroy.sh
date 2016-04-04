#!/bin/bash

if [ "${DESTROY_CLUSTER}" = true ]; then
  ${WORKSPACE}/bin/kraken-connect.sh \
    --clustername "${KRAKEN_CLUSTER_NAME}" \
    --clustertype aws \
    --dmname "${PIPELET_DOCKERMACHINE}" \
    --dmshell bash
 
  ${WORKSPACE}/bin/kraken-down.sh \
    --clustername "${KRAKEN_CLUSTER_NAME}" \
    --clustertype aws \
    --dmname "${PIPELET_DOCKERMACHINE}" \
    --dmshell bash
fi
