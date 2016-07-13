#!/bin/bash
mkdir -p terraform/aws/${KRAKEN_CLUSTER_NAME}
cat > terraform/aws/${KRAKEN_CLUSTER_NAME}/terraform.tfvars << EOF
aws_user_prefix = "${KRAKEN_USER_PREFIX}"
aws_access_key = "${AWS_ACCESS_KEY_ID}"
aws_secret_key = "${AWS_SECRET_ACCESS_KEY}"
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
coreos_update_channel = "${COREOS_UPDATE_CHANNEL}"
coreos_version = "${COREOS_VERSION}"
coreos_reboot_strategy = "${COREOS_REBOOT_STRATEGY}"
kraken_services_repo = "${KRAKEN_SERVICES_REPO}"
kraken_services_branch = "${KRAKEN_SERVICES_BRANCH}"
kraken_services_dirs = "${KRAKEN_SERVICES_DIRS}"
EOF

# start kraken-up
KRAKEN_VERBOSE=true ${WORKSPACE}/bin/kraken-up.sh \
  --clustername "${KRAKEN_CLUSTER_NAME}" \
  --clustertype aws \
  --terraform_retries ${TERRAFORM_APPLY_RETRIES} \
    --dmopts "\
      --driver amazonec2 \
      --amazonec2-access-key ${AWS_ACCESS_KEY_ID} \
      --amazonec2-instance-type m4.xlarge
      --amazonec2-region ${AWS_DEFAULT_REGION} \
      --amazonec2-secret-key ${AWS_SECRET_ACCESS_KEY} \
      --amazonec2-vpc-id ${KRAKEN_DEFAULT_VPC}" \
    --dmname "${PIPELET_DOCKERMACHINE}" \
    --dmshell bash

# sanity check, show what was launched

${WORKSPACE}/bin/kraken-connect.sh \
  --clustername "${KRAKEN_CLUSTER_NAME}" \
  --clustertype aws \
    --dmname "${PIPELET_DOCKERMACHINE}" \
    --dmshell bash

KUBECONFIG="${WORKSPACE}/bin/clusters/${KRAKEN_CLUSTER_NAME}/kube_config"

for res in $(kubectl --kubeconfig="${DIR}/kube_config" get 2>&1 | grep '*' | awk '{print $2}'); do
  echo "=== $r ==="; echo;
  kubectl --kubeconfig=${KUBECONFIG} get $r --all-namespaces;
done

for res in componentstatuses namespaces nodes; do
  echo "=== $r ==="; echo;
  kubectl --kubeconfig=${KUBECONFIG} get $r;
done
