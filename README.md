## frp docker

本Dockerfile通过编译时和运行时传递变量实现frp自动更新,一个文件即可,无需分别编写frps和frpc的Dockerfile.

<https://hub.docker.com/r/fonny/frpc>

<https://github.com/fjxhkj/frp_docker>

### 使用方法

#### 编译时

如果新版本号为 `0.34.3` 则直接使用以下命令即可编译最新镜像,通过参数选择 frps/frpc

```bash
# frps
docker build --build-arg FRPE=frps --build-arg FRPV=0.34.3 -t fonny/frp .

# frpc
docker build --build-arg FRPE=frpc --build-arg FRPV=0.34.3 -t fonny/frp .
```

#### 运行时

frp的ini文件放到主机的`/root/config`目录中,运行容器:

```bash
# frps
docker run -e "FRPE=frps" -v="/root/config:/config" -p="7000:7000" -p="80:80" fonny/frp

# frpc
docker run -e "FRPE=frpc" -v="/root/config:/config" -p="7000:7000" -p="80:80" fonny/frp
```
