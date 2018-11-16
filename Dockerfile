FROM debian:stretch

ENV \
    G10K_VERSION=0.5.6 \
    WEBHOOK_VERSION=2.6.9

EXPOSE 9000

RUN apt-get update \
    && apt-get install -y git ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/*

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

RUN echo StrictHostKeyChecking no >> /etc/ssh/ssh_config

COPY g10k.yaml.tmpl /etc/webhook/g10k.yaml.tmpl

RUN touch /root/.netrc && chgrp 0 /root/.netrc && chmod g=u /root/.netrc

# install nss_wrapper in case we need to fake /etc/passwd and /etc/group (i.e. for OpenShift)
RUN apt-get update && \
    apt-get install -y --no-install-recommends libnss-wrapper && \
	rm -rf /var/lib/apt/lists/*

COPY nss_wrapper.sh /

RUN mkdir -p /etc/puppetlabs/code/environments && \
    chgrp 0 -R /etc/puppetlabs/code && \
	chmod g=u -R /etc/puppetlabs/code
VOLUME ["/etc/puppetlabs/code"]

RUN useradd -d / -G0 webhook
USER webhook


ENTRYPOINT ["/docker-entrypoint.sh", "/usr/local/bin/webhook"]
CMD ["-hooks", "/etc/webhook/g10k.yaml.tmpl", "-template", "-verbose"]
