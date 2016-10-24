# create a config file
mkdir -p ${WORKSPACE}/${K2_CLUSTER_NAME}

if [ -z "$K2_CONFIG_URI" ]; then
  echo ${K2_CONFIG_TEXT} > ${WORKSPACE}/${K2_CLUSTER_NAME}/${K2_CLUSTER_NAME}.yaml
else
  wget ${K2_CONFIG_URI} -O ${WORKSPACE}/${K2_CLUSTER_NAME}/${K2_CLUSTER_NAME}.yaml
fi