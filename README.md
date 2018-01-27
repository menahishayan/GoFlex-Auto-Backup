# Seagate GoFlex - Automated Backup Script
Script to automatically schedule backups from a Seagate GoFlex device to an external device (USB)

## Introduction
Automatically creates regular update-based backup of all data on HDD (SATA: /dev/sda1) to WD (USB: /dev/sdb2)

### Includes:
- GoFlex Home Public
- <user>/GoFlex Home Personal
- <user>/GoFlex Home Backup
(For all users)

### NOTE:
1. Deletes files that have been deleted on HDD
2. No file history or incremental backups
1. Backup includes this script package and all contents of (/script)
1. No RAID/Backup/diag etc, drive marking or flagging. Backup drive is passive and treated as regular storage.
1. Exclude option provided to exclude files/folders from backup
1. Backup volume must be NTFS on MBR or GPT

### !!!WARNING:
IN CASE OF DATA LOSS ON HDD, SCRIPT WILL ERASE THE SAME DATA ON BACKUP DRIVE.
Delete script or unplug backup drive in case of data loss.

## USAGE
executed automatically by root as per specified schedule in /etc/crontab

## LOGGING:

Logs are created automatically and stored at '/home/0common/scripts/logs/'
A new logfile is created for each backup session.
Minimal verbosity. Contains only timestamps of overview actions and console errors (if any)

## BACKUP DIRECTORY STRUCTURE:
`code`
..$DRIVE/GoFlex Home Public
..$DRIVE/GoFlex Home Personal
<USER1>
<USER2>
.
.
<USER*>
..$DRIVE/GoFlex Home Backup
<USER1>
<USER2>
.
.
<USER*>
`code`
## EXCLUDE LIST:

List of files to be excluded from backup process.
Global list for 'GoFlex Home Public': '/home/0common/scripts/exclude.txt'

User specific lists for 'GoFlex Home Personal' & 'GoFlex Home Backup':
'/home/0common/scripts/<user>/exclude-personal.txt'
'/home/0common/scripts/<user>/exclude-backup.txt'

### USAGE:
Enter the file/folder name to be excluded (short path), one in each line, followed by return key

Example:
1. To exclude '/GoFlex Home Public/Movies' from backup
"Movies" >> '/home/0common/scripts/exclude.txt'
2. To exclude GoFlex Home Public/Movies/Princess Diaries/P DIARIES.avi
"Movies/Princess Diaries/P DIARIES.avi" >> '/home/0common/scripts/exclude.txt'

### NOTE:
1. Script automatically detects the usernames and accesses exclude lists even if users are added/modified/removed.
2. Creation of folders '/home/0common/scripts/<user>' is not automated. Any changes to user metadata must be reflected manually in '//GoFlex Home Public/scripts/'
1. In case user is deleted, script does not clear user data from backup drive
1. Non-existent exclude items will be ignored

### UPDATING EXCLUDE LIST:
Simply edit the contents of the respective exclude list without having to change any other file related to the backup process

### WARNING: 
Do not edit exclude list while backup is in progress. Check log file for information on backups.

## UPDATES:
To update the shell script, simply modify the script located at '/home/0common/scripts/backup.sh'

### !!!WARNING: DO NOT ALLOW EXECUTION WITHOUT CROSS-CHECKING SCRIPT. MAY RESULT IN DATA LOSS OR CORRUPTION.
Preferably create a copy of the script in a sandbox Live Ubuntu environment and execute with test data. Verify outputs, debug errors, and only after all exceptions are handled, proceed to overwrite the script.

### NOTE:
Keep in mind the time of editing and the time of execution to avoid pre-mature execution and data loss

### WARNING:
Do not edit the script while backup is in progress. May result in corruption of destination files

## PROCEDURE TO CHANGE SCHEDULING:

```bash
ssh shayan_hipserv2_seagateplug_PGRV-VVFE-DAUF-FQPC@192.168.0.7
shayan123
sudo -S
shayan123
vi /etc/crontab
i #(insert text)
#00 13 * * * root /bin/bash /home/0common/scripts/backup.sh (runs everyday at 13:00)
#To save - <Esc> <colon>  wq <Return>
```

### NOTE:
crontab Syntax:
<dl>
  <dd>
*     *     *   *    *        command to be executed
-     -     -   -    -
|     |     |   |    |
|     |     |   |    +----- day of week (0 - 6) (Sunday=0)
|     |     |   +------- month (1 - 12)
|     |     +--------- day of        month (1 - 31)
|     +----------- hour (0 - 23)
+------------- min (0 - 59)
  </dd>
</dl>
----------------
Help documentation written by Menahi Shayan.
Last Updated: 2018-01-05 23:39 (GMT+05:30)
