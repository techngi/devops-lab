# DevOps Labs – Week 1: Linux, Bash & Git Foundations

This repository documents my Week 1 practical work as part of my **DevOps Transition Roadmap (Nov 2025 → Feb 2026)**.  
The focus is on building strong Linux, Bash, and Git fundamentals — forming the backbone of all DevOps work.

---

## 📅 Week 1 Objectives
✅ Strengthen Linux administration skills  
✅ Automate routine tasks using Bash scripting  
✅ Practise Git branching and version control  
✅ (Optional) Deploy and manage a simple web server (Apache/Nginx)

---

## 🧩 Folder Structure

| Folder | Description |
|--------|--------------|
| `linux_basics/` | Linux user management, system monitoring, networking exercises |
| `bash_scripts/` | Automation scripts (disk alert, backup, system info) |
| `web_server/` | Mini Nginx deployment + automation |
| `git_practice/` | Version control exercises and documentation |

---

## 🖥️ Highlights

### 🔧 Linux Basics
- Created and managed users (`devuser`, `opsuser`, `readonly`)
- Set up permissions and groups
- Monitored CPU, memory, and disk usage
- Configured firewall (UFW) to allow SSH/HTTP only

### ⚙️ Bash Automation
| Script | Function |
|--------|-----------|
| `disk_alert.sh` | Monitors disk usage and logs alerts when >80% |
| `backup_daily.sh` | Compresses `/etc` directory daily and saves to `/backup` |
| `system_info.sh` | Prints hostname, uptime, CPU, RAM, and IP info |

### 🌐 Web Server Setup
- Installed and configured Nginx
- Custom HTML page served from local VM
- Automated Nginx restart if stopped
- Backup script for `/etc/nginx/`

### 🧠 Git Practice
- Created branches, merged via pull requests, and tagged version `v1.0`
- Practised reverting commits and viewing history

---

## 📸 Screenshots

Screenshots of successful outputs and terminal logs are inside each respective folder (e.g., `linux_basics/screenshots/`).

---

## 🧭 Next Steps (Week 2 Preview)
- Integrate Terraform + Ansible to deploy and configure the same environment automatically.
- Begin building the foundation for an end-to-end CI/CD pipeline.

---

**Author:** Syed Abbas 
**Date:** November 2025  
**LinkedIn:** www.linkedin.com/in/syed-abbas-4891a5175 
**GitHub:** https://github.com/techngi
