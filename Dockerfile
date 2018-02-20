FROM golang:1.10 as builder

ENV \
    G10K_VERSION=v0.4.4 \
    WEBHOOK_VERSION=2.6.8

RUN go get -u github.com/xorpaul/g10k
RUN cd /go/src/github.com/xorpaul/g10k \
    && git checkout $G10K_VERSION \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo \
	  -o g10k .

RUN go get -u github.com/adnanh/webhook
RUN cd /go/src/github.com/adnanh/webhook \
    && git checkout $WEBHOOK_VERSION \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo \
	  -o webhook .

FROM centos:7
RUN yum install -y git
COPY --from=builder /go/src/github.com/xorpaul/g10k/g10k \
                    /usr/local/bin/g10k
COPY --from=builder /go/src/github.com/adnanh/webhook/webhook \
                    /usr/local/bin/webhook
COPY --from=builder /etc/ssl/certs/ca-certificates.crt \
                    /etc/ssl/certs/ca-certificates.crt
