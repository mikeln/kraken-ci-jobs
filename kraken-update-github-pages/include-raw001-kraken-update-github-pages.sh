#!/bin/bash
POSTNAME=$(date +"%Y-%m-%d-Job-${KRAKEN_COMMIT}.md")
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

mkdir -p ${WORKSPACE}/_posts

cat > ${WORKSPACE}/_posts/${POSTNAME} <<EOF
---
layout:     post
title:      Commit/Build tag ${KRAKEN_COMMIT}
date:       ${TIMESTAMP}
summary:    Conformance test log for commit/build tag ${KRAKEN_COMMIT}.
category:   jekyll
---

${TEST_RESULT}

- ${TEST_KIND} test log: [Log File](${LOG_LINK})
EOF

git config user.email "maratoid+samsungjenkins@gmail.com"
git config user.name "Samsung Jenkins"

git add .
git add -u
git commit -m "Auto-update site with Kraken SHA ${KRAKEN_COMMIT}"