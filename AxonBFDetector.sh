#!/bin/bash

echo ""
echo "🚨 Scanning logs for Brute Force SSH login attempts..."
echo "======================================================="

# Set threshold for brute force detection
THRESHOLD=5

# Extract and count failed login attempts
journalctl | grep "Failed password" > brute_force_raw.log

if [[ ! -s brute_force_raw.log ]]; then
    echo "✅ No brute force attempts found."
    exit 0
fi

echo ""
echo "Top Offending IPs (IPv4 and IPv6) with attempt counts:"
echo "-------------------------------------------------------"

# Extract IPs (IPv4 + IPv6)
grep -oP 'from \K[\d.:]+' brute_force_raw.log | sort | uniq -c | sort -nr > brute_force_summary.log
cat brute_force_summary.log

echo ""
echo "🎯 Detailed Brute Force Attempt Info:"
echo "-------------------------------------"

while read -r line; do
    count=$(echo $line | awk '{print $1}')
    ip=$(echo $line | awk '{print $2}')
    
    if [ "$count" -ge "$THRESHOLD" ]; then
        echo "-------------------------------------"
        echo "Date       : $(date '+%d %b %Y, %H:%M:%S')"
        echo "Source IP  : $ip"
        echo "Attempts   : $count"
        echo "Username   : $(grep "$ip" brute_force_raw.log | awk '{print $(NF-5)}' | sort | uniq | tr '\n' ', ')"
        echo "Port       : $(grep "$ip" brute_force_raw.log | awk '{print $(NF-1)}' | sort | uniq | tr '\n' ', ')"
        echo "Service    : sshd"
        echo "Severity   : HIGH"
        echo "Recommendation: Block IP $ip using UFW or Fail2Ban and report to SOC."
    fi
done < brute_force_summary.log

# Clean up
rm brute_force_raw.log brute_force_summary.log
