https://askubuntu.com/questions/178712/how-to-increase-swap-space
dd if=/dev/zero of=/media/pc/3ddaa8a1-223c-4f10-b7d3-4b8e6a96e670/SwapSpace/swapfile.img bs=1024 count=250M
chmod 0600 /media/pc/3ddaa8a1-223c-4f10-b7d3-4b8e6a96e670/SwapSpace/swapfile.img
mkswap /media/pc/3ddaa8a1-223c-4f10-b7d3-4b8e6a96e670/SwapSpace/swapfile.img

/media/pc/3ddaa8a1-223c-4f10-b7d3-4b8e6a96e670/SwapSpace/swapfile.img swap swap sw 0 0

sudo chown root:root /media/pc/3ddaa8a1-223c-4f10-b7d3-4b8e6a96e670/SwapSpace/swapfile.img
sudo chmod 600 /media/pc/3ddaa8a1-223c-4f10-b7d3-4b8e6a96e670/SwapSpace/swapfile.img

sudo swapon /media/pc/3ddaa8a1-223c-4f10-b7d3-4b8e6a96e670/SwapSpace/swapfile.img





To change the system swappiness value, open /etc/sysctl.conf as root. Then, change or add this line to the file:

vm.swappiness = 10

Apply the change.

sudo sysctl -p

sysctl vm.swappiness=10