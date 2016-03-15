# build the tests
cd /var/lib/docker/gobuild
rm -rf ${KUBE_CONFORMANCE_DIR}
git clone -b ${KUBE_CONFORMANCE_BRANCH} ${KUBE_CONFORMANCE_REPO} ./${KUBE_CONFORMANCE_DIR}
cd ${KUBE_CONFORMANCE_DIR}
KUBE_SKIP_CONFIRMATIONS=y build/run.sh hack/build-go.sh
