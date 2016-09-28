# make all
docker run --volumes-from=jenkins quay.io/samsung_cnct/k2:latest bash -c "cd ${WORKSPACE}; make all"