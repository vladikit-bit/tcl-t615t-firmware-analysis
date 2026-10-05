#!/bin/sh
set -x

# Import function: write_interactive()
root_dir="$(dirname $(dirname $(dirname $0)))"
source "$root_dir/utils/loggers.sh"
source "$root_dir/utils/arguments.sh"

module_arg1=$1
module_arg2=$2
module_arg3=$3

#--------------------------------------
#Need to open/key log before issue appears
echo dbg MI_AUDIO 0x40 > /sys/kernel/mik/MI_UTIL
echo dbg MI_AOUT 0x40 > /sys/kernel/mik/MI_UTIL
echo dbg MI_AEXTIN 0x40 > /sys/kernel/mik/MI_UTIL

#--------------------------------------
#Reproduce issue and finishing record.
sleep 1s
echo -e "Init log, Success!\n"
echo -e "After issue appears, press enter to finishing recording!"
set +x
read "abc"
set -x
sleep 5s

echo audio_status > /proc/utopia_mdb/audio
echo spdif_mode > /proc/utopia_mdb/audio

echo reg_bank=0x112C > /proc/utopia_mdb/audio
echo reg_bank=0x112D > /proc/utopia_mdb/audio
echo reg_bank=0x112E > /proc/utopia_mdb/audio
echo reg_bank=0x1603 > /proc/utopia_mdb/audio

