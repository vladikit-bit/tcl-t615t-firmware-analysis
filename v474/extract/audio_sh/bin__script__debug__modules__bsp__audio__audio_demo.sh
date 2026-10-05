#!/usr/bin/env sh
source "$AUTOLOG_HOME/utils/imports.sh"

ImportUtil "loggers.sh"
ImportUtil "colors.sh"
ImportUtil "sys.sh"


INIT_BSP_AUDIO_AUDIO()
{
  echo "Initialize BSP.AUDIO.AUDIO log configs..."
#  set -e

  SCENARIO_NUM="$1"

  echo debug_level=4 > /proc/utopia_mdb/audio

  # Open log by scenario number
  ### You can setup kinds of scenario here
  case "$SCENARIO_NUM" in
    "10101")
      # 10101 => Scenario A
      echo "IN 10101"
      echo dbg MI_AUDIO 0x40 > /sys/kernel/mik/MI_UTIL
      echo dbg MI_AOUT 0x40 > /sys/kernel/mik/MI_UTIL
      echo dbg MI_AEXTIN 0x40 > /sys/kernel/mik/MI_UTIL
      ;;
    "10201")
      # 10201 => Scenario B
      echo "IN 10201"
      echo dbg MI_AEXTIN 0x40 > /sys/kernel/mik/MI_UTIL
    ;;
    "10301")
      # 10301 => Scenario C
      echo "IN 10301"
      echo dbg MI_AOUT 0x40 > /sys/kernel/mik/MI_UTIL
    ;;
    "10401")
      # 10401 => Scenario D
      echo "IN 10401"
      echo dbg MI_AUDIO 0x40 > /sys/kernel/mik/MI_UTIL
    ;;
    *)

      echo "SCENARIO_NUM='$SCENARIO_NUM' is not defined in audio.sh, please check or contact related RD"
      return 1
    ;;
  esac

  #decoded output data:
  ##echo console_output audio_adec_r2=0x16 > /proc/utopia_mdb/audio
  #bypass data on ARC/eARC:
  ##echo console_output audio_adec_r2=0x32 > /proc/utopia_mdb/audio
  #encode data on ARC/eARC:
  ##echo console_output audio_asnd_r2=0xC > /proc/utopia_mdb/audio

#  set +e
  echo -e "Audio Init log Success!\n"
}


CLOSE_BSP_AUDIO_AUDIO()
{
#  set -e
  #Log Off
  ##decoder log off:
  ##echo console_output audio_adec_r2=0xFF > /proc/utopia_mdb/audio
  ##echo console_output audio_asnd_r2=0xFF > /proc/utopia_mdb/audio
  ##MI log off:
  echo dbg MI_AUDIO 0x0 > /sys/kernel/mik/MI_UTIL
  echo dbg MI_AOUT 0x0 > /sys/kernel/mik/MI_UTIL
  echo dbg MI_AEXTIN 0x0 > /sys/kernel/mik/MI_UTIL
  ##utopia log off:
  echo debug_level=0 > /proc/utopia_mdb/audio

#  set +e
  echo -e "Close Audio log Success!\n"
}


MAIN()
{
  version="v1.0"
  . "$AUTOLOG_HOME/utils/preprocess.sh"


  ### Arguments
  # $log_fp => output log file path
  # $act_log_fp => interactive log output file path
  module_arg1=$1
  module_arg2=$2
  module_arg3=$3

  ### log settings
  # back-up log level
  org_printk=$(cat /proc/sys/kernel/printk)
  # start kernel log
  echo 0 > /proc/sys/kernel/printk || echo -e "${COLOR_RED}Change printk error! Permission Denied${COLOR_REST}"
  dmesg --follow -r >> $LOG_FP &
  child_pid=$!

  #--------------------------------------
  #Need to open/key log before issue appears
  script_debug_mode=0

  echo -e "Wait for audio log initialization ...\n"

  if [ "$script_debug_mode" -gt 0 ]
  then
      echo "script debug mode: on"
    set -x
  fi

  # Open log
  INIT_BSP_AUDIO_AUDIO $SCENARIO_NUM

  #--------------------------------------
  #Reproduce issue and finishing record.
  echo -e "After issue appears, press enter to finishing recording!"
  if [ "$script_debug_mode" -gt 0 ]
  then
    set +x && read "abc" && set -x
  else
    read "abc"
  fi
  sleep 1s

  echo audio_status > /proc/utopia_mdb/audio
  echo spdif_mode > /proc/utopia_mdb/audio
  echo reg_bank=0x112C > /proc/utopia_mdb/audio
  echo reg_bank=0x112D > /proc/utopia_mdb/audio
  echo reg_bank=0x112E > /proc/utopia_mdb/audio
  echo reg_bank=0x1603 > /proc/utopia_mdb/audio
  sleep 1s

  # Close log
  CLOSE_BSP_AUDIO_AUDIO


  ### log settings
  # re-cover log level
  echo $org_printk > /proc/sys/kernel/printk || echo -e "${COLOR_RED}Change printk error! Permission Denied${COLOR_REST}"

  # stop dmesg running in background jobs
  kill -9 $child_pid
  sync
  sync
}


if [ "$*" = "--source-only" ]; then
  :
else
  MAIN $*
fi
