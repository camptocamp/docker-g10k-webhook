FROM debian:stretch

ENV \
    G10K_VERSION=0.4.5 \
    WEBHOOK_VERSION=2.6.8

EXPOSE 9000

RUN apt-get update \
    && apt-get install -y git ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/etc/puppetlabs/code"]

RUN curl -L https://github.com/xorpaul/g10k/releases/download/v${G10K_VERSION}/g10k-linux-amd64.zip -o g10k-linux-amd64.zip \
    && unzip g10k-linux-amd64.zip \
	&& mv g10k /usr/local/bin \
	&& chmod +x /usr/local/bin/g10k \
	&& rm g10k-linux-amd64.zip
RUN curl -L https://github.com/adnanh/webhook/releases/download/${WEBHOOK_VERSION}/webhook-linux-amd64.tar.gz -o webhook-linux-amd64.tar.gz \
    && tar xzf webhook-linux-amd64.tar.gz \
	&& mv webhook-linux-amd64/webhook /usr/local/bin \
	&& chmod +x /usr/local/bin/webhook \
	&& rm webhook-linux-amd64.tar.gz

COPY push-to-g10k.sh /push-to-g10k.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

RUN chmod g=u /etc/passwd

RUN mkdir -p /root/.ssh \
  && chgrp 0 /root/.ssh \
  && chmod g=u /root/.ssh \
  && echo StrictHostKeyChecking no > /root/.ssh/config

COPY g10k.json /etc/webhook/g10k.json

RUN touch /root/.netrc && chgrp 0 /root/.netrc && chmod g=u /root/.netrc

ENTRYPOINT ["/docker-entrypoint.sh"]
