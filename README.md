## S3/CloudFront plugin for Let's Encrypt client

Use the letsencrypt client to generate and install a certificate to be used with
an AWS CloudFront distribution of an S3 bucket.

### Before you start

Follow a guide like this one [https://docs.aws.amazon.com/gettingstarted/latest/swh/website-hosting-intro.html](https://docs.aws.amazon.com/gettingstarted/latest/swh/website-hosting-intro.html)
to use S3 and CloudFront for static site hosting.

Once you are done you should have:

- A domain pointing to a CloudFront distribution that will use an S3 bucket for origin.
- Both HTTP and HTTPS traffic are enabled in the CloudFront Distrubtion. This is important for certificate validation, at least while you get your certificate.
- An IAM policy with the permissions needed for this plugin. A [sample policy](sample-aws-policy.json) has been provided.

### Setup

1. Install the letsencrypt client [https://letsencrypt.readthedocs.org/en/latest/using.html#installation](https://letsencrypt.readthedocs.org/en/latest/using.html#installation)

  ```
  pip install letsencrypt
  ```

1. Install the letsencrypt-s3front plugin

  ```
  pip install letsencrypt-s3front
  ```

### How to use it

To generate a certificate and install it in a CloudFront distribution:
```
AWS_ACCESS_KEY_ID="your_key" \
AWS_SECRET_ACCESS_KEY="your_secret" \
letsencrypt --agree-tos -a letsencrypt-s3front:auth \
--letsencrypt-s3front:auth-s3-bucket the_bucket \
[ --letsencrypt-s3front:auth-s3-region your-bucket-region-name ] (default is us-east-1) \
-i letsencrypt-s3front:installer \
--letsencrypt-s3front:installer-cf-distribution-id your_cf_distribution_id \
-d the_domain
```

Follow the screen prompts and you should end up with the certificate in your
distribution. It may take a couple minutes to update.

To automate the renewal process without prompts (for example, with a monthly cron), you can add the letsencrypt parameters --renew-by-default --text

### Use with docker

Move these lines to your `docker-compose.yml`

```
letsencrypt-s3front:
  image: plyo/letsencrypt-s3front
  environment:
    - DOMAINS=first.domain.com,second.domain.com
    - AWS_ACCESS_KEY_ID_0=<key for first domain>
    - AWS_SECRET_ACCESS_KEY_0=<secret for first domain>
    - BUCKET_0=<bucket name>
    - REGION_0=<region>
    - DISTRIBUTION_ID_0=<dist_id>
    - EMAIL_0=<email for notifications>
    - AWS_ACCESS_KEY_ID_1=<key for second domain>
    - AWS_SECRET_ACCESS_KEY_1=<secret for second domain>
    - BUCKET_1=<bucket name>
    - REGION_1=<region>
    - DISTRIBUTION_ID_1=<dist_id>
    - EMAIL_1=<email>
    - CRON_PERIOD=0 3 * * *  # 3 a.m. each night for trying to renew
  volumes:
    ./letsencrypt:/etc/letsencrypt
```

then run with `docker-compose up`. You can update certificates for several domains - just list them in `$DOMAINS` var
and use ordinal suffix (like _0, _1, _2..) for other vars.

