

Огромная база всевозможных девайсов отсортированная по линуксовым драйверам https://deviwiki.com/wiki/Category:Linux_driver/802dot11

## USB "свистки"

### EDUP EP-AC1605

## mPCIe карточки

### Compex WLE600VX (7AA)

  Самая "простая" и оптимальная, но mimo только 2x2

 - https://wifimag.ru/cat/komlektuyushchie/platy_mini_pci/compex_wle900vx_7aa/
 - https://serverfault.com/questions/893961/trouble-with-802-11ac-from-a-wle900vx-card-qca9880-ath10k-via-hostapd

### Compex WLE900VX

  Аналогична WLE600VX, но mimo уже 3x3, с ними есть проблемы см. deviwiki

### Compex WLE1216v5-20

  Поддерживает только 5GHz диапазон

### Compex WLE1216VX

  2х диапазонная mimo 4x4, но "толстая", на будущее можно рассматреть

# Антенна

## KC10-2400/5000

  Можно либо несколько простых антенн рядом поставить, либо купить сразу сборкой mimo.
  Видимо проще сразу брать 5GHz и карту и антенну с нормальным усилением, при том, что больших площадей покрытия не требуется этого хватит.

- https://myantenna.ru/antenny-3g-4g-lte/wi-fi-antenny/kc10-2400-5000-dvuhdiapazonnaya-vsenapravlennaya-wifi-antenna-2-4-5-ggts-10-db
- https://aliexpress.ru/item/1005002079390641.html


# Конфиги

 - https://www.ylsoftware.com/news/692

## Пример hostapd конфига для Compex WLE900VX


```
interface=wlp6s0
driver=nl80211
hw_mode=a
ctrl_interface=/var/run/wlp6s0
ctrl_interface_group=0
max_num_sta=255

#logger_syslog=-1
#logger_syslog_level=2
#logger_stdout=-1
#logger_stdout_level=2

#Details for Connecting Clients via WPA2 TKIP
ssid=q2900mAC
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wpa_passphrase=password

#802.11d Regulatory Restrictions Designations for Which Frequencies and Channels are Legal
ieee80211d=1
country_code=US

#802.11n Configurations
ieee80211n=1
ht_capab=[LDPC][HT40+][SHORT-GI-20][SHORT-GI-40][TX-STBC][DSSS_CCK-40]

#802.11ac Configurations
ieee80211ac=1
vht_capab=[SHORT-GI-80][MAX-MPDU-11454][RXLDPC][TX-STBC-2BY1][MAX-A-MPDU-LEN-EXP3][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN]
vht_oper_chwidth=1

#How Many Units of Time Between Beacon Transmissions
beacon_int=100
#Multiplier of How Many Units of Time Between Beacon Transmissions
dtim_period=2
#(e.g. 100 milliseconds(ms) * 2 = 200 ms between beacons)

#Something About WMM Clients Needing this
wmm_enabled=1

###To Be Completely Honest-- I'm Not Entirely Certain What the Rest of this file does

#QoS Type of Traffic Management Based on Traffic Type

#Background
wmm_ac_bk_cwmin=4
wmm_ac_bk_cwmax=10
wmm_ac_bk_aifs=7
wmm_ac_bk_txop_limit=0
wmm_ac_bk_acm=0

#Best Effort
wmm_ac_be_aifs=3
wmm_ac_be_cwmin=4
wmm_ac_be_cwmax=10
wmm_ac_be_txop_limit=0
wmm_ac_be_acm=0

#Video
wmm_ac_vi_aifs=2
wmm_ac_vi_cwmin=3
wmm_ac_vi_cwmax=4
wmm_ac_vi_txop_limit=94
wmm_ac_vi_acm=0

#Voice
wmm_ac_vo_aifs=2
wmm_ac_vo_cwmin=2
wmm_ac_vo_cwmax=3
wmm_ac_vo_txop_limit=47
wmm_ac_vo_acm=0
```
