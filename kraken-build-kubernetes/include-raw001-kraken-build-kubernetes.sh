# build the tests
cd /var/lib/docker/gobuild
git clone -b ${KUBE_TESTS_BRANCH} ${KUBE_TESTS_REPO} ./${KUBE_TESTS_DIR}
cd ${KUBE_TESTS_DIR}
KUBE_SKIP_CONFIRMATIONS=y build/run.sh hack/build-go.sh
