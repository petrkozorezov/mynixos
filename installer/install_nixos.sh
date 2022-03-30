#!/usr/bin/env -S nix shell -i nixpkgs#nixos-install-tools nixpkgs#gnugrep nixpkgs#coreutils nixpkgs#util-linux nixpkgs#cryptsetup nixpkgs#btrfs-progs nixpkgs#dosfstools nixpkgs#parted nixpkgs#lvm2_dmeventd nixpkgs#bashInteractive -c bash
# TODO decide disk name structure (nvme1p1 vs sda1)
# TODO check correct mount after create
function usage {
  echo "Usage: $0 [ create | mount | umount | show-config | show-hardware-config ] <disk-device>"
}

if [[ $# -ne 2 ]]; then
  usage
  exit 1
fi

set -ex
STAGE=$1
DISK=$2
MNT=/tmp/mnt
LUKS_DISK_NAME=enc
LUKS_DISK="/dev/mapper/$LUKS_DISK_NAME"
LVM_NAME=lvm
BTRFS_DISK=/dev/$LVM_NAME/root
SWAP_DISK="/dev/$LVM_NAME/swap"

## parted
function create-disks {
  mkdir "$MNT"
  parted $DISK -- mklabel gpt
  parted $DISK -- mkpart ESP fat32 2048s 980991s # I don't know if these numbers are universal
  parted $DISK -- set 1 boot on
  parted $DISK -- mkpart main 980992s 100%

  ## LUKS setup
  cryptsetup --verify-passphrase -v luksFormat "$DISK"2
  cryptsetup open "$DISK"2 "$LUKS_DISK_NAME"

  ## LVM
  pvcreate "$LUKS_DISK"
  vgcreate "$LVM_NAME" "$LUKS_DISK"

  lvcreate --size 8G --name swap "$LVM_NAME"
  lvcreate --extents 100%FREE --name root "$LVM_NAME"

  ## btrfs
  mkfs.btrfs "$BTRFS_DISK"
  mount -t btrfs "$BTRFS_DISK" "$MNT"

  # We first create the subvolumes outlined above:
  btrfs subvolume create "$MNT"/root
  btrfs subvolume snapshot -r "$MNT"/root "$MNT"/root-blank
  btrfs subvolume create "$MNT"/home
  btrfs subvolume create "$MNT"/nix
  btrfs subvolume create "$MNT"/srv
  btrfs subvolume create "$MNT"/lib
  btrfs subvolume create "$MNT"/log

  umount "$MNT"

  mkswap "$SWAP_DISK"

  cryptsetup close "$LVM_NAME"-root
  cryptsetup close "$LVM_NAME"-swap
  cryptsetup close "$LUKS_DISK_NAME"

  # mkfs.vfat -n boot "$DISK"1
  mkfs.fat -F 32 -n boot /dev/sda3

  rm "$MNT" -r
}

function mount-disks {
  mkdir "$MNT"
  mount -t tmpfs none "$MNT"
  mkdir "$MNT"/{boot,home,nix,srv,var,var/lib/,var/log}

  mount "$DISK"1 "$MNT"/boot
  cryptsetup open "$DISK"2 "$LUKS_DISK_NAME"
  pvscan && lvscan

  #swapon "$SWAP_DISK"

  BTRFS_OPTS="compress=zstd:1,noatime"
  mount -o "subvol=root,$BTRFS_OPTS" "$BTRFS_DISK" "$MNT"/
  mount -o "subvol=home,$BTRFS_OPTS" "$BTRFS_DISK" "$MNT"/home
  mount -o "subvol=nix,$BTRFS_OPTS" "$BTRFS_DISK" "$MNT"/nix
  mount -o "subvol=nix,$BTRFS_OPTS" "$BTRFS_DISK" "$MNT"/srv
  mount -o "subvol=lib,$BTRFS_OPTS" "$BTRFS_DISK" "$MNT"/var/lib
  mount -o "subvol=log,$BTRFS_OPTS" "$BTRFS_DISK" "$MNT"/var/log
}

function umount-disks {
  umount "$MNT"/boot
  umount "$MNT"/var/log
  umount "$MNT"/var/lib
  umount "$MNT"/srv
  umount "$MNT"/nix
  umount "$MNT"/home
  umount "$MNT"/
  #swapoff "$SWAP_DISK"
  cryptsetup close "$LVM_NAME"-root
  cryptsetup close "$LVM_NAME"-swap
  cryptsetup close "$LUKS_DISK_NAME"
  umount "$MNT"
  rm "$MNT" -r
}

function show-hardware-config {
  nixos-generate-config --root "$MNT" --show-hardware-config
}

function show-config {
  echo \
"{
  boot=\"/dev/disk/by-uuid/$(get-uuid ${DISK}1)\";
  luks=\"/dev/disk/by-uuid/$(get-uuid ${DISK}2)\";
  root=\"/dev/disk/by-uuid/$(get-uuid ${BTRFS_DISK})\";
  swap=\"/dev/disk/by-uuid/$(get-uuid ${SWAP_DISK})\";
}"
}

function get-uuid {
  blkid -o export "$1" | grep '^UUID=' | cut -d '=' -f 2
}

# nixos-install --root /tmp/mnt --flake .#mbp13 --no-root-passwd --impure
# sudo ./nixos-install --root /tmp/mnt --flake .#mbp13 --no-root-passwd --impure --no-channel-copy -v

case $STAGE in
  create)
    create-disks
    ;;
  mount)
    mount-disks
    ;;
  umount)
    umount-disks
    ;;
  show-config)
    show-config
    ;;
  show-hardware-config)
    show-hardware-config
    ;;
  *)
    usage
    exit 1
    ;;
esac
