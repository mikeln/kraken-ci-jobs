# kraken-ci-jobs

[Jenkins Job Builder](http://docs.openstack.org/infra/jenkins-job-builder/) definitions for kraken-ci.

# layout

The layout is pretty ad-hoc right now

Some key directories:

- `excluded-on-jenkins`: dev copies of "secret" files that come from elsewhere on jenkins
- `jobs`: job definitions go here
- `params`: parameter defintions that are commonly used across multiple jobs
- `scripts`: scripts that are too unwieldy to render inline in jobs

Some key files:

- `global.yaml`: defaults and publishers/builders that are commonly reused across jobs
- `kraken-ci-jobs.yaml`: project for any job-templates that haven't laid out their own projects within jobs
- `kraken-verb-kubernetes.yaml`: builders/publishers related to building/fetching/cleaning kubernetes
- `raw-xml-slack-publihser.yaml`: so we can try to hide all the horrible xml in one file
    
# adding new jobs

1) Add a new file to `jobs` with `job-template` and `project` definitions, see existing files for prior art

2) Issue a PR to this repo.  The PR build will display resulting the resulting diff in XML output.

3) Once the PR is merged your job should be automatically generated on https://pipelet.kubeme.io

# testing locally

Use the `test` command to lint the YAML, and generate XML locally

```sh
jenkins-jobs test --recursive .
```
