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
resize -s 31 94 > /dev/null
clear
echo "$cayn

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
         echo  " \e[1;32m [+] Your ip change done "
         sleep 60
         changeIPauto restart > /dev/null
         echo  " \e[1;32m [+] Your ip change done "
         done
       ;;
   stop)
       changeIPauto stop > /dev/null
       echo  " \e[1;31m [!] ANTQAMSURF closed done "
       ;;
   myip||ip)
							echo "$cayn

												 █████╗ ███╗   ██╗████████╗ ██████╗  █████╗ ███╗   ███╗███████╗██╗   ██╗██████╗ ███████╗
												██╔══██╗████╗  ██║╚══██╔══╝██╔═══██╗██╔══██╗████╗ ████║██╔════╝██║   ██║██╔══██╗██╔════╝
												███████║██╔██╗ ██║   ██║   ██║   ██║███████║██╔████╔██║███████╗██║   ██║██████╔╝█████╗  
												██╔══██║██║╚██╗██║   ██║   ██║▄▄ ██║██╔══██║██║╚██╔╝██║╚════██║██║   ██║██╔══██╗██╔══╝  
												██║  ██║██║ ╚████║   ██║   ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████║╚██████╔╝██║  ██║██║     
												╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝    ╚══▀▀═╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝     
   
							echo  "$yallow  My ip is:"
							sleep 1
							curl "http://myexternalip.com/raw" # Had a few issues with FrozenBox giving me the wrong IP address
	      echo  " "$nocolor
							;;
esac
