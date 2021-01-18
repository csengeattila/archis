#!/bin/bash

###	Please uncomment/comment and/or overwrite the lines You need	###
### -----------------------------------------------------------		###
KVM=true 	# leave it to install in kvm				###
#KVM=false	# uncomment to install on real hardware			###
									###
MYUSER=ati	# your username						###
MYHOST=sophia	# your hostname						###
									###
UCODE=amd-ucode		# processor microcode				###
#UCODE=intel-ucode	# processor microcode				###
###########################################################################



#
##
###
#### Preparing the install script --------------------------------------------
sed -i 's/KVM=nokvm/KVM='$KVM'/ archis/install.sh
sed -i 's/MYUSER=nouser/MYUSER='$MYUSER'/ archis/install.sh
sed -i 's/MYHOST=nohost/MYHOST='$MYHOST'/ archis/install.sh
sed -i 's/UCODE=noucode/UCODE='$UCODE'/ archis/install.sh
sed -i 's/dummyusername/MYUSER='$MYUSER'/ archis/install.sh

archis/install.sh
