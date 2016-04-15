#!/bin/bash
cp /etc/jenkins_jobs/kraken-ci.yaml .
# TODO: this is brittle
sed -i.bak -e 's|jobs/job-list.yaml|./job-list.yaml|' kraken-ci.yaml
jenkins-jobs test --recursive .
