#!/bin/bash
usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$usage" -gt 80 ]; then
	echo "$(date '+%Y-%m-%d %H:%M:%S') Alert - disk utilization is $usage%"
else 
	echo "$(date '+%Y-%m-%d %H:%M:%S') OK - disk utilization is $usage%"
fi

