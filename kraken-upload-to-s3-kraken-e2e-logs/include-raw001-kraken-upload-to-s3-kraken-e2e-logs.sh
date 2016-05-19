#!/bin/bash
aws s3 cp --recursive --acl public-read --content-type text/plain --metadata-directive REPLACE ${PROJECT_ARTIFACT} s3://kraken-e2e-logs/${TEST_KIND}/${PROJECT_ARTIFACT}
