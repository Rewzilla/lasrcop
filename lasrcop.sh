#!/bin/bash

# Main LASRCOP startup script.  Meant to be run by sshd
# upon user login. This script should be saved as
# `/usr/local/bin/lasrcop`. Alter config settings below
# as needed

# configuration
USERNAME=$(id -un)
TIMESTAMP=$(date '+%Y:%m:%d-%H:%M:%S')
SAVEDIR="/var/sessions/${USERNAME}"
SAVEFILE="${SAVEDIR}/${TIMESTAMP}.cast"
ALERT="\e[31;1m"
NORMAL="\e[0m"
CONSENTFILE=~/.consent


# if we're using SCP/SFTP or something, bail out here
if [[ $SSH_ORIGINAL_COMMAND ]]
then
	eval "$SSH_ORIGINAL_COMMAND"
	exit
fi


# ensure user directory exists
mkdir -p ${SAVEDIR}
chmod 700 ${SAVEDIR}


# show initial into
uname -a
cat /etc/motd
last -w ${USERNAME} \
	| head -n1 \
	| awk '{print "Last login: " $4 " " $5 " " $6 " " $7 " from " $3 " on " $2 }'


# maybe show notification and EULA
if [[ ! -f ${CONSENTFILE} ]]
then
	echo -e "${ALERT}"
	echo "NOTICE: All activity on this system is monitored and logged."
	echo "This server is intended for class purposes only. To continue,"
	echo "please reply 'yes' below to confirm that you consent to your"
	echo "activity being monitored while using this server."
	echo -e "${NORMAL}"
	read -p "Do you understand and agree? (yes/no): " RESPONSE
	if [[ $RESPONSE == "yes" ]]
	then
		touch ${CONSENTFILE}
	else
		exit
	fi
fi


# begin recording
asciinema rec -q -i 1 ${SAVEFILE}


# end and exit
exit
