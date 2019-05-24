#!/bin/sh
# DuplicateMacProvisionDMGMulti.sh
# Use sudo sh ./DuplicateMacProvisionDMGMulti.sh to run
# *** Read info below before using!!! ***
# Mike Thompson, JMT, 5/2019, Rutherford County Schools

# This is a niche quick and dirty script for those wanting to speed up the process of duplicating Mac Provisioning USB Flash drives
# for Reimaging Apple/Mac computers. If you do not know what Mac Provisioner is (tool provided by Apple) you do not need this.
# Why did I do this? I needed a quicker way to mass duplicate Mac Provisioner USB drives for technicians in RCS. 
# The Mac Provisioner creates a multi-partition drive that you can option boot a MacBook/iMac/other and automatically install
# macOS. (Brief desc.) I did not right off find an easy way to seamlessly duplicate the multi-partition drive. Single partition
# can be easily duplicated with Disk Utility/other GUI utilities but from what I found not multi-partition (at the time of this
# writing). This script is looped, unmounts and asks you if you want to do another after duplication is finished. 
# Instructions:
# Make sure your partitions are correct by using "diskutil list" with your disk media below mounted and USB flash drive.
# Make sure you change the MacProvImageLoc to the dmg name you create. Mac Provisioner can create erase installs and upgrade installs
# so I name the dmg appropriately. You create the DMG file AFTER you create a USB flash drive with Mac Provisioner to your liking. In
# disk utility GUI you can dismount the USB drive (both partitions) then right click on the dismounted flash drive inside 
# disk utility and create a DMG file (will create both partition inside the file. Email me if needed. 
# You could in theory use this for any multiple purpose multi-partition duplication, edit for your own purposes. 

# ************* Danger, /dev locations must be modified for your Mac/setup, if not you could destroy a partition!!! **************
# ************* Danger if you use Apple Time Capsule!!! If it automounts before you run this it could utilize a /dev/disk that 
# was once allocated by a flash drive. Double check diskutil list! (Don't ask me how I know this...)

# I recommend at least using a 32GB flash drive. Change the below variable needed to vary the size of the 1st partition
# Recommended flash drive ($9.xx from Amazon) Samsung USB 3.1 32GB FIT drives. Fast and reliable drives for the price!
# I also rewrote the script to be able to do 4 USB flash drives at a time (5/24/2019) if you have seen the single script. 
# I use an Amazon Basics 4 port "powered" USB hub and highly recommend. Make sure you get the "power" adapter if you purchase
# or you could get USB power warnings. 

#Create looped menu for making multiple duplications. 

#Clear screen
clear

diskutil list

#Loop Menu Variables
break='Continue Quit'
PS3='*** Danger!! This script could wipe usable partitions if the disk locations are not changed in this script. Beware if you use a Time Capsule as it can automount to one of the dev locations you have configured!!! *** Type 1 then press Enter to Continue or 2 then Enter to Exit!'

DrivePartSize1='16g'

: '
Danger!!! You need to do a diskutil list at the CLI to make sure the below is correct. Mount the DMG you created from your USB
 key the provisioner built to confirm the below will be correct on your Mac setup.
 Make sure you rename the Provisioning Image with a shortfile name. (otherwise it will need to be escaped out)
'

# ------ Minimum you need to edit the below Variables ------

# *** Important to verify the below as your USB Flash Drives! ***
# USB Flash Drive Device Locations
FlashDriveLoc1='/dev/disk3'
FlashDriveLoc2='/dev/disk4'
FlashDriveLoc3='/dev/disk5'
FlashDriveLoc4='/dev/disk6'

# DMG Variable
MacProvImageLoc='./MacProvErase.dmg'

# ------ END Edit Variables ------

# Partition Variables
FlashDriveLoc1Part1="$FlashDriveLoc1"s2
FlashDriveLoc1Part2="$FlashDriveLoc1"s3
FlashDriveLoc2Part1="$FlashDriveLoc2"s2
FlashDriveLoc2Part2="$FlashDriveLoc2"s3
FlashDriveLoc3Part1="$FlashDriveLoc3"s2
FlashDriveLoc3Part2="$FlashDriveLoc3"s3
FlashDriveLoc4Part1="$FlashDriveLoc4"s2
FlashDriveLoc4Part2="$FlashDriveLoc4"s3

#Caffeinate macOS to prevent sleep with this scripts PID (releases when script is exited)
caffeinate -w $$ &


#Kick off the if then loop
select name in $break
do
	if [ $name == 'Quit' ]
	then
		break
	fi

echo
echo
echo

#Creates 2 partitions on a 32GB+ Flash Drive/other, 16GB for the first one and then use the rest for the second one. 
#Can change the size below if needed. 

diskutil partitionDisk $FlashDriveLoc1 GPT JHFS+ First $DrivePartSize1 JHFS+ Second 0b

diskutil partitionDisk $FlashDriveLoc2 GPT JHFS+ First $DrivePartSize1 JHFS+ Second 0b

diskutil partitionDisk $FlashDriveLoc3 GPT JHFS+ First $DrivePartSize1 JHFS+ Second 0b

diskutil partitionDisk $FlashDriveLoc4 GPT JHFS+ First $DrivePartSize1 JHFS+ Second 0b

echo
echo
echo

#Mount Disk Image previously made with Disk Utility from flash drive read only (Example location)
MacProvImageDev=$(hdiutil mount -readonly $MacProvImageLoc | awk '/dev.disk/{print$1}')
MacProvImageMountLoc=$(echo $MacProvImageDev | awk '{ print $1 }')

#USB Disk 1
echo "Restoring partition 1 to $FlashDriveLoc1Part1"
sudo asr restore --erase --noprompt -source "$MacProvImageMountLoc"s2 --target $FlashDriveLoc1Part1
echo "Restoring partition 2 to $FlashDriveLoc1Part2"
sudo asr restore --erase --noprompt -source "$MacProvImageMountLoc"s3 --target $FlashDriveLoc1Part2
echo
echo 
echo

#USB Disk 2
echo "Restoring partition 1 to $FlashDriveLoc2Part1"
sudo asr restore --erase --noprompt -source "$MacProvImageMountLoc"s2 --target $FlashDriveLoc2Part1
echo "Restoring partition 2 to $FlashDriveLoc2Part2"
sudo asr restore --erase --noprompt -source "$MacProvImageMountLoc"s3 --target $FlashDriveLoc2Part2
echo
echo 
echo

#USB Disk 3
echo "Restoring partition 1 to $FlashDriveLoc3Part1"
sudo asr restore --erase --noprompt -source "$MacProvImageMountLoc"s2 --target $FlashDriveLoc3Part1
echo "Restoring partition 2 to $FlashDriveLoc3Part2"
sudo asr restore --erase --noprompt -source "$MacProvImageMountLoc"s3 --target $FlashDriveLoc3Part2
echo
echo
echo

#USB Disk 4
echo "Restoring partition 1 to $FlashDriveLoc4Part1"
sudo asr restore --erase --noprompt -source "$MacProvImageMountLoc"s2 --target $FlashDriveLoc4Part1
echo "Restoring partition 2 to $FlashDriveLoc4Part2"
sudo asr restore --erase --noprompt -source "$MacProvImageMountLoc"s3 --target $FlashDriveLoc4Part2
echo
echo 
echo

#Finished, giving time to let asr finish up, then unmounting flash drive

sleep 15

echo "Dismount Mac Provisioner Disk Image"
diskutil unmountDisk $MacProvImageDev
echo "Dismount the 4 USB Flash Drives"
diskutil unmountDisk $FlashDriveLoc1
diskutil unmountDisk $FlashDriveLoc2
diskutil unmountDisk $FlashDriveLoc3
diskutil unmountDisk $FlashDriveLoc4

done

clear
echo Disk copy Finished

diskutil list

exit 0
