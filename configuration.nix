# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.

  # Ensure the system can use the swap file
  boot.initrd.availableKernelModules = [ "loop" ];
  boot.kernel.sysctl = {
    "vm.swappiness" = 10; # Optional: Adjust swappiness
  };
  boot.kernelParams = [ "resume=/swapfile" ];

  # Optional: if you have a specific swap partition for hibernation
  swapDevices = [
    {
      device = "/swapfile";
      size = 32000;
    }
  ]; 

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "t14"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  services.flatpak.enable = true;

  # Onedrive https://nixos.wiki/wiki/OneDrive
  #services.onedrive.enable =true;

  # Docker
  #virtualisation.docker.enable = true;
  # all users
  #users.extraGroups = [ "docker" ];
  # For individual users just add docker group.
  # Podman
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };


  # VirtualBox
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.guest.x11 = true;

  # KVM
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["mm"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  #boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  boot.kernelModules = [ "kvm-intel" ];

  # Printing
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.cnijfilter2 ];  # Canon LBP3010 driver

#  systemd.services.ccpd = {
#    description = "Canon CAPT Printer Daemon";
#    serviceConfig = {
#      ExecStart = "${pkgs.bash}/bin/bash -c 'LD_LIBRARY_PATH=${pkgs.cups.lib}/lib /home/mm/bin/64-bit_Driver/RPM/usr/sbin/ccpd'";
#      Restart = "always";
#    };
#    wantedBy = [ "multi-user.target" ];
#  };

  # Battery mgmt
  services.power-profiles-daemon.enable = true;
  #services.power-profiles-daemon.enable = false;  # disabling since conflicting with TLP
  #services.tlp.enable = true;
  #services.tlp = {
  #      enable = true;
  #      settings = {
  #        CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #        CPU_MIN_PERF_ON_AC = 0;
  #        CPU_MAX_PERF_ON_AC = 100;
  #        CPU_MIN_PERF_ON_BAT = 0;
  #        CPU_MAX_PERF_ON_BAT = 20;
  #        #Optional helps save long term battery health
  #        START_CHARGE_THRESH_BAT0 = 60; # 60 and bellow it starts to charge
  #        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
  #      };
  #};



  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Workaround while auto-login is not working (trying to get there twice)
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # GNOME configuration for hibernation
  # Correct way to apply custom session commands
  environment.etc."profile.d/enable-hibernation.sh".text = ''
    #!/bin/sh
    # Command to enable hibernation in the GNOME menu
    gsettings set org.gnome.settings-daemon.plugins.power button-hibernate 'hibernate'
    gsettings set org.gnome.settings-daemon.plugins.power critical-battery-action 'hibernate'
  '';

  # Ensure this script is executable
  environment.etc."profile.d/enable-hibernation.sh".mode = "0755";

  services.sshd.enable = true;

  # Configure keymap in X11
  #services.xserver = {
  #  layout = "us,lt";
  #  xkbVariant = "";
  #  xkbOptions = "grp:win_space_toggle";
  #};
  #console.keyMap = "us";

  # Enable sound with pipewire.
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.groups = {
    mlocate = {};
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mm = {
    isNormalUser = true;
    description = "mm";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" "lp" ];
    #packages = with pkgs; [
    #];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCb/yK1rWkQ60d08ZP09i45xfcoydEirtgZuHvGZVtH4wLKdoniSMlsHTUPB77dauPkguamgh1PHz/D+XVcQIlm1dVSqPXYriz2iWYg57evUX9xog5OGQPWnY65pPfsuEOBhvDOXSzeaAhR2xps7H1AX63vDZh9OLWpAdoDpHq/ZezGMplNPvMcBeIt4DkaIflj9JcMwWl7enSG2GnaU1kLE3+E2elKfyNhTe7ydr2Wkp+qNsNHcUMxpheRW/D4Dt842tf1gSoUx/RF1N8Beva22YblckkVVKJ/Nxub0aEL9qS2xbXi7QxSbdA37TjMt0PluuRrbU+3Sm71fFi91ecn75QOdvkfF29hERWdQj5RVmTqpYUgLnpgABFVJtZ+V2yNjNf13GOSpbBkHBWtWfik2Y8XmaPwVQmNBgNgQO8Cl7f7bQ8wqVNKlfyV9v//fHHeIPTRXqVHYZnFYckfq44u9lryENUNaO0NIzRjMJfapl9bq0zNQEeg4A/DTZSOLo7oKuzUlG2Metg3yxfZVGTb+ZPjkAkOxrBnnGdlymSfLxTAMAyhJUJjTJpRidqkAjQvHFFwn3vdudOXhVpaN4aE6k1Rcf4OmxfQAaN/qpTRVS5q/Og9yclXOWYoj1JYjT3VhRf1Z9ScYGhePX8PRv6WbXn6OcatFal43AIhPPW+UQ==" ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    #"openssl-1.1.1w"
    "dotnet-core-combined"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    keepassxc
    brave
    go
    python3
    ruby
    zip
    remmina
    filezilla
    git
    telegram-desktop
    whatsapp-for-linux
    vlc
    gimp
    slack
    awscli
    google-cloud-sdk
    openvpn
    qbittorrent
    vscode
    ruby
    bundler
    opentofu
    terraform
    packer
    ntfs3g
    libreoffice
    nmap
    gnomeExtensions.dash-to-dock
    gnome-tweaks
    gnome-shell-extensions
    gnome-pomodoro
    networkmanager-openvpn
    #discord
    gcc
    autoconf
    automake
    libtool
    gnumake
    google-chrome
    vivaldi
    kubectl
    argocd
    gparted
    #nextcloud-client
    mlocate
    okular
    #zsh
    yubikey-manager
    yubioath-flutter
    pcsclite
    dnsutils
    azure-cli
    tmux
    terminator
    #vulnix
    xz
    unzip
    unrar
    appimage-run
    podman-desktop
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    #podman-compose # start group of containers for dev
    firmwareLinuxNonfree
    evolution
    cups
  ];

  services.udev.packages = [ pkgs.yubikey-personalization pkgs.cnijfilter2  ];
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.appimage.binfmt = true;


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 2222 ];

  # Needed for yubikey usage
  services.pcscd.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 2222 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
 

  # Auto upgrades
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-24.05";

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    dates = "daily";
    options = "--delete-older-than 20d  --keep-going 3 ";
  };

#  systemd.tmpfiles.rules = [
#    "d /home/mm/.config/onedrive 0755 mm mm -"
#    "f /home/mm/.config/onedrive/sync_list 0644 mm mm - - keepass\nstatybu_projektai\nInstrukcijos"
#  ];

}

