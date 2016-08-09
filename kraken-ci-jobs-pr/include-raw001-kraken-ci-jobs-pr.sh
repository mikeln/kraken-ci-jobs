#!/bin/bash
git checkout origin/master
jenkins-jobs test --recursive . > jjb_output.master
master_result=$?

git checkout ${ghprbActualCommit}
jenkins-jobs test --recursive . > jjb_output.pr
pr_result=$?

# don't fail if diff finds a difference
diff jjb_output.{master,pr} || true

# fail if either of the jjb runs failed
exit $(( ${master_result} || ${pr_result} ))
