#!/bin/bash
cp /etc/jenkins_jobs/kraken-ci.yaml .
jenkins-jobs test --recursive .
