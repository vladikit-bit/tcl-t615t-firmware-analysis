# Розбір прошивок TCL T615T (MStar MT5889)

Інвентаризації та витягнуті дерева трьох версій прошивки одного TCL-заводу **T615T** (плата T01/T03, SoC **MT5889**, у аудіо-підсистемі MT9615, Android bootimg, SquashFS rootfs зібрана 2021-10-21). Розбір виконано 2026-09-28…29.

## Версії

| Папка | Прошивка | Що всередині репо | Розмір |
|---|---|---|---|
| `v083/` | **V8-T615T01-LF1V083** | `extract/` (cpu_audio, midaemon, libapiAUDIO.so, libdrvIPAUTH.so, audio_sh/), `vendor_extract/` (аудіо-DSP fw aucode_adec/asnd ±MS12V22, fwVPU/VLC, audio.primary.mt5889.so, mik.ko, utpa2k.ko, libutopia.so), `tvservice_inventory.txt` | ~88 МБ |
| `v098/` | **V8-T615T01-LF1V098** | `extract/`, `vendor_extract/` (вкл. libmi3.so), `tvservice_inventory.txt` (найбагатша версія: 76 дир. / 735 файлів) | ~66 МБ |
| `v474/` | **V8-T615T03-LF1V474** | `extract/` (дебаг-сценарії, ~20 MTK API бібліотек), `vendor_extract/` (WiFi/BT RAM-коди MT7961/MT7663/MT7668, fwVPU, libmi3, libutopia), `tvservice_inventory.txt` | ~115 МБ |

Ідентифікація платформи — через `strings` по образах: `androidboot.boot_devices=mstar_mci.0`, buildvariant=user, WiFi/BT MT7961 + MT7663/MT7668 (v474).

## Що НЕ входить у репозиторій (сирові образи, лишаються локально на F:\)

GitHub має жорсткий ліміт 100 МБ/файл, тож повні партиції залишились на диску. Перелік для відтворення розбору:

```
F:\v083\uni_out\            — повна eMMC-розкладка (23 партиції .bin):
  MBOOT/MBOOT_b/MBOOTBAK (3.2 МБ ×3), boot_a/recovery_a (48 МБ, android bootimg),
  dtbo_a, vbmeta_a ×2, linux_rootfs_a_a (89 МБ, SquashFS 4.0 LZO),
  3rd_a_a (125 МБ, SquashFS), tvservice_a (167 МБ, ext4), tclconfig_a (125 МБ, ext4),
  tvconfig (33 МБ), oem_a, cache, metadata, optee, armfw, frc_a, RTPM_a, _mmc_boot, upgrade.bin
F:\v083\ — ~751 МБ всього
F:\v098\tvservice.img (167 МБ), F:\v098\vendor.img (441 МБ, ext4)
F:\v474\tvservice.img (167 МБ), vendor.img (441 МБ), tclconfig.img (125 МБ),
  tvconfig.img (33 МБ ext4 — панельні/конфіг ini, 3840×2160)
F:\v083, F:\v098, F:\v474 — разом ~2.2 ГБ
```

Додатково частковий super-образ, пов'язаний з цим розбором: `C:\v083part\super_prefix.bin` (вересень 2026).

## Інвентаризації як свідоцтво порівняльного аналізу

`tvservice_inventory.txt` кожної версії — автозгенеровані листинги вмісту партиції tvservice. Диф `v098` vs `v474` = 362 змінені рядки; наприклад, ресурси `atve-kit`/`airplay` присутні лише у v098.

## Пов'язані матеріали

Ця платформа — родич проектора Thundeal TD98 Pro (теж MT5889), дослідження якого живе в репозиторіях `projector-research*` того ж акаунта: прошивки V083/V098/V474 використовувались як «донорські» дифи при розборі ліцензійних гейтів DTS/SPDIF.
