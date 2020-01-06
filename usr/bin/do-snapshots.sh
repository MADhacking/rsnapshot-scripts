#! /bin/bash

# Set default configuration values
SNAPSHOT_WEEKLY_DAY=6
DO_MONTHLY=false
DO_WEEKLY=false

# Get the current day of the week and day of the month
DAY_OF_THE_WEEK=$(date +%u)
DAY_OF_THE_MONTH=$(date +%d)

# Print available disk space in snapshot directories.
echo -e "Disk space remaining before snapshots:\n"
df -h /mnt/snapshots/*
echo

# Allow "weekly" or "monthly" to be specified on the command line.
if [[ "$1" = "weekly" ]]; then
	DO_WEEKLY=true
fi
if [[ "$1" = "monthly" ]]; then
	DO_WEEKLY=true
	DO_MONTHLY=true
fi

# Set DO_WEEKLY and DO_MONTHLY variables appropriately.
if [[ "$DAY_OF_THE_WEEK" -eq "$SNAPSHOT_WEEKLY_DAY" ]]; then
	DO_WEEKLY=true
fi
if $DO_WEEKLY && (( DAY_OF_THE_MONTH <= 7 )); then
	DO_MONTHLY=true
fi

# Perform monthly snapshot if required.
if $DO_MONTHLY ; then
	echo -e "\nPerforming monthly snapshots:"
	awk '/^retain.+monthly/ { print FILENAME }' /etc/rsnapshot/*.* | \
		xargs -r -n 1 -I{} bash -c "echo '    {}' && rsnapshot -c {} monthly"
fi

# Perform weekly snapshot if required.
if $DO_WEEKLY ; then
	echo -e "\nPerforming weekly snapshots:"
	awk '/^retain.+weekly/ { print FILENAME }' /etc/rsnapshot/*.* | \
		xargs -r -n 1 -I{} bash -c "echo '    {}' && rsnapshot -c {} weekly"
fi

# Perform daily snapshot.
echo -e "\nPerforming daily snapshots:"
awk '/^retain.+daily/ { print FILENAME }' /etc/rsnapshot/*.* | \
	xargs -r -n 1 -I{} bash -c "echo '    {}' && rsnapshot -c {} daily"

# Print available disk space in snapshot directories.
echo -e "\n\nDisk space remaining after snapshots:\n"
df -h /mnt/snapshots/*
