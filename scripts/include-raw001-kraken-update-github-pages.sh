#!/bin/bash
POSTNAME=$(date +"%Y-%m-%d-Job-${KRAKEN_COMMIT}.md")
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

TEST_RESULT="Failure!"
if [[ "${JENKINS_BUILD_FINISHED:-}" = "SUCCESS" ]]; then
  TEST_RESULT="Success!"
fi

pushd "${WORKSPACE}"
original_branch=$(git rev-parse HEAD)
git checkout -b gh-pages origin/gh-pages

mkdir -p _posts

cat > _posts/${POSTNAME} <<EOF
---
layout:     post
title:      ${JOB_NAME} commit/build tag ${KRAKEN_COMMIT}
date:       ${TIMESTAMP}
summary:    ${JOB_NAME} test log for commit/build tag ${KRAKEN_COMMIT}.
category:   jekyll
---

${TEST_RESULT}

- ${JOB_NAME} test log: [Log File](${LOG_LINK})
EOF

git config user.email "maratoid+samsungjenkins@gmail.com"
git config user.name "Samsung Jenkins (${KRAKEN_CI_NAME})"

git add _posts/${POSTNAME}
git commit -m "${JOB_NAME} result: ${TEST_RESULT} kraken_sha: ${KRAKEN_COMMIT}"

git push origin gh-pages:gh-pages
git checkout "${original_branch}"
popd
