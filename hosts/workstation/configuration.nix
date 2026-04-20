# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/core/fcitx5
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.extraHosts =
    ''
      192.168.1.167 homelab

      127.0.0.1 www.chzzk.naver.com
      127.0.0.1 www.youtube.com
    '';


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocales = [ "ko_KR.UTF-8/UTF-8" ];

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      nanum
    ];
    fontconfig.defaultFonts = {
      serif = [ "NanumMyeongjo" ]; # "Noto Serif CJK KR"
      sansSerif = [ "NanumGothic" ]; # "Noto Sans CJK KR"
      monospace = [ "JetBrainsMono Nerd Font Mono" ]; # "NanumgothicCoding"
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    jack.enable = true;
    alsa.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "50-disable-audio-devices" = {
          "monitor.alsa.rules" = [
            {
              "matches" = [
                {
                  "device.name" = "alsa_card.pci-0000_03_00.1";
                }
                {
                  "device.name" = "alsa_card.usb-Sonix_Technology_Co.__Ltd._Logi_C270_HD_WebCam_Logi_C270_HD_WebCam-02";
                }
              ];
              "actions" = {
                "update-props" = {
                  "device.disabled" = true;
                };
              };
            }
          ];
        };
        
      };
    };
    extraConfig.pipewire."90-virtual-device" = {
      "context.modules" = [
        {
          "name" = "libpipewire-module-loopback";
          "args" = {
            "node.description" = "Scarlett 2i2 Mic";
            "capture.props" = {
              "node.name" = "capture.Scarlett 2i2 Mic";
              "node.role" = "Communication";
              "audio.position" = [ "FL" ];
              "stream.dont-remix" = true;
              "target.object" = "alsa_card.pci-0000_03_00.1";
              "node.passive" = true;
            };
            "playback.props" = {
              "node.name" = "Scarlett 2i2 Mic";
              "media.class" = "Audio/Source";
              "audio.position" = [ "MONO" ];
            };
          };
        }
      ];
    };
    # pulse.enable = true;
    # extraConfig.pipewire."92-low-latency" = {
    #   "context.properties" = {
    #     "default.clock.rate" = 48000;
    #     "default.clock.quantum" = 32;
    #     "default.clock.min-quantum" = 32;
    #     "default.clock.max-quantum" = 32;
    #   };
    # };
  };

  services.tailscale.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jun2040 = {
    isNormalUser = true;
    description = "Junwoo Baek";
    extraGroups = [ "networkmanager" "wheel" "jackaudio" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = [
    pkgs.neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    pkgs.home-manager
  #   wget
    pkgs.qpwgraph
  ];

  programs.git.enable = true;
  
  programs.hyprland.enable = true;

  programs.noisetorch.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

