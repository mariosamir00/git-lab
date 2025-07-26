#!/bin/bash

clear
echo "------------------------------------" #Visual Seperator

memory() {

local mem_total=$(free -m | grep Mem: | awk '{print $2}')
local mem_used=$(free -m | grep Mem: | awk '{print $3}')
local mem_free=$(free -m | grep Mem: | awk '{print $4}')
local mem_cache=$(free -m | grep Mem: | awk '{print $6}')
local mem_available=$(free -m | grep Mem: | awk '{print $7}')
local mem_usage=$(echo "scale=2; $mem_used / $mem_total *100" | bc -l )

echo "MEMORY UTILIZATION"
echo ""
echo "Total Memory:         $mem_total MB"
echo "Available Memory:         $mem_available MB"
echo "Buffer+Cache Memory:         $mem_cache MB"
echo "Free Memory:         $mem_free MB"
echo "Memory Usage Percentage:         $mem_usage %"

if [[ "$mem_available" -le 100 ]]
then 
    echo "Available Memory or the free and buffer+cache Memory is too low"
else
    echo "Memory is ok!"
fi

echo "------------------------------------"
}

disk_usage() {
echo "------------------------------------"
echo "DISK UTILIZATION"

local slash_used=$(df -m / | grep /dev | awk '{print $5}' )
local slash_used_raw=${slash_used//%/}
local slash_free=$((100-slash_used_raw))
local home_used=$(df -m /home/ | grep /dev | awk '{print $5}' )
local home_used_raw=${home_used//%/}
local home_free=$((100-home_used_raw))

echo "Root(/) Used:                 $slash_used"
echo "Root(/) Available:                 $slash_free%"
echo ""
echo "Home(/home) Used:         $home_used"
echo "Home(/home) Available:         $home_free%"

if [[ "$slash_used_raw" -gt 95 || "$home_used_raw" -gt 95 ]]
then
    echo "Disk is almost full! Free up some space!"
else
    echo "Disk is ok"
fi

echo "------------------------------------"
}

cpu_util() {
echo "------------------------------------"

local num_cores=$(nproc)
local load_average=$(awk '{print $3}' /proc/loadavg)

echo "Number of Cores: $num_cores"
echo "Total CPU Load Average for the past 15 minutes: $load_average"

local load_int=${load_average%.*}

if [[ "$load_int" -gt "$num_cores" ]]
then
    echo "Critical! Load average is too high!"
elif [[ "$load_int" -eq "$num_cores" ]]
then 
    echo "Load average not ideal."
else 
    echo "CPU load is ok"
fi
}

#Calling funtions
memory
disk_usage
cpu_util