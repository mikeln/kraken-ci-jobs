# clean up
rm -rf ${WORKSPACE}/${K2_CLUSTER_NAME}/generated-keys
mkdir -p ${WORKSPACE}/${K2_CLUSTER_NAME}/generated-keys

# generate a keypair
ssh-keygen -q -t rsa -N '' -f ${WORKSPACE}/${K2_CLUSTER_NAME}/generated-keys/id_rsa

# create a config file
if [ -z "$K2_CONFIG_URI" ]; then
  echo ${K2_CONFIG_TEXT} > ${WORKSPACE}/${K2_CLUSTER_NAME}/${K2_CLUSTER_NAME}.yaml
else
  wget ${K2_CONFIG_URI} -O ${WORKSPACE}/${K2_CLUSTER_NAME}/${K2_CLUSTER_NAME}.yaml
fi

# start k2
docker run -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
  -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
  -e "K2_CLUSTER_NAME=${K2_CLUSTER_NAME}" \
  -v ${WORKSPACE}/${K2_CLUSTER_NAME}:/k2 \
  ${K2_CONTAINER_IMAGE} \
  /kraken/up.sh --output /k2 --config /k2/${K2_CLUSTER_NAME}.yaml