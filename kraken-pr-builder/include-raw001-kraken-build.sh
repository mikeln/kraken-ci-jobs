KUBECONFIG=${WORKSPACE}/bin/clusters/${KRAKEN_CLUSTER_NAME}/kube_config

mkdir -p terraform/aws/${KRAKEN_CLUSTER_NAME}
cat > terraform/aws/${KRAKEN_CLUSTER_NAME}/terraform.tfvars << EOF
aws_user_prefix="${KRAKEN_USER_PREFIX}"
aws_access_key="${AWS_ACCESS_KEY_ID}"
aws_secret_key="${AWS_SECRET_ACCESS_KEY}"
kubernetes_binaries_uri = "https://storage.googleapis.com/kubernetes-release/release/v1.1.7/bin/linux/amd64"
asg_wait_single = 60
asg_wait_total = 10
kraken_repo.commit_sha = "${ghprbActualCommit}"
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

${WORKSPACE}/bin/kraken-connect.sh \
  --clustername "${KRAKEN_CLUSTER_NAME}" \
  --clustertype aws \
    --dmname "${PIPELET_DOCKERMACHINE}" \
    --dmshell bash

# run tests
bundle install
bundle exec cucumber --format pretty --format junit --out output/cucumber/junit KUBECONFIG=${KUBECONFIG} CUKE_CLUSTER=${KRAKEN_CLUSTER_NAME} features/*_aws.feature