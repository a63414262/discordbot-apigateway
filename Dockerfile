# 使用官方 Node.js 20 稳定版的轻量镜像
FROM node:20-slim

# 更新包列表并安装必备依赖：curl 用于下载二进制内核，ca-certificates 用于处理 HTTPS 证书验证
RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 设置容器内的工作目录
WORKDIR /app

# 复制 package.json 到容器中
COPY package.json ./

# 提前安装 adm-zip 依赖。
# 虽然你的代码里有“极度静默版”的自动安装逻辑，但在 Docker 中提前打包进镜像可以加快每次重启的速度
RUN npm install adm-zip

# 复制你的主体 JS 代码到容器中
COPY index.js ./

# 声明容器内部使用的端口（代码中依赖于 3000 和 3001）
EXPOSE 3000
EXPOSE 3001

# 设置默认的环境变量（非必须，但可以作为占位符）
ENV PORT=3000
ENV UUID="de04acca-1af7-4b13-90ce-64197351d4c6"
ENV ARGO_AUTH=""

# 启动容器时执行的命令
CMD ["node", "index.js"]
