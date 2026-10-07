# TCL T615T (MStar MT5889) firmware analysis

Inventories and curated extract trees for three firmware versions of the same TCL **T615T** board family (MT5889 SoC, Android bootimg, SquashFS rootfs built 2021-10-21). Parsed 2026-09-28/29.

| Folder | Firmware | Contents |
|---|---|---|
| `v083/` | V8-T615T01-LF1V083 | `extract/` (cpu_audio, midaemon, libapiAUDIO.so, libdrvIPAUTH.so), `vendor_extract/` (audio DSP fw ±MS12V22, mik.ko, utpa2k.ko, libutopia.so), partition inventory |
| `v098/` | V8-T615T01-LF1V098 | `extract/`, `vendor_extract/` (incl. libmi3.so), richest inventory (76 dirs / 735 files) |
| `v474/` | V8-T615T03-LF1V474 | `extract/` (debug scenarios, ~20 MTK API libs), `vendor_extract/` (MT7961/MT7663/MT7668 WiFi-BT RAM codes) |

Raw partition images (~1.9 GB) exceed GitHub's per-file limit and stay local — the full manifest is in [README.ua.md](README.ua.md). The `tvservice_inventory.txt` diffs between versions (362 changed lines v098→v474) document the comparative analysis.

**Related:** this platform is the donor for differential analysis in [projector-research](https://github.com/vladikit-bit/projector-research) (same MT5889 family as the Thundeal TD.98 Pro).
