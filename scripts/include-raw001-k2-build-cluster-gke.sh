# start k2
docker run -e "K2_CLUSTER_NAME=${K2_CLUSTER_NAME}" \
  -e "GCE_SERVICE_ACCOUNT_ID=${GCE_SERVICE_ACCOUNT_ID}" \
  -e "GCE_SERVICE_ACCOUNT_KEY=/gcloud/service-account.json" \
  --volumes-from=jenkins \
  -v /gcloud:/gcloud \
  ${K2_CONTAINER_IMAGE} \
  ./up.sh --output ${WORKSPACE}/${K2_CLUSTER_NAME} --config ${WORKSPACE}/${K2_CLUSTER_NAME}/${K2_CLUSTER_NAME}.yaml
 