#!/usr/bin/env sh

audio_log_open()
{
  echo write_reg=0x112E8A=0x0804  > /proc/utopia_mdb/audio

  setenforce 0
  echo console_output audio_adec_r2=0x16 > /proc/utopia_mdb/audio
  echo console_output audio_asnd_r2=0x8 > /proc/utopia_mdb/audio

  echo debug_level=4 > /proc/utopia_mdb/audio
  echo audio_status > /proc/utopia_mdb/audio
  echo spdif_mode > /proc/utopia_mdb/audio
  echo reg_bank=0x112C > /proc/utopia_mdb/audio
  echo reg_bank=0x112D > /proc/utopia_mdb/audio
  echo reg_bank=0x112E > /proc/utopia_mdb/audio
  echo reg_bank=0x1603 > /proc/utopia_mdb/audio
  
  echo dbg MI_AUDIO 0x40 > /sys/kernel/mik/MI_UTIL
  echo dbg MI_AOUT 0x45 > /sys/kernel/mik/MI_UTIL
  echo dbg MI_AEXTIN 0x40 > /sys/kernel/mik/MI_UTIL
}

audio_log_close()
{
  echo audio_status > /proc/utopia_mdb/audio
  echo get Amp_Mute >  /sys/kernel/mik/MI_AOUT
  echo spdif_mode > /proc/utopia_mdb/audio
  echo reg_bank=0x112C > /proc/utopia_mdb/audio
  echo reg_bank=0x112D > /proc/utopia_mdb/audio
  echo reg_bank=0x112E > /proc/utopia_mdb/audio
  echo reg_bank=0x1603 > /proc/utopia_mdb/audio
}
