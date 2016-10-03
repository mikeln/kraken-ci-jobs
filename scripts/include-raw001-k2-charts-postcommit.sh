# copy down the key
aws s3 cp s3://sundry-automata/keys/atlas.cnct.io/atlas.cnct.io.key.json ${JENKINS_HOME}/secrets/

# make all
docker run --volumes-from=jenkins quay.io/samsung_cnct/k2:latest bash -c \
  "gcloud auth activate-service-account atlas-cnct-io@cnct-productioncluster.iam.gserviceaccount.com --key-file ${JENKINS_HOME}/secrets/atlas.cnct.io.key.json; \
    cd ${WORKSPACE}; \
      make all"