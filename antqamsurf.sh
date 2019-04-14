#!/usr/bin/bash
#!--coded by ANtqAmE (ALI QASSEIM)--!#
## COLORS ###############
white="033[1;37m" 
red="\033[1;31m" 
green="\033[1;32m" 
yallow="\033[1;33m" 
cayn="\033[1;36m"
blue="\033[1;34m"
wrde="\033[1;35m"
nocolor="\033[0m"
#########################
resize -s 31 94 > /dev/null
clear
echo -e "$cayn

 █████╗ ███╗   ██╗████████╗ ██████╗  █████╗ ███╗   ███╗███████╗██╗   ██╗██████╗ ███████╗
██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗██╔══██╗████╗ ████║██╔════╝██║   ██║██╔══██╗██╔════╝
███████║██╔██╗ ██║   ██║   ██║   ██║███████║██╔████╔██║███████╗██║   ██║██████╔╝█████╗  
██╔══██║██║╚██╗██║   ██║   ██║▄▄ ██║██╔══██║██║╚██╔╝██║╚════██║██║   ██║██╔══██╗██╔══╝  
██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████║╚██████╔╝██║  ██║██║     
╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚══▀▀═╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     
                                                                                        
$yallow change your ip every minute$nocoloe
$wrde
Usage : antqamsurf [option]

        use this command to run :
        antqamsurf start

        use this command to stop :
        antqamsurf stop
        use this command to show your ip :
        antqamsurf myip || ip

        ________________________________________________________________________________
       |          .::        ::.            	       .::             ::.              |
       +===================================+============================================+
       |              [+] this script coded by ANtqAmE (ALI QASSEIM) [+]                |
       |              Facebook: https://www.facebook.com/ANtqAmE                        |
       |              Youtube : https://www.youtube.com/channel/UC1QRVK_K4jWPDXm798orw-g|
       |===================================+============================================|


"$nocolor
case "$1" in
   start)
         for i in range{1..10000}
         do
         changeIPauto start > /dev/null
         echo  -e " \e[1;32m [+] Your ip change done "
         sleep 60
         changeIPauto restart > /dev/null
         echo  -e " \e[1;32m [+] Your ip change done "
         done
       ;;
   stop)
       changeIPauto stop > /dev/null
       echo  -e " \e[1;31m [!] ANTQAMSURF closed done "
       ;;
   myip||ip)
	echo -e "$cayn

	 █████╗ ███╗   ██╗████████╗ ██████╗  █████╗ ███╗   ███╗███████╗██╗   ██╗██████╗ ███████╗
	██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗██╔══██╗████╗ ████║██╔════╝██║   ██║██╔══██╗██╔════╝
	███████║██╔██╗ ██║   ██║   ██║   ██║███████║██╔████╔██║███████╗██║   ██║██████╔╝█████╗  
	██╔══██║██║╚██╗██║   ██║   ██║▄▄ ██║██╔══██║██║╚██╔╝██║╚════██║██║   ██║██╔══██╗██╔══╝  
	██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████║╚██████╔╝██║  ██║██║     
	╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚══▀▀═╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     
   
	echo  -e "$yallow  My ip is:"
	sleep 1
	curl "http://myexternalip.com/raw" 
	echo  -e " "$nocolor
	;;
esac
