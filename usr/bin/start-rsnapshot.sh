#! /bin/bash

# shellcheck disable=SC2034
[[ ${RSYNC_EXIT_STATUS} -eq 0 ]] && rsnapshot -c "/etc/rsnapshot/files.$1" push
