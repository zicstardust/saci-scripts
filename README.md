# Exemple

```bash
systemctl enable --now backup-to-disks@'*-*-* 01:00:00'.timer
systemctl enable --now rclone-backup@'*-*-* 04:00:00'.timer
systemctl enable --now delete-old-logs@'*-*-* 01:00:00'.timer
systemctl enable --now system-update@'Sun *-*-* 00:06:00'.timer
```
