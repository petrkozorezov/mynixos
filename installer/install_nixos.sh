#!/usr/bin/env -S nix shell -i nixpkgs#coreutils nixpkgs#mount nixpkgs#umount nixpkgs#cryptsetup nixpkgs#btrfs-progs nixpkgs#dosfstools nixpkgs#parted nixpkgs#lvm2_dmeventd nixpkgs#bashInteractive -c bash
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 [ create | mount | umount ] <disk-device>"
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
  parted $DISK -- mkpart ESP fat32 1MiB 512MiB
  parted $DISK -- set 1 boot on
  parted $DISK -- mkpart Nix 512MiB 100%

  ## LUKS setup
  cryptsetup --verify-passphrase -v luksFormat "$DISK"p2
  cryptsetup open "$DISK"p2 "$LUKS_DISK_NAME"

  ## LVM
  pvcreate "$LUKS_DISK"
  vgcreate "$LVM_NAME" "$LUKS_DISK"

  lvcreate --size 8G --name swap "$LVM_NAME"
  lvcreate --extents 100%FREE --name root "$LVM_NAME"

  ## btrfs
  mkfs.btrfs "$BTRFS_DISK"
  mount -t btrfs "$BTRFS_DISK" "$MNT"

  # We first create the subvolumes outlined above:
  #btrfs subvolume create "$MNT"/root
  btrfs subvolume create "$MNT"/home
  btrfs subvolume create "$MNT"/nix
  btrfs subvolume create "$MNT"/lib
  btrfs subvolume create "$MNT"/log

  # We then take an empty *readonly* snapshot of the root subvolume,
  # which we'll eventually rollback to on every boot.
  #btrfs subvolume snapshot -r "$MNT"/root "$MNT"/root-blank

  umount "$MNT"

  mkfs.vfat -n boot "$DISK"p1

  mkswap "$SWAP_DISK"

  rm "$MNT" -r
}

function mount-disks {
  mkdir "$MNT"
  mount -t tmpfs none "$MNT"
  mkdir "$MNT"/{boot,home,nix,var,var/lib/,var/log}

  mount "$DISK"p1 "$MNT"/boot
  cryptsetup open "$DISK"p2 "$LUKS_DISK_NAME"
  pvscan && lvscan

  #swapon "$SWAP_DISK"

  BTRFS_OPTS="compress=zstd:1,noatime"
  mount -o "subvol=home,$BTRFS_OPTS" "$BTRFS_DISK" "$MNT"/home
  mount -o "subvol=nix,$BTRFS_OPTS" "$BTRFS_DISK" "$MNT"/nix
  mount -o "subvol=lib,$BTRFS_OPTS" "$BTRFS_DISK" "$MNT"/var/lib
  mount -o "subvol=log,$BTRFS_OPTS" "$BTRFS_DISK" "$MNT"/var/log
}

function umount-disks {
  umount "$MNT"/boot
  umount "$MNT"/var/log
  umount "$MNT"/var/lib
  umount "$MNT"/nix
  umount "$MNT"/home
  #swapoff "$SWAP_DISK"
  cryptsetup close "$LVM_NAME"-root
  cryptsetup close "$LVM_NAME"-swap
  cryptsetup close "$LUKS_DISK_NAME"
  umount "$MNT"
  rm "$MNT" -r
}

# install
# nixos-install --root /tmp/mnt --flake .#mbp13 --no-root-passwd

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
esac
