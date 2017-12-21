#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH

# Check System Release
if [ -f /etc/redhat-release ]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
fi

# Check root
[[ $EUID -ne 0 ]] && echo -e "${RED}Error:${PLAIN} This script must be run as root!" && exit 1

# Install some dependencies
if [ "${release}" == "centos" ]; then
	yum -y install wget ca-certificates locales localedef 
else
	apt-get update 
	apt-get -y install wget ca-certificates locales 
fi

# Get Word dir
dir=$(pwd)

# Change Locale
if [ "${release}" == "centos" ]; then
	localedef -v -c -i zh_CN -f UTF-8 zh_CN.UTF-8 > /dev/null 2>&1
	cd /etc
	rm -rf locale.conf
	wget https://raw.githubusercontent.com/FunctionClub/LocaleCN/master/locale.conf > /dev/null 2>&1
	cp locale.conf locale
	cat locale.conf >> /etc/environment

elif [ "${release}" == "debian" ]; then
	rm -rf /etc/locale.gen
	rm -rf /etc/default/locale
	rm -rf /etc/default/locale.conf
	cd /etc/
	wget https://raw.githubusercontent.com/FunctionClub/LocaleCN/master/locale.gen > /dev/null 2>&1
	locale-gen
	cd /etc/default/
	wget https://raw.githubusercontent.com/FunctionClub/LocaleCN/master/locale.conf > /dev/null 2>&1
	cp locale.conf locale
elif [ "${release}" == "ubuntu" ]; then
		rm -rf /etc/locale.gen
	rm -rf /etc/default/locale
	rm -rf /etc/default/locale.conf
	cd /etc/
	wget https://raw.githubusercontent.com/FunctionClub/LocaleCN/master/locale.gen > /dev/null 2>&1
	locale-gen
	cd /etc/default/
	wget https://raw.githubusercontent.com/FunctionClub/LocaleCN/master/locale.conf > /dev/null 2>&1
	cp locale.conf locale
fi

# Echo Success
clear
echo "Your VPS Language setting is changed to Chinese(Simplified)"
echo "Reconnect to your VPS to check it"
echo ""
echo "Powered By zhujiboke.com "
echo "QQ Group: 119612388"

# Delete self
cd ${dir}
rm -rf LocaleCN.sh
