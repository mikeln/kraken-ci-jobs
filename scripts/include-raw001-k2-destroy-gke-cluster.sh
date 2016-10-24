docker run -e "K2_CLUSTER_NAME=${K2_CLUSTER_NAME}" \
  -e "JENKINS_HOME=${JENKINS_HOME}" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  ./down.sh --output ${WORKSPACE}/${K2_CLUSTER_NAME} --config ${WORKSPACE}/${K2_CLUSTER_NAME}/${K2_CLUSTER_NAME}.yaml