# Brute Force SSH Detection Tool 🔐

A simple yet powerful bash script to detect SSH brute-force login attempts using system logs (via `journalctl`) and automatically generate a report with affected IPs, usernames, ports, severity, and recommendations.

## 💡 Features
- Parses real-time logs for brute-force behavior
- Identifies suspicious IPs (IPv4 & IPv6)
- Extracts targeted ports & attempted usernames
- Suggests mitigation via UFW/Fail2Ban
- SOC-ready format output

## 🧰 Tools Used
- `bash`
- `journalctl`, `grep`, `awk`, `sort`, `uniq`
- (Optional) `ufw`, `fail2ban`

## 📦 How to Run
```bash
chmod +x BruteForceDetectorScript.sh
sudo ./BruteForceDetectorScript.sh
