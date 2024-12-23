{ lib, ...}: {
  # auto authorize known devices
  services.udev.extraRules = ''
    # nvme dock # , ENV{UDISKS_IGNORE}="0"
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{unique_id}=="be030000-0082-840e-8311-10db48f2b808", ATTR{authorized}="1"
    # gpg g1
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{unique_id}=="ba010000-0082-841e-03c4-fed9c800aa08", ATTR{authorized}="1"
  '';
}
