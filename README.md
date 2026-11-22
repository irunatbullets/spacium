<br><br><br>
<p align=center>
  <img src="assets/spacium.svg" alt="Spacium" width="478">
</p>
<br><br>

# Spacium

<p>
  <a href="https://github.com/irunatbullets/spacium/actions/workflows/update-image.yml"><img src="https://github.com/irunatbullets/spacium/actions/workflows/update-image.yml/badge.svg" alt="Update image"></a> <a href="https://github.com/irunatbullets/spacium"><img src="https://img.shields.io/github/last-commit/irunatbullets/spacium" alt="Last Commit"></a>
</p>

# Spacium

[Update image](https://github.com/irunatbullets/spacium/actions/workflows/update-image.yml) ([![Update image](https://github.com/irunatbullets/spacium/actions/workflows/update-image.yml/badge.svg)](https://github.com/irunatbullets/spacium/actions/workflows/update-image.yml)) [Last Commit](https://github.com/irunatbullets/spacium) ([![Last Commit](https://img.shields.io/github/last-commit/irunatbullets/spacium)](https://github.com/irunatbullets/spacium))

> [!NOTE]
> I've recently switched from `quickshell` to Dux Labs' own `dux-qt-base`, which is more up-to-date. The only migration step that may be required is reapplying your desktop theme.

This custom **Bazzite** image is based on `bazzite-gnome`, with variants for the Nvidia open driver and Nouveau.

It includes **Dux Modular Shell (DMS)** and **niri**, along with the recommended extras for DMS.

My goal is to offer a vanilla DMS/niri experience with gaming capabilities (via Bazzite). I've added **Ghostty** as the default terminal, along with tools to allow developers to create their own DMS plugins.

Feel free to suggest additional software, or just fork this repository and do whatever you like.

## Installation

To switch, run one of the following commands from a terminal in any Universal Blue or Fedora Atomic-based installation.

Choose the image based on your GPU:

**AMD / Intel / default:**

```bash
sudo bootc switch ghcr.io/irunatbullets/spacium
```

**Nvidia:**

```bash
sudo bootc switch ghcr.io/irunatbullets/spacium-nvidia
```

**Legacy Nvidia / Nouveau:**

```bash
sudo bootc switch ghcr.io/irunatbullets/spacium-nouveau
```

### Important note about Niri configuration

After switching to this image, the login process will back up any existing Niri configuration and replace it with the standard DMS Niri configuration.

Updates will not trigger this event again.

## Additional applications

A few applications included in Spacium:

- **Ghostty** – My preferred terminal since moving to DMS.
- **BlueTUI** – A terminal application for configuring and managing Bluetooth devices.

## Notes and workarounds

### File manager: Nautilus and Dux Files

Spacium includes both **Nautilus (GNOME Files)** and **Dux Files (`dfiles`)**.

Nautilus is the default file manager. Dux Files is included as an alternative and can be used whenever preferred.

There is a small integration detail worth knowing: both applications register the same D-Bus service name, `org.freedesktop.FileManager1`.

To avoid conflicts, Spacium provides a higher-priority D-Bus service registration that launches Nautilus by default. This is separate from the XDG default application association.

#### Switching to Dux Files

If you prefer Dux Files, you can configure it as your personal file manager without modifying the system image.

Create a personal D-Bus service registration:

```bash
mkdir -p ~/.local/share/dbus-1/services

cat > ~/.local/share/dbus-1/services/org.freedesktop.FileManager1.service <<'EOF'
[D-BUS Service]
Name=org.freedesktop.FileManager1
Exec=/usr/bin/dfiles run --hidden --dbus-activated
EOF
```

Set Dux Files as your default directory handler:

```bash
xdg-mime default dev.duxlabs.files.desktop inode/directory
xdg-mime default dev.duxlabs.files.desktop x-directory/normal
```

Log out and back in for the D-Bus change to take effect.

#### Switching back to Nautilus

Remove your personal D-Bus override:

```bash
rm ~/.local/share/dbus-1/services/org.freedesktop.FileManager1.service
```

Restore the Nautilus MIME associations:

```bash
xdg-mime default org.gnome.Nautilus.desktop inode/directory
xdg-mime default org.gnome.Nautilus.desktop x-directory/normal
```

Log out and back in.

This arrangement allows users to choose their preferred file manager independently, without changing the system-wide defaults.

### Optional: Use Dux Files for file dialogs

Spacium uses the GTK file chooser by default.

If you prefer Dux Files for application file dialogs, you can switch to its XDG Desktop Portal integration.

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

To:

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

This changes the file chooser used by applications that support XDG Desktop Portals. It does **not** change your default file manager.

Your personal configuration takes precedence over Spacium's system-wide configuration, so this change will persist across image updates unless you remove your personal override.

For more information, see the [Dux Files documentation](https://duxlabs.dev/docs/dfiles).

### How do I change Dux Greeter's background?

To enable background image syncing with the DMS greeter, run the following from your terminal and follow the instructions:

```bash
dms greeter sync
```

I'd like to automate this in the future, but I'm simply not smart or patient enough to do it at the moment.

### Matugen isn't theming my Flatpak apps!

Matugen can theme Flatpak applications by running the following command (restart any running applications afterwards):

```bash
sudo flatpak override \
    --filesystem=xdg-config/gtk-3.0:rw \
    --filesystem=xdg-config/gtkrc-2.0:rw \
    --filesystem=xdg-config/gtk-4.0:rw \
    --filesystem=xdg-config/gtkrc:rw
```

### The Caps Lock indicator widget doesn't work!

You need to add yourself to the `input` group and then reboot:

```bash
ujust add-user-to-input-group
```

## Credits

- [Bazzite](https://bazzite.gg/)
- [Dux Labs](https://duxlabs.dev/)
- [Niri](https://github.com/niri-wm/niri)
- [Bazzirco](https://github.com/bazzirco/bazzirco) – For the Dux Greeter workaround.
- [Tsuburaya Productions](https://tsuburaya-prod.com/) – Ultraman, the inspiration behind the name of this image.
- [FZゴンタかな](https://zone108.main.jp/s/jp-005gontakana.php)

FZゴンタかな is licensed under the [SIL Open Font License, Version 1.1](https://github.com/irunatbullets/spacium/blob/5ce3fb4974ead6809fc2b79f841c56f48572e577/assets/licenses/FZ%E3%82%B3%E3%82%99%E3%83%B3%E3%82%BF%E3%81%8B%E3%81%AA-OFL-1.1.md).

## Legal notice

This project is **not affiliated** with Bazzite, Dux Labs, Niri or Tsuburaya.

The software is developed independently and provided as-is, without warranties of any kind. Use at your own risk.
