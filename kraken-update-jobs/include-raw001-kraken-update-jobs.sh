#!/bin/bash
cd /etc/jenkins_jobs/jobs
git pull
cd /etc/jenkins_jobs
jenkins-jobs update -r /etc/jenkins_jobs