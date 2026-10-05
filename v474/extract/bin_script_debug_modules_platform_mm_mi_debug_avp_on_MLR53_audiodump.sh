#! /bin/sh

if [ -f "/config/MM/mm_cfg.ini" ]; then
    #for linux world
    if [ -f "/vendor/tvconfig/config/MM/mm_cfg.ini" ]; then
    #for apollo linux world
        mount -o remount,rw /vendor/tvconfig/config/
        echo "File /config/MM/mm_cfg.ini exists. ==> LINUX"
        MM_CFG_PATH="/vendor/tvconfig/config/MM/mm_cfg.ini"
        BACKUP_MM_CFG_PATH="/vendor/tvconfig/config/MM/mm_cfg_backup.ini"

        cp $MM_CFG_PATH $BACKUP_MM_CFG_PATH

        if [ -z "$1" ]
        then
            FILE_DIR="/mnt/usb/sda1"
            echo "MMDBG LOG will write to $FILE_DIR"
            FILE_DIR=$(echo $FILE_DIR |sed -e 's/\//\\\//g')
        else
            echo "MMDBG LOG will write to $1"
            FILE_DIR=$(echo $1 |sed -e 's/\//\\\//g')
        fi
    else
    #for pure mi
        mount -o remount,rw /config/
        echo "File /config/MM/mm_cfg.ini exists. ==> LINUX pure mi"
        MM_CFG_PATH="/config/MM/mm_cfg.ini"
        BACKUP_MM_CFG_PATH="/config/MM/mm_cfg_backup.ini"

        cp $MM_CFG_PATH $BACKUP_MM_CFG_PATH

        #define ms_mm_usb_path = /mnt/
        grep -q '^ms_mm_usb_path' $BACKUP_MM_CFG_PATH \
        && sed -i '/^ms_mm_usb_path =/s/=.*/= \/mnt\//g' $BACKUP_MM_CFG_PATH \
        || sed -i '/ms_mm_log_to_file/a ms_mm_usb_path = \/mnt\/' $BACKUP_MM_CFG_PATH

        if [ -z "$1" ]
        then
            FILE_DIR="/mnt/sda1"
            echo "MMDBG LOG will write to $FILE_DIR"
            FILE_DIR=$(echo $FILE_DIR |sed -e 's/\//\\\//g')
        else
            echo "MMDBG LOG will write to $1"
            FILE_DIR=$(echo $1 |sed -e 's/\//\\\//g')
        fi

    fi

    grep -q '^ms_mm_usb_auto' $BACKUP_MM_CFG_PATH \
    && sed -i '/^ms_mm_usb_auto =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
    || sed -i '/ms_mm_log_to_file/a ms_mm_usb_auto = 1' $BACKUP_MM_CFG_PATH

else
    #for AN world
    mount -o remount,rw /vendor/tvconfig
    echo "File /config/MM/mm_cfg.ini does not exists. ==> AN"
    MM_CFG_PATH="/vendor/tvconfig/config/MM/mm_cfg.ini"
    BACKUP_MM_CFG_PATH="/vendor/tvconfig/config/MM/mm_cfg_backup.ini"

    cp $MM_CFG_PATH $BACKUP_MM_CFG_PATH

    if [ -z "$1" ]
    then
        FILE_DIR="/data/vendor"
        echo "MMDBG LOG will write to $FILE_DIR"
        FILE_DIR=$(echo $FILE_DIR |sed -e 's/\//\\\//g')
    else
        echo "MMDBG LOG will write to $1"
        FILE_DIR=$(echo $1 |sed -e 's/\//\\\//g')
    fi

    grep -q '^ms_mm_usb_auto' $BACKUP_MM_CFG_PATH \
    && sed -i '/^ms_mm_usb_auto =/s/=.*/= 0/g' $BACKUP_MM_CFG_PATH \
    || sed -i '/ms_mm_log_to_file/a ms_mm_usb_auto = 0' $BACKUP_MM_CFG_PATH
fi

if [ -z "$2" ]
then
        FOLDER_DIR=""
        echo "FOLDER_DIR = $FOLDER_DIR"

else
        echo "FOLDER_DIR = $2"
        FOLDER_DIR=$(echo $2 |sed -e 's/\//\\\//g')
fi

sed -i '/^ms_mm_log_to_file =/s/=.*/= 0/g' $BACKUP_MM_CFG_PATH

grep -q '^ms_mm_log_to_ram' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms_mm_log_to_ram =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms_mm_log_to_ram = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms_mm_log_to_ram_size' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms_mm_log_to_ram_size =/s/=.*/= 0/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms_mm_log_to_ram_size = 0' $BACKUP_MM_CFG_PATH

#grep -q '^ms_mm_log_dir' $BACKUP_MM_CFG_PATH \
#&& sed -i '/^ms_mm_log_dir =/s/=.*/= \/mnt\/usb\/sda1/g' $BACKUP_MM_CFG_PATH \
#|| sed -i '/ms_mm_log_to_file/a ms_mm_log_dir = \/mnt\/usb\/sda1' $BACKUP_MM_CFG_PATH

grep -q '^ms_mm_log_dir' $BACKUP_MM_CFG_PATH \
&& sed -i "/^ms_mm_log_dir =/s/=.*/= ${FILE_DIR}/g" $BACKUP_MM_CFG_PATH \
|| sed -i "/ms_mm_log_to_file/a ms_mm_log_dir = ${FILE_DIR}" $BACKUP_MM_CFG_PATH

grep -q '^ms_mm_usb_folder_dir' $BACKUP_MM_CFG_PATH \
&& sed -i "/^ms_mm_usb_folder_dir =/s/=.*/= ${FOLDER_DIR}/g" $BACKUP_MM_CFG_PATH \
|| sed -i "/ms_mm_log_to_file/a ms_mm_usb_folder_dir = ${FOLDER_DIR}" $BACKUP_MM_CFG_PATH

grep -q '^ms_vdec_log' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms_vdec_log =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms_vdec_log = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms_omx_log' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms_omx_log =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms_omx_log = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms_msvdec_log' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms_msvdec_log =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms_msvdec_log = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms.vsync_bridge.log' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.vsync_bridge.log =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.vsync_bridge.log = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms.mstplayer.omx' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.mstplayer.omx =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.mstplayer.omx = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms.avp.disable.debug.log' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.avp.disable.debug.log =/s/=.*/= 0/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.avp.disable.debug.log = 0' $BACKUP_MM_CFG_PATH

grep -q '^ms.avp.disable.vo.log' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.avp.disable.vo.log =/s/=.*/= 0/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.avp.disable.vo.log = 0' $BACKUP_MM_CFG_PATH

grep -q '^ms.avp.debug.demuxer' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.avp.debug.demuxer =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.avp.debug.demuxer = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms_mm_disable_all_log' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms_mm_disable_all_log =/s/=.*/= 0/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms_mm_disable_all_log = 0' $BACKUP_MM_CFG_PATH

grep -q '^ms.mstplayer.debug.mmsdk.io' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.mstplayer.debug.mmsdk.io =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.mstplayer.debug.mmsdk.io = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms.mstplayer.debug.mmsdk.io.md5' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.mstplayer.debug.mmsdk.io.md5 =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.mstplayer.debug.mmsdk.io.md5 = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms.mstplayer.enable.push.es.log' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.mstplayer.enable.push.es.log =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.mstplayer.enable.push.es.log = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms.mstplayer.msg.debug.mode' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.mstplayer.msg.debug.mode =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.mstplayer.msg.debug.mode = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms.avp.debug.clock' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.avp.debug.clock =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.avp.debug.clock = 1' $BACKUP_MM_CFG_PATH

grep -q '^ms.adec.log_on' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.adec.log_on =/s/=.*/= 99/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.adec.log_on = 99' $BACKUP_MM_CFG_PATH

grep -q '^ms.arnd.log_on' $BACKUP_MM_CFG_PATH \
&& sed -i '/^ms.arnd.log_on =/s/=.*/= 1/g' $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a ms.arnd.log_on = 1' $BACKUP_MM_CFG_PATH

#Dump audio
grep -q '^mstar.media.adec.dump_es'  $BACKUP_MM_CFG_PATH \
&& sed -i '/^mstar.media.adec.dump_es =/s/=.*/= 1/g'  $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a mstar.media.adec.dump_es = 1'  $BACKUP_MM_CFG_PATH

grep -q '^mstar.media.adec.dump_es_dir'  $BACKUP_MM_CFG_PATH \
&& sed -i "/^mstar.media.adec.dump_es_dir =/s/=.*/= ${FILE_DIR}\/adec_es_dump/g"  $BACKUP_MM_CFG_PATH \
|| sed -i "/ms_mm_log_to_file/a mstar.media.adec.dump_es_dir = ${FILE_DIR}\/adec_es_dump" $BACKUP_MM_CFG_PATH


grep -q '^mstar.media.adec.dump_pcm'  $BACKUP_MM_CFG_PATH \
&& sed -i '/^mstar.media.adec.dump_pcm =/s/=.*/= 1/g'  $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a mstar.media.adec.dump_pcm = 1'  $BACKUP_MM_CFG_PATH

grep -q '^mstar.media.adec.dump_pcm_dir'  $BACKUP_MM_CFG_PATH \
&& sed -i "/^mstar.media.adec.dump_pcm_dir =/s/=.*/= ${FILE_DIR}\/adec_pcm_dump/g"  $BACKUP_MM_CFG_PATH \
|| sed -i "/ms_mm_log_to_file/a mstar.media.adec.dump_pcm_dir = ${FILE_DIR}\/adec_pcm_dump"  $BACKUP_MM_CFG_PATH

grep -q '^mstar.media.arnd.dump_pcm'  $BACKUP_MM_CFG_PATH \
&& sed -i '/^mstar.media.arnd.dump_pcm =/s/=.*/= 1/g'  $BACKUP_MM_CFG_PATH \
|| sed -i '/ms_mm_log_to_file/a mstar.media.arnd.dump_pcm = 1'  $BACKUP_MM_CFG_PATH

grep -q '^mstar.media.arnd.dump_pcm_dir'  $BACKUP_MM_CFG_PATH \
&& sed -i "/^mstar.media.arnd.dump_pcm_dir =/s/=.*/= ${FILE_DIR}\/render_pcm_dump/g"  $BACKUP_MM_CFG_PATH \
|| sed -i "/ms_mm_log_to_file/a mstar.media.arnd.dump_pcm_dir = ${FILE_DIR}\/render_pcm_dump" $BACKUP_MM_CFG_PATH
#End of dump

sync

cp $BACKUP_MM_CFG_PATH $MM_CFG_PATH
rm $BACKUP_MM_CFG_PATH