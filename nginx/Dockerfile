FROM nginx:latest

RUN apt-get update && apt-get install -y \
    bash coreutils gzip procps stress

COPY stress.sh /stress.sh
RUN chmod +x /stress.sh

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["/bin/bash", "-c", "/stress.sh & nginx -g 'daemon off;'"]
