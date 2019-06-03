<H2>Duplicate Mac Provisioning Flash Disk (Multiple Flash Drive version)</H2>

*** Danger, this can be a destructive script, read below fully, not responsible for data loss!!! Must edit script to change drive locations to match your setup. I HIGHLY recommend pausing Time Machine backup if used on the Mac running this script. It can mount into a dev location that you may have set as an USB flash drive while they are unplugged! ***

This is a niche quick and dirty script for those wanting to speed up the process of duplicating Mac Provisioning USB Flash drives
for Reimaging Apple/Mac computers. If you do not know what Mac Provisioner is (tool provided by Apple) you do not need this.
Why did I do this? I needed a quicker way to mass duplicate Mac Provisioner USB drives for technicians in RCS. 
The Mac Provisioner creates a multi-partition drive that you can option boot a MacBook/iMac/other and automatically install
macOS. (Brief desc.) I did not right off find an easy way to seamlessly duplicate the multi-partition drive. Single partition
can be easily duplicated with Disk Utility/other GUI utilities but from what I found not multi-partition (at the time of this
writing). This script is looped, unmounts and asks you if you want to do another after duplication is finished. 
Instructions:
Make sure your partitions are correct by using "diskutil list" with your disk media below mounted and USB flash drive.
Make sure you change the MacProvImageLoc to the dmg name you create. Mac Provisioner can create erase installs and upgrade installs
so I name the dmg appropriately. You create the DMG file AFTER you create a USB flash drive with Mac Provisioner to your liking. In
disk utility GUI you can dismount the USB drive (both partitions) then right click on the dismounted flash drive inside 
disk utility and create a DMG file (will create both partition inside the file. Email me if needed. 
You could in theory use this for any multiple purpose multi-partition duplication, edit for your own purposes. 

**** Danger, /dev locations must be modified for your Mac/setup, if not you could destroy a partition!!!
Danger if you use an Apple Time Capsule!!! If it automounts before you run this it could utilize a /dev/disk that 
was once allocated by a flash drive. Double check diskutil list! (Don't ask me how I know this...)

I recommend at least using a 32GB flash drive. Change the below variable needed to vary the size of the 1st partition
Recommended flash drive ($9.xx from Amazon) Samsung USB 3.1 32GB FIT drives. Fast and reliable drives for the price!
I also rewrote the script to be able to do 4 USB flash drives at a time (5/24/2019) if you have seen the single script. 
I use an Amazon Basics 4 port "powered" USB hub and highly recommend. Make sure you get the "power" adapter if you purchase
or you could get USB power warnings. 


To run from macOS terminal:

It is best for this script to sudo into su to prevent additional login prompts

sudo su

sh DuplicateMacProvisionDMGMulti.sh	
