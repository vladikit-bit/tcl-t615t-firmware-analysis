#!/usr/bin/env sh

audio_log_open()
{
  rm "/data/AudioDECR2_9E0x16_8A0x0_880x0"*
  rm "/data/AudioSNDR2_9E0x8_8A0x10_880x0"*

  setenforce 0
  echo dump_r2_log_start=0 9E=0x16 PATH=1 8A=0x0 > /proc/utopia_mdb/audio
  echo dump_r2_log_start=1 9E=0x8 PATH=1 8A=0x10 > /proc/utopia_mdb/audio

  echo debug_level=4 > /proc/utopia_mdb/audio
  echo audio_status > /proc/utopia_mdb/audio
  echo spdif_mode > /proc/utopia_mdb/audio
  echo reg_bank=0x112C > /proc/utopia_mdb/audio
  echo reg_bank=0x112D > /proc/utopia_mdb/audio
  echo reg_bank=0x112E > /proc/utopia_mdb/audio
  echo reg_bank=0x1603 > /proc/utopia_mdb/audio
  
  echo dbg MI_AUDIO 0x40 > /sys/kernel/mik/MI_UTIL
  echo dbg MI_AOUT 0x40 > /sys/kernel/mik/MI_UTIL
  echo dbg MI_AEXTIN 0x40 > /sys/kernel/mik/MI_UTIL
}

audio_log_close()
{
  echo audio_status > /proc/utopia_mdb/audio
  echo spdif_mode > /proc/utopia_mdb/audio
  echo reg_bank=0x112C > /proc/utopia_mdb/audio
  echo reg_bank=0x112D > /proc/utopia_mdb/audio
  echo reg_bank=0x112E > /proc/utopia_mdb/audio
  echo reg_bank=0x1603 > /proc/utopia_mdb/audio
  
  echo dump_r2_log_stop=0 > /proc/utopia_mdb/audio
  echo dump_r2_log_stop=1 > /proc/utopia_mdb/audio

  #source "$AUTOLOG_HOME/utils/preprocess.sh"
  DEC_R2_LOG_FP="$(GenLogPath "AudioDECR2.log")"
  echo "DEC_R2_LOG_FP=$DEC_R2_LOG_FP"
  mv "/data/AudioDECR2_9E0x16_8A0x0_880x0"* $DEC_R2_LOG_FP

  SND_R2_LOG_FP="$(GenLogPath "AudioSNDR2.log")"
  echo "SND_R2_LOG_FP=$SND_R2_LOG_FP"
  mv "/data/AudioSNDR2_9E0x8_8A0x10_880x0"* $SND_R2_LOG_FP

  echo debug_level=1 > /proc/utopia_mdb/audio
  echo dbg MI_AUDIO 0x20 > /sys/kernel/mik/MI_UTIL
  echo dbg MI_AOUT 0x20 > /sys/kernel/mik/MI_UTIL
  echo dbg MI_AEXTIN 0x20 > /sys/kernel/mik/MI_UTIL
}
