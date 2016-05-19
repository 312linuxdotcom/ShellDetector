#!/bin/bash
#This is a simple script in order to detect full shell access on cpanel servers. They have been known to change this setting via updates.

#Whitelist - simply add the username in quotes below, use a pipe to delineate multiple users ex) whitelist="john|joe|jerry"
whitelist="nagios"

#Name of script
script=$0

#tmpfile
tmp=/root/shelldet.tmp

empty=65
#Grep out users that do not have normal shell access. Piped grep command removes UIDs below 500 since this is lowest UID a real user could ever obtain.
grep -vE $whitelist /etc/passwd |grep -vE "/bin/false|/bin/jailshell|/bin/noshell|nologin" | grep [5-9][0-9][0-9] >> $tmp

if [ ! -s $tmp ]
then
exit $empty
else
#add some basic info to our temp file that will be emailed later
echo >> $tmp
echo "`hostname` - `date`" >> $tmp; echo >> $tmp

echo "The above users have been detected as having full shell access. Please change the above accounts to jailshell access." >> $tmp
echo >> $tmp

echo "If you would like to allow a user normal shell, please add them to the whitelist field in this script: $script" >> $tmp

#Email execution and cleanup
mail -s "Normal Shell Detector `hostname`" support@312linux.com < $tmp
fi
 rm -f $tmp
