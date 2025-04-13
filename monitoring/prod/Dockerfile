FROM telegraf:1.34.1

# 텔레그래프 사용자의 UID와 GID 변경
RUN usermod -u 1000 telegraf && \
    groupmod -g 1001 telegraf && \
    chown -R telegraf:telegraf /etc/telegraf /var/log/telegraf

USER telegraf