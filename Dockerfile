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