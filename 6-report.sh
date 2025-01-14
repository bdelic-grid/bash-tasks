#!/bin/bash

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

MEMSIZE=$(sysctl -n hw.memsize)
# convert to size in MB
echo "Total RAM size: $((MEMSIZE / 1024 / 1024))MB"
VMSTAT=$(vm_stat | grep "Pages free" | cut -d ":" -f 2 | xargs)
# remove trailing dot and convert number of pages to total size in MB
VMSTAT=$((${VMSTAT%?} * 4096 / 1024 / 1024))
echo "Free RAM: ${VMSTAT}MB"

NOFCORES=$(sysctl -n hw.ncpu)
echo "Number of cores: $NOFCORES"
FREQ=$(sysctl -n hw.cpufrequency)
echo "CPU frequency: $FREQ"
