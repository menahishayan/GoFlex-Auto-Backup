#!/bin/bash

# vi /etc/crontab
# i
# 00 13 * * * root /bin/bash /home/shares/public/scripts/backup2.sh
#  (runs everyday at 13:00)
# To save - <Esc> colon  wq <Return>.

# Sort out the logging
FILEDATE=`date +"%Y-%m-%d"`
`mkdir -p /home/shares/public/scripts/logs`
LOGFILE=/home/shares/public/scripts/logs/backup.$FILEDATE.log
touch $LOGFILE

log() {
    echo -e "$(date +"%Y-%m-%d %T") $*" >> $LOGFILE
}

`umount /dev/sdb1`
`mount -t ntfs-3g /dev/sdb1 /media/USB`

DRIVE=USB

log "GoFlex Home Backup Process Start"

log "Saving Backup to $DRIVE"

EXTERNAL=/media/$DRIVE

# Check if drive properly mounted
if [ -d "$EXTERNAL" ]; then

    SECONDS=0

    log "Public Start"
    `mkdir -p $EXTERNAL/public >> $LOGFILE 2>&1`
    `rsync -cugloprt /home/shares/public/* $EXTERNAL/public --delete --exclude-from='/home/shares/public/scripts/exclude.txt' >> $LOGFILE 2>&1`
    log "Public End"

    # Backup user personal and backup directories to External Storage drive
    log "Personal Start"
    `mkdir -p $EXTERNAL/shayan >> $LOGFILE 2>&1`
   `rsync -cugloprt /home/shayan/* $EXTERNAL/shayan --delete --exclude-from=/home/shares/public/scripts/shayan/exclude-personal.txt >> $LOGFILE 2>&1`
    log "Personal End"

    log "GoFlex Home Backup Process End"

    duration=$SECONDS
    log "Time Elapsed $(($duration / 3600)):$(($duration % 3600 / 60)):$(($duration % 60))"

    `umount /dev/sdb1`

else
        log "External Storage not mounted - $DRIVE\n"
fi
