#!/bin/bash

#####################################################################
#                                                                   #
# Author:       Martin Boller                                       #
#                                                                   #
# Email:        martin@bollers.dk                                   #
# Last Update:  2023-12-30                                          #
# Version:      1.00                                                #
#                                                                   #
# Changes:  Tested on Debian 12 (Bookworm)                          #
#                                                                   #
#####################################################################

do_intro() {
    /usr/bin/logger 'do_intro()' -t 'Customizing Bookworm';
    echo -e '\e[32m   ___          _                '  _     _
    echo -e '\e[32m / ___|   _ ___| |_ ___  _ __ ___ (_)___(_)_ __   __ _  '
    echo -e '\e[32m| |  | | | / __| __/ _ \| ´_ ` _ \| |_  / | ´_ \ / _` | '
    echo -e '\e[32m| |__| |_| \__ \ || (_) | | | | | | |/ /| | | | | (_| | '
    echo -e '\e[32m \____\__,_|___/\__\___/|_| |_| |_|_/___|_|_| |_|\__, | '
    echo -e '\e[32m| __ )  ___   ___ | | ____      _____  _ __ _ __ |___/  '
    echo -e '\e[32m|  _ \ / _ \ / _ \| |/ /\ \ /\ / / _ \| ´__| ´_ ` _ \   '
    echo -e '\e[32m| |_) | (_) | (_) |   <  \ V  V / (_) | |  | | | | | |  '
    echo -e '\e[32m|____/ \___/ \___/|_|\_\  \_/\_/ \___/|_|  |_| |_| |_|  '
    echo -e
    /usr/bin/logger 'do_intro() finished' -t 'Customizing Bookworm';
}

do_outro() {
    /usr/bin/logger 'do_outro()' -t 'Customizing Bookworm';
    echo -e '\e[32m  ____          _                  _          _   _              '
    echo -e '\e[32m / ___|   _ ___| |_ ___  _ __ ___ (_)______ _| |_(_) ___  _ __   '
    echo -e '\e[32m| |  | | | / __| __/ _ \| ´_ ` _ \| |_  / _` | __| |/ _ \| ´_ \  '
    echo -e '\e[32m| |__| |_| \__ \ || (_) | | | | | | |/ / (_| | |_| | (_) | | | | '
    echo -e '\e[32m \____\__,_|___/\__\___/|_|_|_| |_|_/___\__,_|\__|_|\___/|_| |_| '
    echo -e '\e[32m             |  ___(_)_ __ (_)___| |__   ___  __| |              '
    echo -e '\e[32m             | |_  | | ´_ \| / __| ´_ \ / _ \/ _` |              ' 
    echo -e '\e[32m             |  _| | | | | | \__ \ | | |  __/ (_| |              '
    echo -e '\e[32m             |_|   |_|_| |_|_|___/_| |_|\___|\__,_|              '
    echo -e
    /usr/bin/logger 'do_outro() finished' -t 'Customizing Bookworm';
}

configure_env() {
    echo -e "\e[32m - configure_env()\e[0m";
    /usr/bin/logger 'configure_env()' -t 'Customizing Bookworm';

    # Remember to change settings in the .env file.
    # Directory of script
    export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    
    # Configure environment from .env file
    set -a; source $SCRIPT_DIR/.env;
    echo -e "\e[1;35m-------------------------------------------------------------------\e[0m"
    echo -e "\e[1;35menv file version $ENV_VERSION\e[0m"
    echo -e
    echo -e "\e[1;35mAdding contrib and non-free repositories? $APT_CONFIGURE\e[0m"
    echo -e "\e[1;35mInstalling latest updates from Debian? $UPDATES_INSTALL\e[0m"
    echo -e "\e[1;35mConfiguration of Linux? $NIX_CONFIGURE\e[0m"
    echo -e "\e[1;35mInstall Flatpak? $FLATPAK_INSTALL\e[0m"
    echo -e "\e[1;35mInstall Flatpak Utilities $FLATPAK_UTILS\e[0m"
    echo -e "\e[1;35mInstall Debian Packages? $APT_UTILS\e[0m"
    echo -e "\e[1;35mConfigure Minimize and Maximize buttons on Windows? $MM_BUTTONS_CONFIGURE\e[0m"
    echo -e "\e[1;35m-------------------------------------------------------------------\e[0m"
    
    # OS Version freedesktop.org and systemd
    . /etc/os-release
    export OS=$NAME
    export VER=$VERSION_ID
    export CODENAME=$VERSION_CODENAME
    /usr/bin/logger "Operating System: $OS Version: $VER: $CODENAME" -t 'gce-23.1.0';
    echo -e "\e[1;36m .... Operating System: $OS Version: $VER: $CODENAME\e[0m";
    echo -e "\e[32m .... Environment configured\e[0m";

    if [ "$VER" == "$DEBIAN_SUPPORTED" ]; then
        echo -e "\e[1;36m....Running Debian $VER codename $CODENAME. All good to go\e[0m"
    else
        echo -e "\e[1;31m  .... NOT running Debian $DEBIAN_SUPPORTED, but $OS, $VER codename $CODENAME. Script shall exit\e[0m"
        exit 1;
    fi

    echo -e "\e[32m - configure_env() finished\e[0m";
    /usr/bin/logger 'configure_env() finished' -t 'Customizing Bookworm';
}

install_updates() {
    echo -e "\e[32m - install_updates()\e[0m";
    /usr/bin/logger 'install_updates()' -t 'Customizing Bookworm';
    
    export DEBIAN_FRONTEND=noninteractive;
    sync
    echo -e "\e[36m .... update\e[0m" && sudo apt-get -qq update > /dev/null 2>&1
    echo -e "\e[36m .... full-upgrade\e[0m" && sudo apt-get -qq -y full-upgrade > /dev/null 2>&1
    echo -e "\e[36m .... cleaning up apt\e[0m";
    echo -e "\e[36m .... autoremove\e[0m" && sudo apt-get -qq -y --purge autoremove > /dev/null 2>&1
    echo -e "\e[36m .... autoclean\e[0m" && sudo apt-get -qq autoclean > /dev/null 2>&1
    echo -e "\e[36m .... Done\e[0m" > /dev/null 2>&1
    sync;
    
    echo -e "\e[32m - install_updates() finished\e[0m";
    /usr/bin/logger 'install_updates() finished' -t 'Customizing Bookworm';
}

install_utils_apt() {
    echo -e "\e[32m - install_utils_apt()\e[0m";
    /usr/bin/logger 'install_utils_apt()' -t 'Customizing Bookworm';

    export DEBIAN_FRONTEND=noninteractive;
    echo -e "\e[32m .... Installing some additional tools and utilities\e[0m";
    echo -e "\e[32m .... Installing network tools\e[0m";
    sudo apt-get -y -qq install ipcalc-ng wireshark tcpdump nmap ncat ngrep ethtool aircrack-ng;
    echo -e "\e[32m .... Installing forensics tools\e[0m";
    sudo apt-get -y -qq install forensics-extra testdisk sleuthkit geoip-bin geoip-database geoipupdate binwalk;
    echo -e "\e[32m .... Installing system tools\e[0m";
    sudo apt-get -y -qq install gparted wget nano p7zip p7zip-full unzip dconf-editor htop;
    echo -e "\e[32m .... Installing user utils and other tools\e[0m";
    sudo apt-get -y -qq install curl transmission-gtk vlc ffmpeg libavcodec-extra default-jdk git sshpass rclone rclone-browser;

    echo -e "\e[32m - install_utils_apt() finished\e[0m";
    /usr/bin/logger 'install_utils_apt() finished' -t 'Customizing Bookworm';
}

install_flatpak() {
    echo -e "\e[32m - install_flatpak()\e[0m";
    /usr/bin/logger 'install_flatpak()' -t 'Customizing Bookworm';

    echo -e "\e[36m .... Installing flatpak and gnome software plugin\e[0m";
    sudo apt-get -qq -y install flatpak gnome-software-plugin-flatpak;
    echo -e "\e[36m .... Adding flathub repository\e[0m";
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    sync;
    
    echo -e "\e[32m - install_flatpak() finished\e[0m";
    /usr/bin/logger 'install_flatpak() finished' -t 'Customizing Bookworm';
}

install_utils_flatpak() {
    echo -e "\e[32m - install_utils_flatpak()\e[0m";
    /usr/bin/logger 'install_utils_flatpak()' -t 'Customizing Bookworm';

    echo -e "\e[36m .... Installing vs-codium\e[0m";
    flatpak --assumeyes install com.vscodium.codium > /dev/null 2>&1;
    echo -e "\e[36m .... installing BitWarden\e[0m";
    flatpak --assumeyes install com.bitwarden.desktop > /dev/null 2>&1;
    echo -e "\e[36m .... installing Calibre\e[0m";
    flatpak --assumeyes install com.calibre_ebook.calibre > /dev/null 2>&1;
    echo -e "\e[36m .... installing ungoogled Chromium\e[0m";
    flatpak --assumeyes install com.github.Eloston.UngoogledChromium > /dev/null 2>&1;
    echo -e "\e[36m .... installing Codecs for Chromium\e[0m";
    flatpak --assumeyes install com.github.Eloston.UngoogledChromium.Codecs > /dev/null 2>&1;
    echo -e "\e[36m .... installing Mattermost\e[0m";
    flatpak --assumeyes install com.mattermost.Desktop > /dev/null 2>&1;
    echo -e "\e[36m .... installing Discord\e[0m";
    flatpak --assumeyes install com.discordapp.Discord > /dev/null 2>&1;
    echo -e "\e[36m .... installing Fluent Reader\e[0m";
    flatpak --assumeyes install me.hyliu.fluentreader > /dev/null 2>&1;
    echo -e "\e[36m .... installing Signal Desktop\e[0m";
    flatpak --assumeyes install org.signal.Signal > /dev/null 2>&1;

    echo -e "\e[32m - install_utils_flatpak() finished\e[0m";
    /usr/bin/logger 'install_utils_flatpak() finished' -t 'Customizing Bookworm';
}

install_gnome_dash_to_panel() {
    echo -e "\e[32m - install_gnome_dash_to_panel()\e[0m";
    /usr/bin/logger 'install_gnome_dash_to_panel()' -t 'Customizing Bookworm';

    # Requires log out then logon
    sudo apt-get -y -qq install gnome-shell-extension-dash-to-panel;

    echo -e "\e[32m - install_gnome_dash_to_panel() finished\e[0m";
    /usr/bin/logger 'install_gnome_dash_to_panel() finished' -t 'Customizing Bookworm';
}

configure_nix() {
    echo -e "\e[32m - configure_nix()\e[0m";
    /usr/bin/logger 'configure_nix()' -t 'Customizing Bookworm';

    # Currently nothing to do

    echo -e "\e[32m - configure_nix() finished\e[0m";
    /usr/bin/logger 'configure_nix() finished' -t 'Customizing Bookworm';
}

configure_sudo() {
    echo -e "\e[32m - configure_sudo()\e[0m";
    /usr/bin/logger 'configure_sudo()' -t 'Customizing Bookworm';
    
    su root /sbin/addgroup $USERNAME sudo
    
    echo -e "\e[32m - configure_sudo() finished\e[0m";
    /usr/bin/logger 'configure_sudo() finished' -t 'Customizing Bookworm';
}

configure_apt_repositories() {
    echo -e "\e[32m - configure_apt_repositories()\e[0m";
    /usr/bin/logger 'configure_apt_respositories()' -t 'Customizing Bookworm';

    echo -e "\e[32m .... adding contrib, non-free, and non-free-firmware repositories to sources.list\e[0m";
    sudo sed -ie "s/main/main contrib non-free non-free-firmware/" /etc/apt/sources.list
    sudo apt-get -qq update;
    
    echo -e "\e[32m - configure_apt_repositories() finished\e[0m";
    /usr/bin/logger 'configure_apt_respositories() finished' -t 'Customizing Bookworm';
}

configure_kb_shortcuts() {
    echo -e "\e[32m - configure_kb_sortcuts()\e[0m";
    /usr/bin/logger 'configure_kb_shortcuts()' -t 'Customizing Bookworm';

    # Create custom keybindings myTerminal and myDisks
    echo -e "\e[32m .... Create custom keybindings\e[0m";
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/myTerminal/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/myDisks/']"
    echo -e "\e[32m .... Provide a name for the custom key myTerminal\e[0m";
    # Provide a name for the custom key myTerminal
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/myTerminal/ name 'Gnome-Term'
    echo -e "\e[32m .... set keyboard combo to <Super> + t\e[0m";
    # set keyboard combo to <Super> + t
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/myTerminal/ binding '<super>t'
    echo -e "\e[32m .... set gnome-terminal as command to run\e[0m";
    # set command to run
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/myTerminal/ command '/usr/bin/gnome-terminal'
    echo -e "\e[32m .... Provide a name for the custom key myDisks\e[0m";
    # Provide a name for the custom key myDisks
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/myDisks/ name 'Gnome-Disks'
    echo -e "\e[32m .... set keyboard combo to <Super> + d\e[0m";
    # set keyboard combo to <Super> + d
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/myDisks/ binding '<super>d'
    echo -e "\e[32m .... set gnome-disks as command to run\e[0m";
    # set command to run
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/myDisks/ command '/usr/bin/gnome-disks'
    
    echo -e "\e[32m - configure_kb_sortcuts()\e[0m";
    /usr/bin/logger 'configure_kb_shortcuts()' -t 'Customizing Bookworm';
}

configure_min_max_buttons() {
    echo -e "\e[32m - configure_min_max_buttons()\e[0m";
    /usr/bin/logger 'configure_min_max_buttons()' -t 'Customizing Bookworm';

    gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

    echo -e "\e[32m - configure_min_max_buttons() finished\e[0m";
    /usr/bin/logger 'configure_min_max_buttons() finished' -t 'Customizing Bookworm';
}

#################################################################################################################
## Main Routine                                                                                                 #
#################################################################################################################
main() {
    /usr/bin/logger 'main() routine starting' -t 'Customizing Bookworm';

    # Show intro message
    do_intro;

    # Configure variables from .env-file
    configure_env;

    if id -nG "$USERNAME" | grep -qw "$SUDOGROUP"; then
        echo -e "\e[32m - $USERNAME already  belongs to group: $SUDOGROUP, installation will continue using sudo\e[0m"

       # APT Repositories
        if [ "$APT_CONFIGURE" == "Yes" ]; then
          configure_nix;  
        fi

        # APT Repositories
        if [ "$APT_CONFIGURE" == "Yes" ]; then
            configure_apt_repositories;
        fi

        # Install updates from repositories
        if [ "$UPDATES_INSTALL" == "Yes" ]; then
            install_updates;
        fi

        # Flatpak
        if [ "$FLATPAK_INSTALL" == "Yes" ]; then
            install_flatpak;
            if [ "$FLATPAK_UTILS" == "Yes" ]; then
                install_utils_flatpak;
            fi
        fi

        # Debian APT packages
        if [ "$APT_UTILS" == "Yes" ]; then
            install_utils_apt;
        fi
        
        # Gnome Keyboard Shortcuts
        if [ "$KB_SHORTCUTS" == "Yes" ]; then
            configure_kb_shortcuts;
        fi

        # Gnome Dash to Panel Extension
        if [ "$DASH_TO_PANEL" == "Yes" ]; then
            install_gnome_dash_to_panel;
        fi

        # Gnome show minimize and maximize buttons
        if [ "$MM_BUTTONS_CONFIGURE" == "Yes" ]; then
            configure_min_max_buttons;
        fi

    # Cannot sudo
    else
        echo -e "\e[1;36m$USERNAME does not belong to group $SUDOGROUP, please provide root password\e[0m"
        configure_sudo;
        echo -e "\e[1;31mYou must logout and then back in again and execute this script once more\e[0m"
    fi

    # Show finishing message
    do_outro;

    /usr/bin/logger 'main() finished' -t 'Customizing Bookworm';
}

main

exit 0
