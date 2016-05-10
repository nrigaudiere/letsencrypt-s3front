#!/usr/bin/env bash

i=0

# We need to prepare env variables for the task which is run under cron. We are writing these vars into /etc/cronenv
# file, which is sourced from `get_certificates.sh`
for domain in ${DOMAINS//,/ }
do
    access_key="AWS_ACCESS_KEY_ID_${i}"
    secret_key="AWS_SECRET_ACCESS_KEY_${i}"
    bucket="BUCKET_${i}"
    region="REGION_${i}"
    distribution_id="DISTRIBUTION_ID_${i}"
    email="EMAIL_${i}"

    exported_vars="
    ${exported_vars}
    export ${access_key}=${!access_key}
    export ${secret_key}=${!secret_key}
    export ${bucket}=${!bucket}
    export ${region}=${!region}
    export ${distribution_id}=${!distribution_id}
    export ${email}=${!email}
    "

    let "i += 1"
done

echo "Saving env"
cat <<EOF > /etc/cronenv
export DOMAINS=${DOMAINS}
${exported_vars}

EOF

echo "Preparing crontab"
cat <<EOF > /etc/cron.d/crontab
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
RENEW_CERTIFICATES=true

${CRON_PERIOD} root /letsencrypt-s3front/get_certificates.sh &>> /var/log/cron.log

EOF
chmod 0644 /etc/cron.d/crontab

echo "Starting cron with following rules:"
cat /etc/cron.d/crontab
cron

echo "Cron logs:"
tail -f /var/log/cron.log
