# 🗂️ Smart Backup (smart_backup)

A simple Bash script for automated backups with checksum verification.  
It archives the selected directory only if changes are detected since the last backup. All actions are logged.

---

## 🚀 Installation & Usage

1. Clone the repository:
   ```bash
   git clone git@github.com:AndKoch-dev/smart_backup.git
   cd smart_backup
   ```

2. Make the script executable:
   ```bash
   chmod +x smart_backup.sh
   ```

3. Run the script:
   ```bash
   ./smart_backup.sh
   ```

The script will ask for the directory you want to back up.

---

## 📂 Backup location

- Backups are saved in:
  ```
  ~/backup_test
  ```

- Archive naming format:
  ```
  backup_<folder_name>_YYYY-MM-DD_HH-MM.tar.gz
  ```

- Logs are stored in:
  ```
  ~/backup_test/backup.log
  ```

- Last checksum is stored in:
  ```
  ~/backup_test/.last_checksum
  ```

---

## 🛠 Example

```bash
➜ ./smart_backup.sh
Enter directory you want to archive: ~/Documents
```

Log output if changes are detected:
```
2025-08-18 11:34: files from /home/user/Documents archived to /home/user/backup_test/backup_Documents_2025-08-18_11-34.tar.gz
```

If no changes:
```
2025-08-18 11:36: no changes detected in /home/user/Documents
```

---

## ⏰ Automation with cron

You can schedule automatic backups using cron.  
For example, run every day at 3 AM:

```bash
0 3 * * * /home/username/smart_backup/smart_backup.sh >> ~/backup_test/backup.log 2>&1
```

---

## 📌 Roadmap
- Auto-remove backups older than 7 days  
- Support multiple archive formats (tar.gz / zip)  
- Email notifications on errors  

---

✍️ Author: [AndKoch-dev](https://github.com/AndKoch-dev)
