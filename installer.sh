#!/usr/bin/bash
#!--coded by ANtqAmE (ALI QASSEIM)--!#
## COLORS ###############
white="\e[1;37m" 
red="\e[1;31m" 
green="\e[1;32m" 
yallow="\e[1;33m" 
cayn="\e[1;36m"
blue="\e[1;34m"
wrde="\e[1;35m"
nocolor="\e[0m"
#########################
resize -s 24 94 > /dev/null
clear
#-----------------------#

# Ensure we are being ran as root
if [ $(id -u) -ne 0 ]; then
	echo "This script must be ran as root"
	exit 1
fi

# For upgrades and sanity check, remove any existing i2p.list file
rm -f /etc/apt/sources.list.d/i2p.list

# Compile the i2p ppa
echo "deb http://deb.i2p2.no/ unstable main" > /etc/apt/sources.list.d/i2p.list # Default config reads repos from sources.list.d
wget https://geti2p.net/_static/i2p-debian-repo.key.asc -O /tmp/i2p-debian-repo.key.asc # Get the latest i2p repo pubkey
apt-key add /tmp/i2p-debian-repo.key.asc # Import the key
rm /tmp/i2p-debian-repo.key.asc # delete the temp key
apt-get update # Update repos

if [[ -n $(cat /etc/os-release |grep kali) ]]
then
	apt-get install libservlet3.0-java 
	wget http://ftp.us.debian.org/debian/pool/main/j/jetty8/libjetty8-java_8.1.16-4_all.deb
	dpkg -i libjetty8-java_8.1.16-4_all.deb # This should succeed without error
	apt-get install libecj-java libgetopt-java libservlet3.0-java glassfish-javaee ttf-dejavu i2p i2p-router libjbigi-jni #installs i2p and other dependencies
	apt-get -f install # resolves anything else in a broken state
fi

apt-get install -y i2p-keyring #this will ensure you get updates to the repository's GPG key
apt-get install -y secure-delete tor i2p # install dependencies, just in case

# Configure and install the .deb
dpkg-deb -b kali-anonsurf-deb-src/ kali-anonsurf.deb # Build the deb package
dpkg -i kali-anonsurf.deb || (apt-get -f install && dpkg -i kali-anonsurf.deb) # this will automatically install the required packages

#############################################################################################

mv changeIPauto.sh /etc/init.d/changeIPauto && chmod +x /etc/init.d/changeIPauto > /dev/null
mv antqamsurf.sh /etc/init.d/antqamsurf && chmod +x /etc/init.d/antqamsurf > /dev/null
sleep 3.5
clear


echo -e "$wrde
        install this tool is done 

        Usage : 
                type in anywhere antqamsurf to run

                antqamsurf [option]

                use this command to run :
                antqamsurf start

                use this command to stop :
                antqamsurf stop


                 ________________________________________________________________________________
                |          .::        ::.            	       .::             ::.              |
                +===================================+============================================+
                |              [+] this script coded by ANtqAmE (ALI QASSEIM) [+]                |
                |              Facebook: https://www.facebook.com/ANtqAmE                        |
                |              Youtube : https://www.youtube.com/channel/UC1QRVK_K4jWPDXm798orw-g|
                |===================================+============================================|

"$nocolor