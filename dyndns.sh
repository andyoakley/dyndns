#!/bin/bash
ZONE="test.com"
HOST="server"


#ACTUAL=`curl -s http://icanhazip.com`
ACTUAL4=`ip addr show dev eth0 | grep inet | grep global | sed -nr 's/.*inet ([^/]+).*/\1/p'`
ACTUAL6=`ip addr show dev eth0 | grep inet6 | grep global | sed -nr 's/.*inet6 ([^/]+).*/\1/p'`


# something went wrong
if [ "$ACTUAL4" == "" ]; then
	exit
fi


DNS4=`dig +short $HOST.$ZONE`
DNS6=`dig -t aaaa +short $HOST.$ZONE`


if [ "$ACTUAL4" != "$DNS4" ]; then
        /usr/local/bin/route53 --zone $ZONE -g --name "$HOST.$ZONE." --type A --values $ACTUAL4 > /dev/null
	echo IPv4 address change from $DNS4 to $ACTUAL4
fi

if [ "$ACTUAL6" != "$DNS6" ]; then
	/usr/local/bin/route53 --zone $ZONE -g --name "$HOST.$ZONE." --type AAAA --values $ACTUAL6 > /dev/null
	echo IPv6 address change from $DNS6 to $ACTUAL6
fi

