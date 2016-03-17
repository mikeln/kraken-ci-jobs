#!/bin/bash
aws s3 cp --acl public-read --content-type text/plain --metadata-directive REPLACE ${LOG_FILE} s3://kraken-e2e-logs/${TEST_KIND}/