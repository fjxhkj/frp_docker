## dockerhub镜像版本

```
version: "3.8"
services:
  frps:
    container_name: fonny-frps
    image: fonny/frps:latest
    environment:
      FRPV: 0.34.3
      FRPE: frps
    volumes:
      - /frp/config:/config:ro
    ports:
      - "7000:7000"
      - "80:80"
      - "443:443"
    restart: always
```

## 本机编译版本

```
version: "3.8"
services:
  frps:
    container_name: fonny-frps
    build:
      context: https://github.com/fjxhkj/frp_docker.git
      dockerfile: Dockerfile
      args:
        FRPV: 0.34.3
        FRPE: frps
    environment:
      FRPV: 0.34.3
      FRPE: frps
    volumes:
      - /frp/config:/config:ro
    ports:
      - "7000:7000"
      - "80:80"
      - "443:443"
    restart: always
```