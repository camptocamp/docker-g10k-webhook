FROM golang:1.10 as builder

RUN go get -u github.com/xorpaul/g10k
RUN cd /go/src/github.com/xorpaul/g10k \
    && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo \
	  -o g10k .

RUN go get -u github.com/adnanh/webhook
RUN cd /go/src/github.com/adnanh/webhook \
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
