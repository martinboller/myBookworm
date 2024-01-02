# myBookworm
Install some basics on Debian 12 Bookworm

### Design principles:
  - Controlled by .env file
  - Installs and configures flatpak + the Debian contrib and non-free repositories
  - Installs some flatpak utils, including BitWarden and VSCodium
  - Installs some Networking, Forensics, Development, and System utilities

## Latest changes ##

### 2024-01-02 - Dash to panel ###
 - Installing the Dash-to-Panel Gnome Extension
 - Adding minimize and maximize buttons to windows
 
### 2024-01-01 - Initial version ###
- Adds the currently logged on user to the sudo group (if necessary)
- Installing Flatpak, Gnome Software Flatpak plugin, and adds flathub repository.
- Installs flatpaks: VS-Codium; BitWarden; Calibre; UngoogledChromium; UngoogledChromium-Codecs; Mattermost; Discord; FluentReader; Signal.
- Several Debian APT-packages in the following categories: Network Tools, Forensics Tools, Systems Tools, and User Tools.
- Adds the contrib, non-free, and firmware-non-free debian repositories.
- Keyboard shortcuts for gnome-terminal (Super + t) and gnome-disks (Super + d)
