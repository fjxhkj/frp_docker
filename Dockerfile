# 如果新版本号为 0.34.4 则直接使用以下命令即可编译最新镜像,通过参数选择 frps/frpc
# docker build --build-arg FRPE=frps --build-arg FRPV=0.34.4 -t fjxhkj/frp .
# docker build --build-arg FRPE=frpc --build-arg FRPV=0.34.4 -t fjxhkj/frp .
# frpx.ini放到`/root/config`目录中,运行容器:
# docker run -e "FRPE=frps" -v="/root/config:/config" -p="7000:7000" -p="80:80" fjxhkj/frp

FROM alpine:latest
RUN apk update && apk add --no-cache ca-certificates tzdata
ENV TZ=Asia/Shanghai
WORKDIR /
ARG FRPV
ARG FRPE
ENV FRPV=${FRPV:-0.34.3}
ENV FRPE=${FRPE:-frps}
RUN set -ex && \
	wget --no-check-certificate https://github.com/fatedier/frp/releases/download/v${FRPV}/frp_${FRPV}_linux_amd64.tar.gz && \
	tar xzf frp_${FRPV}_linux_amd64.tar.gz && \
	cd frp_${FRPV}_linux_amd64 && \
	mkdir /frp /config && \
	mv ${FRPE} /frp && \
	mv ${FRPE}.ini /config && \
	cd .. && \
	rm -rf *.tar.gz frp_${FRPV}_linux_amd64

VOLUME /config
ENTRYPOINT /frp/${FRPE} -c /config/${FRPE}.ini