---
---

# Installation

This document describes how to install all the required components required to use the services of the underwater camera:

1. [Installing and configuring the operating system](#installing-and-configuring-the-operating-system)
2. [Downloading and compiling the services](#downloading-and-compiling-the-services)
3. [(optional) Creating service configuration files for your services to start the automatically at boot](#optional-creating-service-configuration-files-for-your-services-to-start-the-automatically-at-boot)

## Prerequisites

* Raspberry Pi Zero W
* USB to UART converter (e.g. [CP2102 USB UART Board (micro)](https://www.waveshare.com/cp2102-usb-uart-board-micro.htm))
* SD-card
* power supply for the Raspi
* WiFi access point for downloading packages from the internet


## Installing and configuring the operating system

The following actions install and configure the operating system of the Raspberry Pi.

1. Download the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and install it.
2. Download the "Raspberry Pi OS Lite"-Image (e.g. *2023-12-11-raspios-bookworm-armhf-lite.img.xz*) of the operating system [here](https://www.raspberrypi.com/software/operating-systems/).
3. Verify the downloaded file by comparing its SHA256 hash with the one provided by the download page.
4. Connect the SD-card to your computer.
5. Start the Raspberry Pi Imager.
   1. Choose the image (e.g. *2023-12-11-raspios-bookworm-armhf-lite.img.xz*) to put on the SD-card.
   2. Select the SD-card
   3. Start the transfer process
6. Reconnect the SD-card to your computer to get it mounted.
7. Create the file `userconf.txt` with the content `tux:$6$z0X5rMJqkjI1rfzN$Atw1Yz7tK2IThlV7bcrZypekdRM.fUH3I5aDvawax40ydzFhQnOm.q8Az3Q0WH0THnjlqLQAWXZGAwymm5dZF1` in the root folder of the SD-card ("bootfs" partition). This creates a user "tux" with password "xut" (`openssl passwd -6` can be used on Linux to create your own password).
8. Make the following adaptations in `config.txt`:
   1. Add `enable_uart=1` to enable console access via the serial interface (GPIO14 & GPIO15).
   2. Uncomment `dtparam=i2c_arm=on` to activate the I²C interface for the temperature and humidity sensor (DHT20).
   3. Change `camera_auto_detect=1` to `camera_auto_detect=0` to manually configure the used camera.
   4. Add `dtoverlay=imx462` to load the camera overlay.
9.  To enable SSH access, create a file `ssh` without content in the root folder of the SD-card.
10. Remove the SD-card and put it into your Raspi.
11. Connect your USB to UART board to the Raspi using GND (pin 6), TxD (pin 8) and RxD (pin 10).
12. Connect your USB to UART board to your computer (using an USB cable).
13. Open a terminal (e.g. [PuTTY](https://www.putty.org)) and establish a connection to the serial interface of your USB to UART board (115200 Baud, 8 data bits, 1 stop bit, no parity, no flow control).
14. Connect the PoE-Adapter to the USB-Port which is closer to the center of the board.
15. Connect the PoE-Adapter to a PoE-Injector.
16. Login to the Raspi (by using PuTTY) and add "i2c-dev" to `/etc/modules` to load the I²C kernel module at boot time.
17. Connect to a WiFi access point by executing `sudo nmcli --ask dev wifi connect <ssid>`. For getting a list of all access points us `iwlist wlan0 scan`.
18. Execute `sudo apt-get update`.
19. Execute `sudo apt install i2c-tools` to install tools required for I²C communication.
20. Execute `sudo apt install nodejs npm` to install the JavaScript runtime environment.
21. Turn off IPV6 by executing `sudo bash -c 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf'`.
22. Configure the eth0 interface by creating /etc/network/interfaces.d/eth0 with the following content:

    ```
    allow-hotplug eth0
        
    iface eth0 inet static
        address 192.168.1.1/24
    ```

23. Execute `sudo reboot now` to apply all changes.
24. Disconnect from Wifi by executing `sudo nmcli con down id <ssid>` to disconnect.


## Downloading and compiling the services 

The underwater camera consists of four services. Follow the links to their repositories. There you'll find instructions on how to install them.

* [Video Service](https://github.com/tederer/octowatch-videoservice)
* [Web Server](https://github.com/tederer/octowatch-webservice)
* [Monitoring Service](https://github.com/tederer/octowatch-monitoring)
* [InfraredLight Service](https://github.com/tederer/octowatch-irlightcontrol)


## (optional) Creating service configuration files for your services to start the automatically at boot

To start a service automatically at boot time, the following steps are required:

1. Create a file with the extension “.service“ in `/usr/lib/systemd/system` with the following content and adapt "Description" and "ExecStart":

    ```
    [Unit]
    Description=OctoWatch video service
    After=network-online.target
    Wants=network-online.target
    
    [Service]
    Type=simple
    User=tux
    Group=tux
    ExecStart=/home/tux/octowatch-videoservice/build/video_service
    
    [Install]
    WantedBy =multi-user.target
    ```

2. Execute `sudo systemctl daemon-reload` to reload the configuration.
3. Execute `sudo systemctl enable <service-name>` to start the new service at boot (replace <service-name> by the name of the file created in step 1).
4. Execute `sudo reboot now` to apply all changes.

## References

[Raspberry Pi Configuration](https://www.raspberrypi.com/documentation/computers/configuration.html)  
[I2C on Pi](https://learn.sparkfun.com/tutorials/raspberry-pi-spi-and-i2c-tutorial/all#i2c-on-pi)  
[Raspberry Pi Documentation: About the Camera Modules](https://www.raspberrypi.com/documentation/accessories/camera.html#installing-a-raspberry-pi-camera)  
