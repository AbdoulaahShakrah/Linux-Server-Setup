


files="/etc/passwd /etc/group /etc/shadow /var/log /home /partilhasNFS"

tar -czvf "/etc/backup/backup_files_$(date +%Y%m%d).tar.gz" "$files"

rsync -avh --delete --backup --backup-dir="/etc/backup/incremental_backup_$(date +'%Y%m%d')" /home /etc/backup/incremental_backup_latest

