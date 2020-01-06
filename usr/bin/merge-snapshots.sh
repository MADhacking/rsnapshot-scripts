#! /bin/bash

# If the source and destination directories exist then perform the merge
[ -d "/mnt/snapshots/$1/$2" ] && [ -d "/mnt/snapshots/$1/$3/" ] && \
    /bin/cp -al /mnt/snapshots/"$1"/"$2"/* /mnt/snapshots/"$1"/"$3"/

exit 0
