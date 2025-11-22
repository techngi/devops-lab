#!/bin/bash
backup_date=$(date +%F)
backup_file="/backup/etc/$backup_date.tar.gz"
/bin/tar -czf "$backup_file" /etc

echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup saved to $backup_file"
