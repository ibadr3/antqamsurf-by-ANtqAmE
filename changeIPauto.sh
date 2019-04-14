#!/bin/bash
#!--coded by ANtqAmE (ALI QASSEIM)--!#

export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'

# Destinations you don't want routed through Tor
TOR_EXCLUDE="192.168.0.0/16 172.16.0.0/12 10.0.0.0/8"

# The UID Tor runs as
# change it if, starting tor, the command 'ps -e | grep tor' returns a different UID
TOR_UID="debian-tor"

# Tor's TransPort
TOR_PORT="9040"

# Is resolvconf installed?
if [[ ! -z `dpkg -l |grep resolvconf` ]]; then 
	resolvconf_support=true;
else
	resolvconf_support=false;
fi


function init {
	echo -e -n " $GREEN*$BLUE killing dangerous applications$RESETCOLOR\n"
	killall -q  dropbox iceweasel skype icedove thunderbird  xchat transmission deluge pidgin pidgin.orig
	
	echo -e -n " $GREEN*$BLUE cleaning some dangerous cache elements"
	bleachbit -c adobe_reader.cache chromium.cache chromium.current_session chromium.history elinks.history emesene.cache epiphany.cache firefox.url_history flash.cache flash.cookies google_chrome.cache google_chrome.history  links2.history opera.cache opera.search_history opera.url_history &> /dev/null
}

function ip {

	echo -e "$yallow  My ip is:\n"
	sleep 1
	curl "http://myexternalip.com/raw" # Had a few issues with FrozenBox giving me the wrong IP address
	echo -e "  "
}

function start {
	# Make sure only root can run this script
	if [ $(id -u) -ne 0 ]; then
		echo -e -e "\n$GREEN[$RED!$GREEN] $RED This script must be run as root$RESETCOLOR\n" >&2
		exit 1
	fi
	
	# Check defaults for Tor
	grep -q -x 'RUN_DAEMON="yes"' /etc/default/tor
	if [ $? -ne 0 ]; then
		echo -e "\n$GREEN[$RED!$GREEN]$RED Please add the following to your /etc/default/tor and restart service:$RESETCOLOR\n" >&2
		echo -e "$BLUE#----------------------------------------------------------------------#$RESETCOLOR"
		echo -e 'RUN_DAEMON="yes"'
		echo -e "$BLUE#----------------------------------------------------------------------#$RESETCOLOR\n"
		exit 1
	fi	
	
	# Kill IPv6 services
	echo -e "\n$GREEN[$BLUE i$GREEN ]$BLUE Stopping IPv6 services:$RESETCOLOR\n"
	sed -i '/^.*\#kali-anonsurf$/d' /etc/sysctl.conf #delete lines containing #kali-anonsurf in /etc/sysctl.conf
	# add lines to sysctl.conf that will kill ipv6 services
	echo "net.ipv6.conf.all.disable_ipv6 = 1 #kali-anonsurf" >> /etc/sysctl.conf
	echo "net.ipv6.conf.default.disable_ipv6=1 #kali-anonsurf" >> /etc/sysctl.conf
	sysctl -p > /dev/null  # have sysctl reread /etc/sysctl.conf

	echo -e "\n$GREEN[$BLUE i$GREEN ]$BLUE Starting anonymous mode:$RESETCOLOR\n"
	
	if [ ! -e /var/run/tor/tor.pid ]; then
		echo -e " $RED*$BLUE Tor is not running! $GREEN starting it $BLUE for you$RESETCOLOR\n" >&2
		service network-manager force-reload > /dev/null 2>&1
		killall dnsmasq > /dev/null 2>&1
		killall nscd > /dev/null 2>&1	
		service tor start
		sleep 1
	fi
	if ! [ -f /etc/network/iptables.rules ]; then
		iptables-save > /etc/network/iptables.rules
		echo -e " $GREEN*$BLUE Saved iptables rules$RESETCOLOR\n"
	fi
	
	iptables -F
	iptables -t nat -F
	
	if [ "$resolvconf_support" = false ] 
	then
		cp /etc/resolv.conf /etc/resolv.conf.bak
		touch /etc/resolv.conf
		echo -e 'nameserver 127.0.0.1\nnameserver 209.222.18.222\nnameserver 209.222.18.218' > /etc/resolv.conf
		echo -e " $GREEN*$BLUE Modified resolv.conf to use Tor and Private Internet Access DNS"
	else
		cp /etc/resolvconf/resolv.conf.d/head{,.bak}
                echo -e 'nameserver 127.0.0.1\nnameserver 209.222.18.222\nnameserver 209.222.18.218' >> /etc/resolvconf/resolv.conf.d/head
                echo -e " $GREEN*$BLUE Modified resolvconf to use localhost and Private Internet Access DNS$RESETCOLOR\n"
                resolvconf -u
	fi

	# set iptables nat
	iptables -t nat -A OUTPUT -m owner --uid-owner $TOR_UID -j RETURN
	iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53
	iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 53
	iptables -t nat -A OUTPUT -p udp -m owner --uid-owner $TOR_UID -m udp --dport 53 -j REDIRECT --to-ports 53
	
	#resolve .onion domains mapping 10.192.0.0/10 address space
	iptables -t nat -A OUTPUT -p tcp -d 10.192.0.0/10 -j REDIRECT --to-ports 9040
	iptables -t nat -A OUTPUT -p udp -d 10.192.0.0/10 -j REDIRECT --to-ports 9040
	
	#exclude local addresses
	for NET in $TOR_EXCLUDE 127.0.0.0/9 127.128.0.0/10; do
		iptables -t nat -A OUTPUT -d $NET -j RETURN
	done
	
	#redirect all other output through TOR
	iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $TOR_PORT
	iptables -t nat -A OUTPUT -p udp -j REDIRECT --to-ports $TOR_PORT
	iptables -t nat -A OUTPUT -p icmp -j REDIRECT --to-ports $TOR_PORT
	
	#accept already established connections
	iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	
	#exclude local addresses
	for NET in $TOR_EXCLUDE 127.0.0.0/8; do
		iptables -A OUTPUT -d $NET -j ACCEPT
	done
	
	#allow only tor output
	iptables -A OUTPUT -m owner --uid-owner $TOR_UID -j ACCEPT
	iptables -A OUTPUT -j REJECT

	echo -e "$GREEN *$BLUE All traffic was redirected through Tor$RESETCOLOR\n"
	echo -e "$GREEN[$BLUE i$GREEN ]$BLUE You are under AnonSurf tunnel$RESETCOLOR\n"
}





function stop {
	# Make sure only root can run our script
	if [ $(id -u) -ne 0 ]; then
		echo -e "\n$GREEN[$RED!$GREEN] $RED This script must be run as root$RESETCOLOR\n" >&2
		exit 1
	fi
	echo -e "\n$GREEN[$BLUE i$GREEN ]$BLUE Stopping anonymous mode:$RESETCOLOR\n"

	iptables -F
	iptables -t nat -F
	echo -e " $GREEN*$BLUE Deleted all iptables rules\n$RESETCOLOR"
	
	if [ -f /etc/network/iptables.rules ]; then
		iptables-restore < /etc/network/iptables.rules
		rm /etc/network/iptables.rules
		echo -e " $GREEN*$BLUE Iptables rules restored"
	fi
	
	# restore DNS settings
	if [ "$resolvconf_support" = false ] 
	then
		if [ -e /etc/resolv.conf.bak ]; then
			rm /etc/resolv.conf
			cp /etc/resolv.conf.bak /etc/resolv.conf
		fi
	else
		mv /etc/resolvconf/resolv.conf.d/head{.bak,}
		resolvconf -u
	fi
	
	service tor stop
	
	echo -e "\n$GREEN[$BLUE i$GREEN ]$BLUE Reenabling IPv6 services:$RESETCOLOR\n"

	# reenable IPv6 services
	sed -i '/^.*\#kali-anonsurf$/d' /etc/sysctl.conf #delete lines containing #kali-anonsurf in /etc/sysctl.conf
	sysctl -p # have sysctl reread /etc/sysctl.conf

	service network-manager force-reload > /dev/null 2>&1
	service nscd start > /dev/null 2>&1
	service dnsmasq start > /dev/null 2>&1
	
	echo -e " $GREEN*$BLUE Anonymous mode stopped$RESETCOLOR\n"
}


case "$1" in
	start)
		init
		start
	;;
	stop)
		init
		stop
	;;
	myip|ip)
		ip
	;;

esac

echo -e $RESETCOLOR
exit 0
