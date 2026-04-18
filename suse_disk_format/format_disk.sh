#!/bin/bash

FS_TYPE="${FS_TYPE_OVERRIDE}"
echo "Using filesystem type: $FS_TYPE"

# Step 1: Capture devices that are already mounted (i.e., have a mount point)
echo "Checking for unmounted devices..."
available_disks=$(lsblk -o NAME,MOUNTPOINT | awk '$2 == "" {print $1}')

# Step 2: Filter to find the first unmounted device that is NOT already used (like /dev/sda)
# You can exclude known system disks like sda if needed
for dev in $available_disks; do
    if [[ "$dev" != "sda" ]]; then
        added_device="/dev/$dev"
        break
    fi
done

# Step 3: Result handling
if [ -z "$added_device" ]; then
    echo "No unmounted (new) device found."
    exit 1
fi

echo "New unmounted device detected: $added_device"


############# Create LVM Process #########################

VG_NAME="vg_newdisk"                    # Volume group name
LV_NAME="lv_data"                       # Logical volume name
MOUNT_POINT="/mnt/newdisk"             # Mount point for the new volume

# Create physical volume
pvcreate "$added_device"

# Create volume group
vgcreate "$VG_NAME" "$added_device"

# Create logical volume using all available space
lvcreate -l 100%FREE -n "$LV_NAME" "$VG_NAME"

# Format the logical volume with the detected filesystem type
mkfs."$FS_TYPE" "/dev/$VG_NAME/$LV_NAME"

echo "Logical volume /dev/$VG_NAME/$LV_NAME formatted with $FS_TYPE."

############# Mount and fstab Entry #########################


mkdir -p "$MOUNT_POINT"					# Create mount point if it doesn't exist
mount "/dev/$VG_NAME/$LV_NAME" "$MOUNT_POINT"

# Get UUID of the logical volume
UUID=$(blkid -s UUID -o value "/dev/$VG_NAME/$LV_NAME")

# Add entry to /etc/fstab for persistent mounting
echo "UUID=$UUID $MOUNT_POINT $FS_TYPE defaults 0 0" >> /etc/fstab

echo "Logical volume mounted at $MOUNT_POINT and added to /etc/fstab."
