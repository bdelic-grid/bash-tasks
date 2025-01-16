#!/bin/bash

# USAGE: ./6-report.sh - prints current date and time, name of current user, internal and external IPs, hostname, name and version of OS distribution, uptime, info about used and free disk space, info about total and free RAM, number and frequency of CPU cores

echo "Date: $(date)"
echo "User: $(whoami)"
echo "Internal IP and hostname: $(ipconfig getifaddr en0) $(hostname)"
echo "External IP: $(curl ifconfig.me 2>/dev/null)"

# xargs trims string
OSNAME=$(sw_vers | grep ProductName | cut -d ":" -f 2 | xargs)
OSVERSION=$(sw_vers | grep ProductVersion | cut -d ":" -f 2 | xargs)
echo "OS name and version: $OSNAME $OSVERSION"

a=($(uptime))
# %? removes trailing comma
echo "Uptime: ${a[2]%?}"

DISKINFO=($(df -H | grep /))
echo "Disk size and free space: ${DISKINFO[1]} ${DISKINFO[3]}"

MEM="$(top -l 1 | grep PhysMem)"
# remove trailing dot
MEM=${MEM%?}
echo $MEM

NOFCORES=$(sysctl -n hw.ncpu)
echo "Number of cores: $NOFCORES"
FREQ=$(sysctl -n hw.cpufrequency)
echo "CPU frequency: $FREQ"
