POSTNAME=$(date +"%Y-%m-%d-Job-${KRAKEN_COMMIT}.md")
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

mkdir -p ${WORKSPACE}/_posts

cat > ${WORKSPACE}/_posts/${POSTNAME} <<EOF
---
layout:     post
title:      Commit ${KRAKEN_COMMIT}
date:       ${TIMESTAMP}
summary:    Conformance test log for commit ${KRAKEN_COMMIT}.
category:   jekyll
---

${TEST_RESULT}

- Conformance test log: [Log File](http://s3-us-west-2.amazonaws.com/kraken-e2e-logs/conformance/kraken_${KRAKEN_COMMIT}_conformance.log)
EOF

git config user.email "maratoid+samsungjenkins@gmail.com"
git config user.name "Samsung Jenkins"

git add .
git add -u
git commit -m "Auto-update site with Kraken SHA ${KRAKEN_COMMIT}"