# make all
docker run --volumes-from=jenkins quay.io/samsung_cnct/k2:latest bash -c \
  "gcloud auth activate-service-account ${GCE_PROD_SERVICE_ACCOUNT_ID} --key-file /gcloud/prod-service-account.json; \
    cd ${WORKSPACE}; \
      make all"