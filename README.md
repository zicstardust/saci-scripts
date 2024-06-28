# Install
```bash
curl https://raw.githubusercontent.com/zicstardust/saci-scripts/main/install.sh | bash
```

# Generate config files
```bash
/etc/systemd/backup-to-disks.sh gen-config-file
/etc/systemd/rclone-backup.sh gen-config-file
/etc/systemd/system-update.sh gen-config-file
```

# Enable

```bash
systemctl enable --now backup-to-disks.timer
systemctl enable --now rclone-backup.timer
systemctl enable --now system-update.timer
```

# Logs
```bash
journalctl -e -u backup-to-disks.service
journalctl -e -u rclone-backup.service
journalctl -e -u system-update.service
```
