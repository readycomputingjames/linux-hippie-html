#!/bin/bash
#########################################################################
# James Hipp
# System Support Engineer
# Ready Computing
#
# Hippie Monitor Script for Linux
#
# Currently Functionality Supports RHEL/CentOS 7+ and Ubuntu
#
# This can be run for ad-hoc reporting on a system(s), but my
# use will be with a wrapper script to send emails with cron in
# order to see historical data over time (such as hourly).
#
# Usage = hippie_mon.sh <command>
#
# Ex: ./hippie_mon.sh --help
# Ex: ./hippie_mon.sh --rhel
# Ex: ./hippie_mon.sh --ubuntu
#
# (See Help Function for Full Usage Notes)
#
#
### CHANGE LOG ###
#
# 20190808 = Converted this to run with multiples hosts using Hippie_Mon_DSSH
# 20190808 = Updated to condense output for email text
# 20190810 = Added divide by zero check for ram and swap
#
#########################################################################

VERSION="1.00"

INPUT_COMMAND1=$1

TIMESTAMP=`date`
HOSTNAME=`hostname`

help_text()
{

   # Print Help Text
   echo "----------------------"
   echo "hippie_mon.sh"
   echo "----------------------"
   echo ""
   echo "Usage:"
   echo "hippie_mon.sh <command>"
   echo ""
   echo "Commands:"
   echo "--help = Show help notes for this script"
   echo "--rhel = Run script for RHEL/CentOS 7+ platforms"
   echo "--ubuntu = Run script for Ubuntu platforms"
   echo "--version = Print out script version"
   echo ""
   echo "Examples:"
   echo "./hippie_mon.sh --rhel"
   echo "./hippie_mon.sh --ubuntu"
   echo ""

}

rhel_mon()
{

   # Primary RHEL/CentOS Monitor Function

   # Show Hostname and Version Details
   /usr/bin/hostnamectl |egrep -i "hostname|System|Kernel"

   echo "<br>"

   # Show NTP Info
   /usr/bin/timedatectl |egrep "Local time|NTP"

   echo "<br>"

   # Show Memory Utilization at this Point in Time
   ram=`/usr/bin/free -m |grep Mem |awk '{print $3/$2 * 100.0}'`
   swap=`/usr/bin/free -m |grep Swap |awk '{print $3/$2 * 100.0}'`

   ### Check if Zero so we do not get a Divide by Zero Warning ###
   if [ "$ram" -eq "0" ]
   then
      echo "-> Percentage of RAM in Use: 0.00"
   else
      echo "-> Percentage of RAM in Use: $ram"
   fi
   if [ "$swap" -eq "0" ]
   then
      echo "-> Percentage of Swap in Use: 0"
   else
      echo "-> Percentage of Swap in Use: $swap"
   fi

   echo "<br>"

   # Show CPU Utilization at this Point in Time
   /usr/bin/top -bn1 |grep -v KiB |head -n 16
   echo "   .........."

   echo "<br>"

   # Disk Space
   /usr/bin/df -h |head -n 1
   /usr/bin/df -h |sort -nr -k 5,5 |grep -v Avail

   echo "<br>"

}

ubuntu_mon()
{

   # Primary Ubuntu Monitor Function

   echo "placeholder"

}

rhel_main()
{

   # Main Function for RHEL/CentOS Flag

   echo "----------------------------------"
   echo "Gathering Monitor Performance Data"
   echo "----------------------------------"
   echo "Runtime = $TIMESTAMP"
   echo "<br>"

   rhel_mon

}

ubuntu_main()
{

   # Main Function for Ubuntu Flag

   echo "placeholder"


}

main ()
{

   # Main Function for Overall Script

   # This is in Case You are Using SendMail
   ### Ex: ./hippy_mond.sh --rhel |sendmail <email_address> ###
   #echo "Subject: Hippie-Mon Script Results for $HOSTNAME for $TIMESTAMP"

   # Parse out CLI Argument to see what we Need to do
   case $INPUT_COMMAND1 in
      --help)
         help_text
      ;;
      --rhel)
        rhel_main
      ;;
      --ubuntu)
        ubuntu_main
      ;;
      --version)
         echo ""
         echo "Script Version = $VERSION"
         echo ""
      ;;
      *)
         echo ""
         echo "$INPUT_COMMAND1 = Not Valid Input"
         echo ""
         help_text
   esac

}

main

