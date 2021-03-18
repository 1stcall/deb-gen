#!/usr/bin/env bash
set -e
export LOGPREFIX="[${0}]"
export BLKDEV=${BLKDEV:-/dev/sdb}

STARTBUILD=$(date +%s)
BUILDONLY=${BUILDONLY:-false}
SKIPWRITE=${SKIPWRITE:-false}
SKIPCLEAN=${SKIPCLEAN:-false}
BLKDEV=${BLKDEV:-${1}}

RESTORE=$(echo -en '\033[0m')
RED=$(echo -en '\033[00;31m')
GREEN=$(echo -en '\033[00;32m')
YELLOW=$(echo -en '\033[00;33m')
BLUE=$(echo -en '\033[00;34m')
MAGENTA=$(echo -en '\033[00;35m')
PURPLE=$(echo -en '\033[00;35m')
CYAN=$(echo -en '\033[00;36m')
LIGHTGRAY=$(echo -en '\033[00;37m')
LRED=$(echo -en '\033[01;31m')
LGREEN=$(echo -en '\033[01;32m')
LYELLOW=$(echo -en '\033[01;33m')
LBLUE=$(echo -en '\033[01;34m')
LMAGENTA=$(echo -en '\033[01;35m')
LPURPLE=$(echo -en '\033[01;35m')
LCYAN=$(echo -en '\033[01;36m')
WHITE=$(echo -en '\033[01;37m')

filename=$(basename -- "${0}")
extension="${filename##*.}"
filename="${filename%.*}"
logname="${filename}.log"
outname="${filename}.out"

source ./common.sh

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1> >(debug) #2>&1

if [[ ${BUILDONLY} != true ]]; then
    STARTSEC=$(date +%s)
    LOGPREFIX="000-bootstrap.sh" doCommand "./000-bootstrap.sh"
    log "000-bootstrap completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
    STARTSEC=$(date +%s)
    LOGPREFIX="010-installfiles.sh" doCommand "./010-installfiles.sh"
    log "010-installfiles completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
    STARTSEC=$(date +%s)
    log "Installing apps"
    LOGPREFIX="020-installapps1.sh" doCommand "./020-installapps1.sh"
#    mv ./rootfs/root/r00-installapps1.log .
    log "020-installapps1.sh completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
    STARTSEC=$(date +%s)
    log "Configuring rescuefs"
    LOGPREFIX="030-configurerescue.sh" doCommand "./030-configurerescue.sh"
    log "030-configurerescue.sh completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
#    mv ./rootfs/root/r10-configrescue.log .
    STARTSEC=$(date +%s)
    LOGPREFIX="040-makerescue.sh" doCommand "./040-makerescue.sh"
    log "040-makerescue.sh completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
    STARTSEC=$(date +%s)
    LOGPREFIX="050-configureroot.sh" doCommand "./050-configureroot.sh"
    log "050-configureroot.sh completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
    STARTSEC=$(date +%s)
    log "Installing apps"
    LOGPREFIX="060-installapps2.sh" doCommand "./060-installapps2.sh"
#    mv ./rootfs/root/r20-installapps2.log .
    log "060-installapps2.sh completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
    STARTSEC=$(date +%s)
    LOGPREFIX="070-makeboot.sh" doCommand "./070-makeboot.sh"
    log "070-makeboot.sh completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
fi
STARTSEC=$(date +%s)
LOGPREFIX="080-buildimg.sh" doCommand "./080-buildimg.sh"
log "080-buildimg completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
STARTSEC=$(date +%s)
#LOGPREFIX="090-cleanup.sh" doCommand "./090-cleanup.sh &"
#log "090-cleanup completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
log "090-cleanup SKIPPED"
if [[ ${SKIPWRITE} != true ]]; then
    STARTSEC=$(date +%s)
    LOGPREFIX="100-writeimg.sh" doCommand "./100-writeimg.sh"
    log "100-writeimg completed in $(displaytime $(( $(date +%s) - $STARTSEC )))"
else
    log "100-writeimg SKIPPED"
fi
log "Completed in $(displaytime $(( $(date +%s) - $STARTBUILD )))"
