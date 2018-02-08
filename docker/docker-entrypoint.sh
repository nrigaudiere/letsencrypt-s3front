#!/usr/bin/env bash

# We need to prepare env variables for the task
# which is sourced from `get_certificates.sh`

echo "Saving env"
export DOMAINS=${DOMAINS}
EOF

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

root /letsencrypt-s3front/get_certificates.sh

EOF
