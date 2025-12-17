{ lib, ...}: {
  # auto authorize known devices
  # to add a new one (replace exact path)
  # λ udevadm info --attribute-walk --path=/sys/bus/thunderbolt/devices/0-0 | grep unique_id
  services.udev.extraRules = let
  in ''
    # nvme dock # , ENV{UDISKS_IGNORE}="0"
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{unique_id}=="be030000-0082-840e-8311-10db48f2b808", ATTR{authorized}="1"
    # SUBSYSTEM=="block", ATTRS{ID_SERIAL_SHORT}=="PNY233623090801003AC", ENV{UDISKS_SYSTEM}="0"

    # gpg g1
    ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{unique_id}=="ba010000-0082-841e-03c4-fed9c800aa08", ATTR{authorized}="1"
  '';
}
