#!/usr/bin/env bash

if [ ! "${DOMAINS}" ]; then
  echo 'Error: empty $DOMAINS var'
  exit 1;
fi

# for each listed domain, read env variables and get certificate
for domain in ${DOMAINS//,/ }
do
  echo "Getting a certificate for ${domain}..."
  letsencrypt run --agree-tos -t -a letsencrypt-s3front:auth \
    --keep --expand \
    --letsencrypt-s3front:auth-s3-bucket ${BUCKET} \
    --letsencrypt-s3front:auth-s3-region ${REGION} \
    -i letsencrypt-s3front:installer \
    --letsencrypt-s3front:installer-cf-distribution-id ${DISTRIBUTION_ID} \
    --email=${EMAIL} \
    -d ${domain}
done
