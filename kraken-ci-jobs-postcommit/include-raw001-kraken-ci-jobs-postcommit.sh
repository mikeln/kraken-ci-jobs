#!/bin/bash
cd /etc/jenkins_jobs/jobs
git pull
cd /etc/jenkins_jobs
jenkins-jobs update --delete-old --recursive /etc/jenkins_jobs
