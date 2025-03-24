FROM alpine:latest AS builder

WORKDIR /app

RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories
RUN apk add go --repository=https://mirrors.tuna.tsinghua.edu.cn/alpine/edge/community
RUN go env -w  GOPROXY=https://goproxy.cn,direct
RUN go install tailscale.com/cmd/derper@latest

FROM alpine:latest

RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#https://mirrors.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories
RUN apk add curl iptables
RUN apk add tailscale --repository=https://mirrors.tuna.tsinghua.edu.cn/alpine/edge/community

RUN mkdir -p /root/go/bin
COPY --from=builder /root/go/bin/derper /root/go/bin/derper

COPY init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 12345/tcp
EXPOSE 12346/udp

ENTRYPOINT /init.sh
