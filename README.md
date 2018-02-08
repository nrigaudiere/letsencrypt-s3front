## S3/CloudFront plugin for [Certbot](https://certbot.eff.org/) client

Use the certbot client to generate and install a certificate to be used with
an AWS CloudFront distribution of an S3 bucket.

### Before you start

Follow a guide like this one [https://docs.aws.amazon.com/gettingstarted/latest/swh/website-hosting-intro.html](https://docs.aws.amazon.com/gettingstarted/latest/swh/website-hosting-intro.html)
to use S3 and CloudFront for static site hosting.

Once you are done you should have:

- A domain pointing to a CloudFront distribution that will use an S3 bucket for origin.
- Both HTTP and HTTPS traffic are enabled in the CloudFront Distrubtion. This is important for certificate validation, at least while you get your certificate.
- An IAM policy with the permissions needed for this plugin. A [sample policy](sample-aws-policy.json) has been provided.

Note: If you're setting up both an apex and a `www.` domain, they'll have a respective S3 bucket each. You'll need to update the IAM policy to include access to both buckets.

### Setup


The easiest way to install both the certbot client and the certbot-s3front plugin is:

  ```
  pip install certbot-s3front
  ```

#### Mac with Homebrew certbot?
  Installed certbot certbot using Homebrew on Mac (as the official way to install on a Mac)? Find the full path to its python binary using this command:

  ```bash
  cat $(which certbot) | head -1
  ```

  Then use the full path to the `pip` binary found in the same folder to install certbot-s3front.
  Note, you will need to re-install the plugin each time Homebrew will update certbot

#### Mac with pip certbot?
  Alternatively, you can have a local set up for Python and we recommend a [virtual environment](http://docs.python-guide.org/en/latest/dev/virtualenvs/) and have both certbot and certbot-s3front installed via pip.
  You might also need to install `dialog`: `brew install dialog`.

#### Ubuntu?
  If you are in Ubuntu you will need to install `pip` and other libraries first:
  ```
  apt-get install python-pip python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev dialog
  ```
  And then run `pip install certbot-s3front`.

### Docker

Move these lines to your `docker-compose.yml`

```
letsencrypt-s3front:
  image: plyo/letsencrypt-s3front
  environment:
    - DOMAINS=first.domain.com,second.domain.com
    - AWS_ACCESS_KEY_ID=<key for first domain>
    - AWS_SECRET_ACCESS_KEY=<secret for first domain>
    - BUCKET=<bucket name>
    - REGION=<region>
    - DISTRIBUTION_ID=<dist_id>
    - EMAIL=<email for notifications>
  volumes:
    ./letsencrypt:/etc/letsencrypt
  network_mode: "host"
```

then run with `docker-compose up`. You can update certificates for several domains - just list them in `$DOMAINS`
