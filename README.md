<br><br><br>
<p align=center>
  <img src="assets/spacium.svg" alt="Spacium" width="478">
</p>
<br><br>

# Spacium

<p>
  <a href="https://github.com/irunatbullets/spacium/actions/workflows/update-image.yml"><img src="https://github.com/irunatbullets/spacium/actions/workflows/update-image.yml/badge.svg" alt="Update image"></a> <a href="https://github.com/irunatbullets/spacium"><img src="https://img.shields.io/github/last-commit/irunatbullets/spacium" alt="Last Commit"></a>
</p>

> [!NOTE]
> I've recently switched from `quickshell` to Dux Labs' own `dux-qt-base`, which is more up-to-date. The only migration step that may be required is reapplying your desktop theme.

This custom **Bazzite** image is based on `bazzite-gnome` with variants for the Nvidia open driver as well as Nouveau.

It includes **Dux Modular Shell** and **niri**
along with all of the recommended extras for DMS.

My goal with this image is to offer a vanilla DMS/niri experience with gaming
capabilities (via Bazzite). I have added **ghostty** as the default terminal
along with tools to allow developers to create their own DMS plugins.

Feel free to suggest additional software - or just fork this repo and do
whatever you like.

To switch, run one of the following commands from a terminal in any Universal
Blue or Fedora Atomic based install.

Choose from the following based on your gpu needs (amd, nvidia, or legacy nvidia):

```
sudo bootc switch ghcr.io/irunatbullets/spacium
```

```
sudo bootc switch ghcr.io/irunatbullets/spacium-nvidia
```

```
sudo bootc switch ghcr.io/irunatbullets/spacium-nouveau
```

**Important Note:** After switching to this image the login will backup any
existing niri configuration and replace it with standard dms niri configs.
Updates will not re-trigger this event.

## What my selection of additional applications achieve

- **ghostty** - nothing, I just switched to it when I started using dms.
- **bluetui** - an application for configuring multiple Bluetooth receivers.

## Notes, Workarounds

### A weird file manager appears sometimes (when opening firefox download locations, for example)

This is the new dux-files (dfiles) file manager. I added it to test it out because I really want Spacium to be as close to a complete DMS experience as I can make it. 

For now I've tried my best to keep gnome-files as the default. However, if you are seeing dfiles popup you can tweak your default apps:

1. Open DMS settings (Super + ,)
2. Go to Applications > Default apps (or just search for "Default apps")
3. Configure `File manager`, `Archive manager`, and any others to open your preferred application.

If it is still opening in some scenarios:

1. Launch "Files" via the launch or in a terminal by running `dfiles`
2. Open the settings via the "three dots under the close button" > Settings
3. Switch off "Register as the session file manager"

If you'd **prefer** to use the new manager, then do the opposite of the above, and the follow the optional guide below.

### Optional: Use Dux Files for file dialogs

Spacium uses the GTK file chooser by default. If you prefer Dux Files for application file dialogs, you can switch to its XDG Desktop Portal integration.

First, enable the Dux Files portal:

```bash
dfiles portal install
```

Create a personal copy of Spacium's portal configuration:

```bash
mkdir -p ~/.config/xdg-desktop-portal

cp /usr/share/xdg-desktop-portal/niri-portals.conf \
   ~/.config/xdg-desktop-portal/niri-portals.conf
```

Edit your personal copy:

```bash
nano ~/.config/xdg-desktop-portal/niri-portals.conf
```

Change:

```ini
org.freedesktop.impl.portal.FileChooser=gtk;
```

to:

```ini
org.freedesktop.impl.portal.FileChooser=dfiles;
```

Restart the portal:

```bash
systemctl --user restart xdg-desktop-portal
```

You can verify the configuration with:

```bash
dfiles portal status
```

This changes the file chooser used by applications that support XDG Desktop Portals. It does not change your default file manager.

Your personal configuration takes precedence over Spacium's system-wide configuration, so this change will persist across image updates unless you remove your personal override.

For more information, check out [Dux Labs documentation about Dux Files](https://duxlabs.dev/docs/dfiles)

### How do I change dux greeter's background?!

To enable background image syncing with the dms greeter, run the
following from your terminal and follow the steps:

```
dms greeter sync
```
I would like to automate this in future but I'm simply not smart or patient
enough to do it at the moment.

### Matugen isn't themeing my flatpak apps!

Matugen can theme flatpaks by running the following (restart any running apps):

```
sudo flatpak override \
--filesystem=xdg-config/gtk-3.0:rw \
--filesystem=xdg-config/gtkrc-2.0:rw \
--filesystem=xdg-config/gtk-4.0:rw \
--filesystem=xdg-config/gtkrc:rw
```

### The capslock indicator widget doesn't work!

You have to add yourself to the `input` group like this, and then reboot.

```
ujust add-user-to-input-group
```

## Credits:

- https://bazzite.gg/
- https://duxlabs.dev/
- https://github.com/niri-wm/niri
- https://github.com/bazzirco/bazzirco (for the dux-greeter workaround)
- https://tsuburaya-prod.com/ (for Ultraman, the inspiration behind the name of this image)
- https://zone108.main.jp/s/jp-005gontakana.php<br>FZゴンタかな is licensed under the [SIL Open Font License, Version 1.1](https://github.com/irunatbullets/spacium/blob/5ce3fb4974ead6809fc2b79f841c56f48572e577/assets/licenses/FZ%E3%82%B3%E3%82%99%E3%83%B3%E3%82%BF%E3%81%8B%E3%81%AA-OFL-1.1.md).

## Legal Notice

This project is NOT affiliated with Bazzite, Dux Labs, Niri or Tsuburaya.

The software is developed independently and provided as-is, without warranties of any kind. Use at your own risk.

