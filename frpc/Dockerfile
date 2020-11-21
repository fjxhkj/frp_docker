FROM golang:alpine as builder
RUN apk update \
&& apk add --no-cache git build-base make tzdata \
&& git clone https://github.com/fatedier/frp.git
WORKDIR /go/frp
RUN make frpc

FROM alpine:latest
RUN apk update && apk add --no-cache ca-certificates tzdata \
&& mkdir /frpc && cd /frpc \
&& mkdir -p /etc/frp && touch /etc/frp/frpc.ini
COPY --from=builder /go/frp/bin/frpc /frpc/
ENV TZ=Asia/Shanghai
WORKDIR /frpc
VOLUME /etc/frp
ENTRYPOINT ["./frpc","-c","/etc/frp/frpc.ini"]