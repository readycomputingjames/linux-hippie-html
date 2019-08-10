#!/bin/bash
#########################################################################
# James Hipp
# System Support Engineer
# Ready Computing
#
# Wrapper Script for Hippy-Mon to Send Email with Cron
#
# Sample Cron Setup:
# [jhipp@test-server]$ crontab -l
# # James Test (Run this Hourly)
# 30 * * * * /path/to/hippie_mon_wrapper.sh > /dev/null 2>&1
#
#
#########################################################################

/home/jhipp/scripts/mon/hippie_mon_dssh.sh /home/jhipp/scripts/mon/hosts.list "/home/jhipp/scripts/mon/hippie_mon.sh --rhel |awk '{printf \"<div>\"; print}' |awk '{print \$0, \"</div>\"}'" |/usr/sbin/sendmail -t

