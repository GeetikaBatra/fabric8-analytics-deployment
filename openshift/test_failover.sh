#!/bin/bash -e

# Deploy fabric8-analytics to Openshift
# possible arguments:
#   --purge-aws-resources: clear previously allocated AWS resources (RDS database, SQS queues, S3 buckets, DynamoDB tables)
deployments=("bayesian-api" "bayesian-data-importer" "bayesian-gremlin-http" 
"bayesian-gremlin-httpingestion" "bayesian-jobs"  
"bayesian-kronos-maven" "bayesian-kronos-pypi" "bayesian-pgbouncer"
"bayesian-worker-api" "bayesian-worker-api-graph-import"
"f8a-firehose-fetcher" "f8a-license-analysis" "f8a-server-backbone" 
"f8a-worker-scaler" "fabric8-analytics-stack-report-ui")

# function temp() {
#     for deployment in ${deployments}

#         do echo ${deployment}
#         # 
#     done 
# }
# gc() {
#   retval=$?
#     temp 
#     exit $retval
# }
# trap gc EXIT SIGINT

here=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source helpers.sh

#Check for configuration file
if ! [ -f "${here}/env.sh" ]
then
    echo '`env.sh` configuration file is missing. You can create one from the template:'
    echo 'cp env-template.sh env.sh'
    echo
    echo 'Modify the `env.sh` configuration file as necessary. See README.md file for more information.'
    exit 1
fi

#Check if required commands are available
tool_is_installed oc

#Load configuration from env variables
source env.sh

#Check if required env variables are set
is_set_or_fail OC_USERNAME "${OC_USERNAME}"
is_set_or_fail OC_PASSWD "${OC_PASSWD}"



openshift_login

to_kill=${deployments[$RANDOM % ${#deployments[@]} ]}

while sleep 1;
    to_kill=${deployments[$RANDOM % ${#deployments[@]} ]}
    do oc scale dc/${to_kill} --replicas=0; 
done




