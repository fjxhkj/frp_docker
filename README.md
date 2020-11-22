## frp docker

本Dockerfile通过编译时和运行时传递变量实现frp自动更新,一个文件即可,无需分别编写frps和frpc的Dockerfile.

<https://hub.docker.com/r/fonny/frps>

<https://hub.docker.com/r/fonny/frpc>

<https://github.com/fjxhkj/frp_docker>

### 使用方法

#### 编译时

如果新版本号为 `0.34.3` 则直接使用以下命令即可编译最新镜像,通过参数选择 frps/frpc

```bash
# 要编译frpc只需修改变量FRPE
FRPE=frps && \
docker build --build-arg FRPE=${FRPE} --build-arg FRPV=0.34.3 -t fonny/${FRPE} .
```

#### 运行时

frp的ini文件放到主机的`/frp/config`目录中,运行容器:

```bash
# 要运行frpc只需修改变量FRPE
FRPE=frps && \
docker run -e "FRPE=${FRPE}" -v="/frp/config:/config" -p="7000:7000" -p="80:80" -p="443:443" fonny/${FRPE}
```

### 使用dockerHub时

```bash
# 要运行frpc只需修改变量FRPE
FRPE=frps && \
docker pull fonny/${FRPE} && \
docker run -e "FRPE=${FRPE}" -v="/frp/config:/config" -p="7000:7000" -p="80:80" -p="443:443" fonny/${FRPE}
```

### docker-compose

#### 通过 github获取 `docker-compose.yml`

```dockerfile
mkdir /frp && \
cd /frp && \
git clone https://github.com/fjxhkj/frp_docker.git && \
cd /frp/frp_docker\docker-compose
```

#### 或直接复制以下内容

如果是frpc就替换一下frps即可.

提供的两种方式取决于你的机器访问github方便还是dockerhub方便,效果一样.

本机编译可能会占用更多磁盘空间.

#### 用dockerhub镜像

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

#### 或本机编译

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

**注意,nas一般都是用frpc.**

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

