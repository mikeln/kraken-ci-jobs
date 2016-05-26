#!/bin/bash
git checkout origin/master
jenkins-jobs test --recursive . > jjb_output.master

git checkout ${ghprbActualCommit}
jenkins-jobs test --recursive . > jjb_output.pr

diff jjb_output.{master,pr} || true
