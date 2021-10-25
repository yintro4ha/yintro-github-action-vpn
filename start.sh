#!/bin/sh

echo "------------ Init IP ------------"
inet_ip=$(ip route show |grep link | awk '{print $9}' )
echo $inet_ip > /root/ip.txt
echo Internl IP: $inet_ip
echo "------------ IP ------------"

if [ -z "$VPN_PASSWORD" -o -z "$VPN_IP" -o -z "$VPN_PORT" -o -z "$VPN_USER" ]; then
  echo "Variables VPN_PASSWORD, VPN_IP, VPN_PORT and VPN_USER must be set."; exit;
fi

iptables -t nat -A POSTROUTING -j MASQUERADE

# Setup masquerade, to allow using the container as a gateway
for iface in $(ip a | grep eth | grep inet | awk '{print $2}'); do
  iptables -t nat -A POSTROUTING -s "$iface" -j MASQUERADE
done

/gateway-fix.sh &

echo "------------ VPN Starts ------------"
/usr/bin/forticlient
echo "------------ VPN exited ------------"


