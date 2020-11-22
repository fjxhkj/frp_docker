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

frp的ini文件放到主机的`/frp/config`目录中,运行容器:

```bash
# frps
docker run -e "FRPE=frps" -v="/frp/config:/config" -p="7000:7000" -p="80:80" fonny/frp

# frpc
docker run -e "FRPE=frpc" -v="/frp/config:/config" -p="7000:7000" -p="80:80" fonny/frp
```

### 使用dockerHub时

```bash
# frps

docker pull fonny/frps

# 注意镜像名称为 fonny/frps
docker run -e "FRPE=frps" -v="/frp/config:/config" -p="7000:7000" -p="80:80" fonny/frps

###########################
# frpc

docker pull fonny/frpc

# 注意镜像名称为 fonny/frpc
docker run -e "FRPE=frps" -v="/frp/config:/config" -p="7000:7000" -p="80:80" fonny/frpc
```

#### 推荐用 docker-compose

获取 `docker-compose.yml`

##### 通过 github

```dockerfile
mkdir /frp && \
cd /frp && \
git pull https://github.com/fjxhkj/frp_docker.git && \
cd /frp/frp_docker\docker-compose
```

##### 或直接复制以下内容

如果是frpc就替换一下frps即可.

提供的两种方式取决于你的机器访问github方便还是dockerhub方便,效果一样.

本机编译可能会占用更多磁盘空间.

###### 用dockerhub镜像

```dockerfile
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

###### 或本机编译

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

##### 运行

```
docker-compose up -d --force-recreate
```

## Nas中的docker应用设置方法

手头只有威联通,就以它的 `Container Station` 为例.

### 创建

搜索镜像文件,填入: `fonny`;

点击 `Docker Hub` 标签;

找到: `fonny/frpc` 镜像,点击创建;

点击 `资源` -> `镜像文件`,找到 `fonny/frpc` 的行,点击`+`加号;

弹出的 `创建Container` 对话框中:

 - 名称随意

 - 命令留空

 - 进入点改为: 

   ```
   /frp/frpc -c /config/frpc.ini
   ```

- 点击高级设置:

  - 环境修改:
    - 增加环境变量 `FRPV`, 值为你知道的最新版,比如 `0.34.3`
    - 增加环境变量 `FRPE`, 值为 `frpc`
  - 网络修改:
    - 网络模式: 选择 `Host` 
  - 设备修改:
    - 勾选 `在授权模式下启动Container` (如果你没有设置 `/frp/config` 目录权限的话)
  - 共享文件夹修改:
    - 挂载本机共享文件夹 -> 新增:
      - 本机路径改为: 你的 frpc.ini 所在的共享文件夹; 挂载路径填写: `/config`
  - 点击创建按钮;

- 点击ContainerStation左侧的`Containers`,找到刚刚创建的容器,点击运行.

- 完成.














