FROM ubuntu:16.04

RUN apt-get update && \
  apt-get install -y expect wget net-tools iproute ipppd iptables ssh curl iputils-ping nano && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /root

COPY forticlient-sslvpn_4.4.2329-1_amd64.deb forticlient-sslvpn_amd64.deb
RUN dpkg -x forticlient-sslvpn_amd64.deb /usr/share/forticlient

# # Run setup
RUN /usr/share/forticlient/opt/forticlient-sslvpn/64bit/helper/setup.linux.sh 2

# # Copy runfiles
COPY forticlient /usr/bin/forticlient
RUN chmod u+x /usr/bin/forticlient

COPY start.sh /start.sh
RUN chmod u+x /start.sh

COPY gateway-fix.sh /gateway-fix.sh
RUN chmod u+x /gateway-fix.sh

CMD [ "/start.sh" ]