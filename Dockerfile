FROM python:2

# Install git for letsencrypt
RUN apt-get update && \
    apt-get install -y \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install letsencrypt https://letsencrypt.readthedocs.org/en/latest/using.html#installation
RUN git clone https://github.com/letsencrypt/letsencrypt /letsencrypt \
  && cd /letsencrypt \
  && git checkout tags/v0.3.0 \
  && cd - \
  && /letsencrypt/bootstrap/debian.sh

RUN pip install letsencrypt-s3front

VOLUME /etc/letsencrypt

ADD docker/* /letsencrypt-s3front/
RUN chmod a+x /letsencrypt-s3front/*.sh

CMD /letsencrypt-s3front/docker-entrypoint.sh
