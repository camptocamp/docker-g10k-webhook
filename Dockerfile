FROM camptocamp/g10k:0.8.12

ENV \
    G10K_VERSION=0.8.12 \
    WEBHOOK_VERSION=2.7.0 \
	HOME=/home/g10k

EXPOSE 9000

RUN apt-get update \
    && apt-get install -y git ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/adnanh/webhook/releases/download/${WEBHOOK_VERSION}/webhook-linux-amd64.tar.gz -o webhook-linux-amd64.tar.gz \
    && tar xzf webhook-linux-amd64.tar.gz \
	&& mv webhook-linux-amd64/webhook /usr/local/bin \
	&& chmod +x /usr/local/bin/webhook \
	&& rm webhook-linux-amd64.tar.gz

COPY push-to-g10k.sh /push-to-g10k.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN echo StrictHostKeyChecking no >> /etc/ssh/ssh_config

COPY g10k.yaml.tmpl /etc/webhook/g10k.yaml.tmpl

# install nss_wrapper in case we need to fake /etc/passwd and /etc/group (i.e. for OpenShift)
RUN apt-get update && \
    apt-get install -y --no-install-recommends libnss-wrapper && \
	rm -rf /var/lib/apt/lists/*

COPY nss_wrapper.sh /
COPY /docker-entrypoint.d/* /docker-entrypoint.d/

RUN mkdir -p /etc/puppetlabs/code/environments && \
    chgrp 0 -R /etc/puppetlabs/code && \
	chmod g=u -R /etc/puppetlabs/code
VOLUME ["/etc/puppetlabs/code"]

RUN mkdir -p ${HOME} && \
	chgrp 0 -R ${HOME} && \
	chmod g=u -R ${HOME}
#USER 1000

ENTRYPOINT ["/docker-entrypoint.sh", "/usr/local/bin/webhook"]
CMD ["-hooks", "/etc/webhook/g10k.yaml.tmpl", "-template", "-verbose"]
