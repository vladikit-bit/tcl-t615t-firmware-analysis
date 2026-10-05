#!/bin/sh
version="v2.0"

# Import function: write_interactive()
root_dir="$(dirname $(dirname $(dirname $0)))"
source "$root_dir/utils/colors.sh"
source "$root_dir/utils/loggers.sh"
source "$root_dir/utils/arguments.sh"

### Arguments
# $log_fp => output log file path
# $act_log_fp => interactive log output file path
echo "timestamp=`date +"%Y-%m-%d %H:%M:%S"`,script_version=$version" >> $log_fp
module_arg1=$1
module_arg2=$2
module_arg3=$3


### log settings
# back-up log level
org_printk=$(cat /proc/sys/kernel/printk)
# close log
echo 0 > /proc/sys/kernel/printk || echo -e "${COLOR_RED}Change printk error! Permission Denied${COLOR_REST}"
dmesg --follow -r >> $log_fp &
child_pid=$!

# ---------------------------- End of common init part ----------------------------

# init param
script_debug_mode=$module_arg1
dec_r2_op=$module_arg2
# inner function
function dump_audio_status()
{
	echo audio_status > /proc/utopia_mdb/audio
	echo spdif_mode > /proc/utopia_mdb/audio
	echo reg_bank=0x112C > /proc/utopia_mdb/audio
	echo reg_bank=0x112D > /proc/utopia_mdb/audio
	echo reg_bank=0x112E > /proc/utopia_mdb/audio
	echo reg_bank=0x1603 > /proc/utopia_mdb/audio
	sleep 1s
}

function start_dec_r2_log()
{
	echo dec_r2_cmd=1 > /proc/utopia_mdb/audio
	echo r2_log_file_path=1 > /proc/utopia_mdb/audio
	echo r2_log_dbg_option=0x$1 > /proc/utopia_mdb/audio
	echo r2_log_interval=40 > /proc/utopia_mdb/audio
	echo start_dump_r2_log > /proc/utopia_mdb/audio
}

function stop_dec_r2_log()
{
	echo stop_dump_r2_log > /proc/utopia_mdb/audio
}

function save_dec_r2_log()
{
	mv /data/AudioR2_0x$1.log /$log_dir/$log_ts-AudioR2_0x$1.log
}

function log_on()
{
	#utopia log on:
	echo debug_level=4 > /proc/utopia_mdb/audio
	#MI log on:
	echo dbg MI_AUDIO 0x40 > /sys/kernel/mik/MI_UTIL
	echo dbg MI_AOUT 0x40 > /sys/kernel/mik/MI_UTIL
	echo dbg MI_AEXTIN 0x40 > /sys/kernel/mik/MI_UTIL 
}

function log_off()
{
	echo debug_level=0 > /proc/utopia_mdb/audio
	echo dbg MI_AUDIO 0x00 > /sys/kernel/mik/MI_UTIL
	echo dbg MI_AOUT 0x00 > /sys/kernel/mik/MI_UTIL
	echo dbg MI_AEXTIN 0x00 > /sys/kernel/mik/MI_UTIL 
}

function debug_mode_on()
{
    echo "script debug mode: on"
	set -x
}

function debug_mode_off()
{
    echo "script debug mode: off"
	set +x
}

function init()
{
	echo "script version: $version !\n"
	echo -e "Wait for audio log initialization ...\n"

	if [ "$script_debug_mode" -gt 0 ]
	then
		debug_mode_on
	fi

	dump_audio_status
	start_dec_r2_log $dec_r2_op
	log_on
	echo -e "Audio log initialization is Success!\n"
}

function leave()
{
	sleep 1s
	log_off
	dump_audio_status
	stop_dec_r2_log
	save_dec_r2_log $dec_r2_op
	sleep 1s
}

# before issue appears
init
# ... Reproduce issue and finishing record.
debug_mode_off
echo -e "!!! After audio issue appears, press [enter] to finishing recording !!!"
read "abc"

if [ "$script_debug_mode" -gt 0 ]
then
	debug_mode_on
fi

leave

# ---------------------------- Leaving of common part ----------------------------
### log settings
# re-conver log level
echo $org_printk > /proc/sys/kernel/printk || echo -e "${COLOR_RED}Change printk error! Permission Denied${COLOR_REST}"

# stop dmesg running in background jobs
kill -9 $child_pid
sync
sync

# double check
dmesg_pids=`ps -ef | grep "dmesg --follow" | grep -v grep | awk '{print $2}'`
if [ "$dmesg_pids" != "" ]; then
  kill -9 $dmesg_pids
  sync
  sync
fi

