#!/usr/bin/env bash

source /etc/cronenv

i=0

if [ ! "${DOMAINS}" ]; then
    echo 'Error: empty $DOMAINS var'
    exit 1;
fi

# for each listed domain, read env variables and get certificate
for domain in ${DOMAINS//,/ }
do
    access_key="AWS_ACCESS_KEY_ID_${i}"
    secret_key="AWS_SECRET_ACCESS_KEY_${i}"
    bucket="BUCKET_${i}"
    region="REGION_${i}"
    distribution_id="DISTRIBUTION_ID_${i}"
    email="EMAIL_${i}"

    export AWS_ACCESS_KEY_ID=${!access_key}
    export AWS_SECRET_ACCESS_KEY=${!secret_key}

    echo "Getting a certificate for ${domain}..."
    letsencrypt run --agree-tos -t -a letsencrypt-s3front:auth \
      --keep --expand \
      --letsencrypt-s3front:auth-s3-bucket ${!bucket} \
      --letsencrypt-s3front:auth-s3-region ${!region} \
      -i letsencrypt-s3front:installer \
      --letsencrypt-s3front:installer-cf-distribution-id ${!distribution_id} \
      --email=${!email} \
      -d ${domain}

    let "i += 1"
done
