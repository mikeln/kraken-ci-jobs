#!/bin/bash
# TODO: this is brittle
cp /etc/jenkins_jobs/kraken-ci.yaml .
sed -i.bak -e 's|jobs/job-list.yaml|./job-list.yaml|' kraken-ci.yaml

git checkout origin/master
jenkins-jobs test --recursive . > jjb_output.master

git checkout ${ghprbActualCommit}
jenkins-jobs test --recursive . > jjb_output.pr

diff jjb_output.{master,pr} || true
