{ pkgs, config, lib, ... }:
let
  net      = "192.168.2";
  hostname = "router";
  domain   = "zoo";
  address  = "${net}.1";
in {
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys =
    [ config.zoo.secrets.users.petrkozorezov.authPublicKey ]; # FIXME default user

  boot = {
    # kernelPackages = pkgs.linuxPackages_5_11;
    cleanTmpDir    = true;
  };

  #
  # router
  #
  zoo.router = {
    enable     = true;
    hostname   = hostname;
    domain     = domain;

    uplink.interface = "enp3s0";

    local = {
      net                = net;
      ethernet.interface = "enp4s0";
      wireless           = rec {
        interface     = "wlp2s0";
        ssid          = "Petrovi4Home";
        wpaPassphrase = config.zoo.secrets.wifi."${ssid}".passphrase;
        hwMode        = "g";
        countryCode   = "RU";
        channel       = 1;
        noScan        = true;
        extraConfig   =
            ''
              auth_algs=1
              wpa=2
              wpa_key_mgmt=WPA-PSK
              wpa_pairwise=CCMP
              rsn_pairwise=CCMP

              ieee80211n=1
              ht_capab=[LDPC][HT40+][SHORT-GI-20][SHORT-GI-40][TX-STBC][DSSS_CCK-40]

              #ieee80211ac=1
              #vht_capab=[TX-STBC-2BY1][MAX-A-MPDU-LEN-EXP3][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN]
              #vht_oper_chwidth=1
              #vht_oper_centr_freq_seg0_idx=42

              beacon_int=100
              #Multiplier of How Many Units of Time Between Beacon Transmissions
              #(e.g. 100 milliseconds(ms) * 2 = 200 ms between beacons)
              dtim_period=2

              #Something About WMM Clients Needing this
              wmm_enabled=1

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
            '';
      };
      hosts = {
        mbp13 = {
          # TODO more than one
          # 80:e6:50:06:55:ea
          mac = "ac:87:a3:0c:83:96";
          ip  = "50";
        };
        asrock-x300 = {
          mac = "a8:a1:59:57:7b:58";
          ip  = "51";
        };
      };
    };
  };
}
