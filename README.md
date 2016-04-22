# kraken-ci-jobs
Jenkins Job Builder definitions for kraken-ci.

### Adding new jobs

1) Add a new kraken-* jenkins job builder job in it's own folder:

        kraken-your-job\
           kraken-your-job.yaml

2) Edit the [job-list.yaml.inc](job-list.yaml.inc) file:

        - '{name}-build-cluster'
        - '{name}-build-k8s-tests'
        ...
        - '{name}-your-job'

3) Issue a PR to this repo. Once it is merged your job should be automatically generated on https://pipelet.kubeme.io

### Variables

Following jenkins job builder {} variables will be replaced:

    ci_admin_list - array of github admins
    slack_api_token - api token for slack notifier
    slack_room - slack room id for notifications
    slack_domain - slack domain for samsung-ag org
    ci_hostname - jenkins url
    test_bucket - s3 bucket for test results
