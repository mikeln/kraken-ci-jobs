#!/bin/bash
cp /etc/jenkins_jobs/jenkins_jobs.ini .
cp /etc/jenkins_jobs/slack-publisher.yaml .
jenkins-jobs update --delete-old --recursive --exclude jobs/excluded-on-jenkins .
