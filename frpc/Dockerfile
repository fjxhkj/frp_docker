FROM alpine:latest
RUN apk update && apk add --no-cache ca-certificates tzdata
ENV TZ=Asia/Shanghai
WORKDIR /
RUN set -ex \
	&& mkdir /frp /config \
	&& wget --no-check-certificate https://github.com/fatedier/frp/releases/download/v0.34.3/frp_0.34.3_linux_amd64.tar.gz \
	&& tar xzf frp_0.34.3_linux_amd64.tar.gz \
	&& mv frp_0.34.3_linux_amd64/frpc /frp/ \
	&& mv frp_0.34.3_linux_amd64/frpc.ini /config/ \
	&& rm -rf *.tar.gz frp_0.34.3_linux_amd64

ENTRYPOINT /frp/frpc -c /config/frpc.ini