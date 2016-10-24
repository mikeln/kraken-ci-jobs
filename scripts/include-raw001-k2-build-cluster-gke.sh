# copy down the key
aws s3 cp s3://sundry-automata/keys/atlas.cnct.io/atlas.cnct.io.key.json ${JENKINS_HOME}/secrets/

# start k2
docker run -e "K2_CLUSTER_NAME=${K2_CLUSTER_NAME}" \
  -e "JENKINS_HOME=${JENKINS_HOME}" \
  --volumes-from=jenkins \
  ${K2_CONTAINER_IMAGE} \
  ./up.sh --output ${WORKSPACE}/${K2_CLUSTER_NAME} --config ${WORKSPACE}/${K2_CLUSTER_NAME}/${K2_CLUSTER_NAME}.yaml
 