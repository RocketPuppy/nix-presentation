# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Boot parameters
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.kernelPackages = pkgs.linuxPackages_4_3;

  # Networking configuration
  networking.hostId = "77cda1d9";
  networking.wireless.enable = true;  # Enables wireless.
  networking.extraHosts = ''
    127.0.0.1 daniel.local
    192.168.1.157 daniel.home
    10.0.3.152 daniel.forreal
  '';
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 3000 8080 ];
    allowedUDPPorts = [ 3000 8080 ];
  };

  hardware.pulseaudio.enable = true;

  # Package manager config
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;

    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
      enableWideVine = true;
    };
  };

  # Packages installed for all users
  environment.systemPackages = with pkgs; [
    acpi
    haskellPackages.xmonad
    dmenu
    xlibs.xbacklight
    lsof
    pavucontrol
    openssl
    cacert
    xlibs.xrandr
    xlsfonts
  ];

  programs.bash.enableCompletion = true;

  # Services
  # cron
  services.cron = {
    enable = true;
    cronFiles = [];
    mailto = "wilsonhardrock@gmail.com";
  };

  # redshift
  services.redshift = {
    enable = true;
    # Providence, RI
    latitude = "41.8236";
    longitude = "-71.4222";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    windowManager.xmonad.extraPackages = self: [ self.xmonad-contrib self.xmonad-extras self.X11 pkgs.acpi pkgs.xorg.xbacklight];
    windowManager.default = "xmonad";
    desktopManager.xterm.enable = false;
    desktopManager.default = "none";
    displayManager = {
      slim = {
        enable = true;
        defaultUser = "dwilson";
      };
    };
  };

  services.nixosManual.showManual = true;

  services.devmon.enable = true;
  services.mysql.enable = false;
  services.redis.enable = true;
  services.neo4j.enable = true;
  services.virtualboxHost.enable = true;

  time.timeZone = "America/New_York";

  # Users
  users.extraUsers.dwilson = {
    isNormalUser = true;
    home = "/home/dwilson";
    extraGroups = [ "wheel" "networkmanager" "audio" ];
  };
  users.extraUsers.guest = {
    isNormalUser = true;
    uid = 1000;
  };
  users.extraGroups.vboxusers.members = [ "dwilson" ];

  # fonts
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
    ];
  };

  # extra binary caches
  nix.trustedBinaryCaches = [
    "https://nixcache.reflex-frp.org"
    "http://nix-cache.danielwilsonthomas.com"
  ];
  nix.binaryCachePublicKeys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    "nix-cache.danielwilsonthomas.com-1:QM4lCC4Z8uywH15CMs0Rt+0EvuqGL1kqxBFritTwIMY="
  ];
}
