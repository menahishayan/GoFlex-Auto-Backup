#!/bin/bash
if [ "$1" == "on" ]; then
    /usr/bin/set-led-status usb usb_blink > /dev/null 2>&1
    /usr/bin/oe-visual-indicator bootup-start > /dev/null 2>&1
    /usr/bin/set-led-status hd0 hdd_blink
    /usr/bin/set-led-status hd1 hdd_blink
fi

if [ $1 == "off" ]; then
    /usr/bin/set-led-status usb usb_off > /dev/null 2>&1
    /usr/bin/oe-visual-indicator bootup-finish > /dev/null 2>&1
    /usr/bin/set-led-status hdd0 hdd_blink_off
    /usr/bin/set-led-status hdd1 hdd_blink_off
    /usr/bin/set-led-status hdd hdd_off
fi
#bash-3.2# vi GoFlex\ Home\ Public/backup.sh
#bash-3.2# cat GoFlex\ Home\ Public/backup.sh
﻿#!/bin/bash

# GoFlex Home Users & Public Folder backup script
# to set this to run
# Connect with SSH and become root with "sudo -s"
# Edit /etc/crontab "vi /etc/crontab"
# add a line with "i"
# 00 13 * * * root /bin/bash /home/0common/scripts/backup.sh
#  (runs everyday at 13:00)
# To save - <Esc> colon  wq <Return>.

# Sort out the logging
FILEDATE=`date +"%Y-%m-%d"`
`mkdir -p /home/0common/scripts/logs`
LOGFILE=/home/0common/scripts/logs/backup.$FILEDATE.log
touch $LOGFILE

log() {
    echo -e "$(date +"%Y-%m-%d %T") $*" >> $LOGFILE
}

USERCOUNT=0
EXTERNAL=/home/0external/
DRIVE=WD

log "GoFlex Home Backup Process Start"

# Check what External drive is mounted (I am only expecting one)
#for DRIVE in $( ls $EXTERNAL ); do
        log "Saving Backup to $DRIVE"
#        break
#done

EXTERNAL=/home/0external/$DRIVE

# Check if drive properly mounted
if [ -d "$EXTERNAL" ]; then

        # Look for user directories in /home and then backup
        for d in $( ls /home/ ); do
                firstletter=${d:0:1}

                if [ "$firstletter" != "0" ]; then

                        # Backup GoFlex Home Public, but only for first user
                        if [ "$USERCOUNT" == "0" ]; then
                                log "Public Start"
                                `mkdir -p /home/$d/"External Storage"/$DRIVE/"GoFlex Home Public" >> $LOGFILE 2>&1`
                                `rsync -cugloprt /home/$d/"GoFlex Home Public"/* /home/$d/"External Storage"/$DRIVE/"GoFlex Home Public" --delete --exclude-from='/home/0common/scripts/exclude.txt' >> $LOGFILE 2>&1`

                                log "Public End"

                                let USERCOUNT++
                        fi

                        # Backup user personal and backup directories to External Storage drive
                        log "Personal Start - $d"
                        `mkdir -p /home/$d/"External Storage"/$DRIVE/"GoFlex Home Personal"/$d >> $LOGFILE 2>&1`
                        `rsync -cugloprt /home/$d/"GoFlex Home Personal"/* /home/$d/"External Storage"/$DRIVE/"GoFlex Home Personal"/$d --delete --exclude-from=/home/0common/scripts/$d/exclude-personal.txt >> $LOGFILE 2>&1`
                        log "Personal End - $d"

                        log "Backup Start - $d"
                        `mkdir -p /home/$d/"External Storage"/$DRIVE/"GoFlex Home Backup"/$d >> $LOGFILE 2>&1`
                        `rsync -cugloprt /home/$d/"GoFlex Home Backup"/* /home/$d/"External Storage"/$DRIVE/"GoFlex Home Backup"/$d --delete --exclude-from=/home/0common/scripts/$d/exclude-backup.txt >> $LOGFILE 2>&1`
                        log "Backup End - $d"

                fi
        done
        log "GoFlex Home Backup Process End\n"

else
        log "External Storage not mounted - $DRIVE\n"
fi
