#!/bin/bash
mkdir -p terraform/aws/${KRAKEN_CLUSTER_NAME}
cat > terraform/aws/${KRAKEN_CLUSTER_NAME}/terraform.tfvars << EOF
aws_user_prefix="${KRAKEN_USER_PREFIX}"
aws_access_key="${AWS_ACCESS_KEY_ID}"
aws_secret_key="${AWS_SECRET_ACCESS_KEY}"
asg_wait_single = 60
asg_wait_total = ${TOTAL_WAIT}
kubernetes_binaries_uri = "${KUBE_BINARIES_URI}"
node_count = $((NUMBER_OF_NODES - 1))
aws_node_type = "${NODE_TYPE}"
aws_special_node_type = "${SPECIAL_NODE_TYPE}"
aws_etcd_type = "${ETCD_TYPE}"
aws_master_type = "${MASTER_TYPE}"
apiserver_count = ${API_SERVER_COUNT}
aws_apiserver_type = "${API_SERVER_TYPE}"
EOF

# start kraken-up
${WORKSPACE}/bin/kraken-up.sh \
  --clustername "${KRAKEN_CLUSTER_NAME}" \
  --clustertype aws \
    --dmopts "--driver amazonec2 --amazonec2-region ${AWS_DEFAULT_REGION} \
      --amazonec2-vpc-id ${KRAKEN_DEFAULT_VPC} --amazonec2-access-key ${AWS_ACCESS_KEY_ID} \
      --amazonec2-secret-key ${AWS_SECRET_ACCESS_KEY}" \
    --dmname "${PIPELET_DOCKERMACHINE}" \
    --dmshell bash