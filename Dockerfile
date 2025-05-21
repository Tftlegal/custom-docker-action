# Base Docker image 
FROM alpine:latest

# installes required packages for our script
RUN apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  jq

# copy bash script to filesystem alpine OS
COPY entrypoint.sh /entrypoint.sh

# change permission to execute our script
RUN chmod +x /entrypoint.sh

# execute bash script when container start
ENTRYPOINT ["/entrypoint.sh"]
