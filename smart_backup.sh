#!/bin/bash

read -p "Enter directory: " dir
recipient="andkocharyan1996@gmail.com"

smart_backup() {

target_name=$(eval echo "$1")
backup_dir="$HOME/backup_test"
mkdir -p "$backup_dir"

last_check="$backup_dir/.last_checksum"
logfile="$backup_dir/backup.log"
infofile="$backup_dir/info.log"
errorfile="$backup_dir/backup.err"

: > "$logfile"
: > "$infofile"
: > "$errorfile"

send_report() {
{
   echo "Backup report for $target_name"
   echo "___________________________"

   echo "Success log:"
   [ -s "$logfile" ] && cat "$logfile" || echo  "No success logs"

   echo ""
   echo "Info log:"
   [ -s "$infofile" ] && cat "$infofile" || echo  "No info logs"

   echo ""
   echo "Error log:"
   [ -s "$errorfile" ] && cat "$errorfile" || echo "No errors"
} | mail -s "Backup report for $target_name" "$recipient"
}

trap send_report EXIT

if [ -z "$target_name" ]; then
  echo "You not enter the directory name" | tee -a "$errorfile" 2>&1
  exit 1
fi

if [ ! -d "$target_name" ]; then
  echo "No such directory found: $target_name" | tee -a "$errorfile" 2>&1
  exit 1
fi

last_checksum=$(cat "$last_check" 2>/dev/null)

content_checksum=$(find "$target_name" -type f -exec md5sum {} + | sort | md5sum | awk '{print $1}')
structure_checksum=$(find "$target_name" -type d | sort | md5sum | awk '{print $1}')
current_checksum="$content_checksum-$structure_checksum"

if [ "$current_checksum" != "$last_checksum" ]; then

  safe_name=$(basename "$target_name")
  archive_name="archive_${safe_name}_$(date +%F_%H-%M).tar.gz"
  old_archives=$(find "$backup_dir" -type f -name "archive_${safe_name}_*.tar.gz")
if [ -n "$old_archives" ]; then
    echo "$(date +%F_%H-%M):INFO-removing old archive for $safe_name" | tee -a "$infofile"
    echo "$old_archives" | xargs -r rm -f
fi
    tar -czf "$backup_dir/$archive_name" -C "$(dirname "$target_name")" "$(basename "$target_name")"
    echo "$current_checksum" > "$last_check"
    echo "$(date +%F_%H-%M):SUCCESS- $target_name archived in $backup_dir/$archive_name" | tee -a "$logfile"
else
    echo "$(date +%F_%H-%M):INFO- No changes detected. Archive not created" | tee -a "$infofile"
fi

find "$backup_dir" -type f -name "*.tar.gz" -mtime +7 -print | while read f; do
   rm -f "$f"
   echo "$(date +%F_%H-%M):DELETED $f" | tee -a "$logfile"
done

}

smart_backup "$dir"
