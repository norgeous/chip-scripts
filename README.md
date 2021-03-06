# CHIP Customiser
Various bash scripts for NTC CHIP using whiptail menus, tested with 4.4.13-ntc-mlc headless image.

![ScreenShot](preview.png)

- - -

## Run
Login as `root` (or `sudo su`) and run with:
```
bash <(curl -sL https://rawgit.com/norgeous/CHIP-customiser/master/RUNME.sh)
```
- - -

## What options are available

### update.sh
* Perform a system update.
* Perform a system upgrade.
* Autoremove unused packages.

### first_run.sh
* Change default hostname.
* Change default username and password.
* Disable root password.
* Configure Locale and Timezone.
* Reduce swappiness (to protect NAND a bit).
* Enable the `ll` command.

### install_nginx_router.sh
* Install `nginx` on port 80.
* Install `php5-fpm`.
* Adds a jump off point for other services - a page that lists all open ports and provides reboot and shutdown buttons.
* Can be accesed via http://router.admin/ when using wifi_ap.sh.

### install_pihole.sh
* Network wide adblocker using DNS installed to port 8080.
* https://pi-hole.net/

### install_motioneye.sh
* Cheap CCTV camera.
* https://github.com/ccrisan/motioneye

### install_say.sh
* Install local TTS engine.
* Create wrapper for TTS engine as `say` command.

### install_nodejs.sh
* Install NodeJS 7.x
* https://nodejs.org/
* https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions

### install_wetty.sh
* Installs browser acessable tty through npm and sets a systemd service on port 2222.
* https://github.com/krishnasrinivas/wetty

### install_syncthing.sh
* Install Syncthing (a file syncronisation tool) and repos.
* https://syncthing.net/

### configure_wifi_ap.sh
* Broadcast WIFI AP on wlan1.
* Enable NAT forwarding.
* CHIP acts as router (if wlan0 is connected to the internet).

### configure_bluetooth_speaker.sh
* Connect a bluetooth speaker.
* Setup `pa` systemd (to start pulseaudio on boot).
* Use `systemctl restart pa` to restart pulse.
* Setup `speaker` systemd (to reconnect speaker on boot).
* Use `systemctl restart speaker` to reconnect speaker manually.

### configure_status_led.sh
* Change behaviour of status LED (default is heartbeat), choose from list.
* Setting made with menu are made permanent via oneshot systemd, check with `systemctl status statusled`.
* Add temporary led change commands `statusled heartbeat`, `statusled none`, `statusled mmc0`, etc.

- - -

## CHIP flashing quick reference
1. Connect the FEL - GND wire.
2. Flash the CHIP with headless from the Chrome flasher at http://flash.getchip.com/.
3. Power off the CHIP (hold button for 7 seconds).
4. Remove FEL - GND wire.
5. Power on the CHIP (hold button for 1 second).
6. Wait for CHIP to boot.
7. Launch putty and connect to COM port (find with Device Manager).
8. Connect to your home WIFI internet with either of these:
  * `nmtui`
  * `nmcli d wifi connect "Netgear" password "12345678" ifname wlan0`
9. Use `ifconfig` to find the CHIP's IP address
10. Exit putty
11. You can now connect to the CHIP over the local network (using putty or `ssh`)
