{ config, pkgs, ... }:

{
  ######################################################################
  #                Importation de la configuration matérielle          #
  ######################################################################
  imports =
    [
      ./hardware-configuration.nix
      # Importation externe des paramètres liés aux profils d'alimentation.
      # Le fichier energie.nix contient toute la configuration relative aux scripts et menus
      # pour la gestion du choix d'alimentation (sélection, affichage, icône, etc).
      ./energie.nix
    ];

  ######################################################################
  #              Configuration Générale du Système                     #
  ######################################################################
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  system.stateVersion = "24.11";
  services.nscd.enable = true;

  ######################################################################
  #                Optimisations Nix et Garbage Collection             #
  ######################################################################
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  ######################################################################
  #                   Mises à Jour Automatiques                        #
  ######################################################################
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    dates = "04:00";
    flags = [
      "--no-build-output"
      "--delete-older-than 30d"
    ];
  };

  ######################################################################
  #         Configuration du Boot et du Noyau (Kernel)                 #
  ######################################################################
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-intel" ];
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options iwlwifi power_save=1
    '';
    kernelParams = [
      "intel_pstate=passive"
      "i915.enable_fbc=1"
      "i915.enable_psr=2"
      "i915.enable_guc=2"
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "psmouse.synaptics_intertouch=1"
      "i8042.nopnp=1"
      "i8042.dumbkbd=1"
    ];
    loader = {
      systemd-boot.enable = true;
      timeout = 3;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 40;
      "kernel.nmi_watchdog" = 0;
      "vm.dirty_writeback_centisecs" = 6000;
      "kernel.audit_backlog_limit" = 65536;
    };
  };

  ######################################################################
  #          Gestion de la Mémoire et du Swap (ZramSwap, EarlyOOM)      #
  ######################################################################
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 2;
    freeSwapThreshold = 5;
  };

  ######################################################################
  #             Gestion de l'Alimentation et TLP                        #
  ######################################################################
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  ######################################################################
  #      Configuration de TLP : gestion des profils d'alimentation     #
  ######################################################################
  services.tlp = {
    enable = true;
    settings = {
      # Configuration pour le branchement sur secteur
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;              # Définition unique de CPU_MIN_PERF_ON_AC
      CPU_MAX_PERF_ON_AC = 100;            # Définition unique de CPU_MAX_PERF_ON_AC

      # Configuration pour le fonctionnement sur batterie
      PCIE_ASPM_ON_BAT = "powersupersave";
      RUNTIME_PM_ON_BAT = "auto";
      WIFI_PWR_ON_BAT = "on";
      RUNTIME_PM_DRIVER_BLACKLIST = "mei_me";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      START_CHARGE_THRESH_BAT0 = 80;
      STOP_CHARGE_THRESH_BAT0 = 85;
    };
  };

  ######################################################################
  #                Services de Gestion Thermique                       #
  ######################################################################
  services.thermald = {
    enable = true;
    configFile = pkgs.writeText "thermal-conf.xml" ''
      <?xml version="1.0"?>
      <ThermalConfiguration>
        <ThermalZones>
          <ThermalZone>
            <Type>cpu</Type>
            <TripPoints>
              <TripPoint>
                <SensorType>x86_pkg_temp</SensorType>
                <Temperature>75000</Temperature>
                <type>passive</type>
                <ControlType>SEQUENTIAL</ControlType>
                <CoolingDevice>
                  <index>1</index>
                  <type>rapl_controller</type>
                  <influence>100</influence>
                  <SamplingPeriod>5</SamplingPeriod>
                </CoolingDevice>
              </TripPoint>
            </TripPoints>
          </ThermalZone>
        </ThermalZones>
      </ThermalConfiguration>
    '';
  };

  services.thinkfan = {
    enable = true;
    sensors = [
      { type = "tpacpi"; query = "/proc/acpi/ibm/thermal"; }
    ];
    levels = [
      [0 0 55]
      [1 50 60]
      [2 55 65]
      [3 60 70]
      [4 65 75]
      [5 70 80]
      [7 75 32767]
    ];
  };

  services.throttled.enable = true;
  services.power-profiles-daemon.enable = false;

  ######################################################################
  #               Maintenance du Stockage (fstrim)                     #
  ######################################################################
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  ######################################################################
  #          Internationalisation et Paramètres Régionaux              #
  ######################################################################
  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "fr_CH.UTF-8";
  console.keyMap = "fr_CH";

  ######################################################################
  #           Configuration de l'Environnement Graphique (X11)           #
  ######################################################################
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
    xkb = {
      layout = "ch";
      variant = "fr";
    };
  };

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  ######################################################################
  #                Configuration des Périphériques d'Entrée              #
  ######################################################################
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      disableWhileTyping = true;
      accelSpeed = "0.3";
      accelProfile = "adaptive";
    };
  };

  ######################################################################
  #           Configuration Graphique, Accélération Matérielle           #
  ######################################################################
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  environment.sessionVariables = {
    LIBGL_DRI3_DISABLE = "1";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    VDPAU_DRIVER = "va_gl";
  };

  ######################################################################
  #                Configuration Audio et Multimedia                     #
  ######################################################################
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  ######################################################################
  #                Configuration Bluetooth et Wireless                   #
  ######################################################################
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez5-experimental;
    settings = {
      General = {
        Experimental = true;
        KernelExperimental = true;
      };
    };
  };
  services.blueman.enable = true;

  ######################################################################
  #              Gestion des Utilisateurs et Groupes                     #
  ######################################################################
  users.users.moi = {
    isNormalUser = true;
    description = "moi";
    extraGroups = [ "networkmanager" "wheel" "sensors" ];
    packages = with pkgs; [];
  };

  ######################################################################
  #                Sécurité, Sudo et Audit du Système                     #
  ######################################################################
  security = {
    sudo.wheelNeedsPassword = true;
    pam.services.sudo.showMotd = true;
    audit = {
      enable = true;
      backlogLimit = 65536;
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };
  };
  environment.etc."audit/auditd.conf".text = ''
  #  space_left = 75
  #  space_left_action = SYSLOG
  #  admin_space_left = 50
  #  admin_space_left_action = SUSPEND
  #  disk_full_action = SUSPEND
  #  disk_error_action = SUSPEND
  #  max_log_rate = 1000
  '';

  services.printing.enable = true;

  ######################################################################
  #                Virtualisation et Réseaux (Libvirt)                    #
  ######################################################################
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu = {
      package = pkgs.qemu_full;
      runAsRoot = true;
      ovmf.enable = true;
      swtpm.enable = true;
    };
  };
  systemd.services.libvirt-default-network = {
    description = "Libvirt Default Network Autostart";
    wantedBy = [ "multi-user.target" ];
    requires = [ "libvirtd.service" ];
    after = [ "libvirtd.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      if ! ${pkgs.libvirt}/bin/virsh net-info default >/dev/null 2>&1; then
        ${pkgs.libvirt}/bin/virsh net-define ${pkgs.writeText "default-network.xml" ''
          <network>
            <name>default</name>
            <bridge name="virbr0"/>
            <forward mode="nat"/>
            <ip address="192.168.122.1" netmask="255.255.255.0">
              <dhcp>
                <range start="192.168.122.2" end="192.168.122.254"/>
              </dhcp>
            </ip>
          </network>
        ''}
      fi
      ${pkgs.libvirt}/bin/virsh net-autostart default
      ${pkgs.libvirt}/bin/virsh net-start default || true
    '';
  };

  ######################################################################
  #     Fin de la configuration principale (gestion d'alimentation      #
  #     externalisée dans energie.nix pour garder ce fichier propre)     #
  ######################################################################
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    yad
    xfce.xfce4-genmon-plugin
    libnotify
    acpi

    dropbox
    libreoffice-fresh
    thunderbird-latest
    kdePackages.kate
    brave
    vlc

    thermald
    acpi
    lm_sensors
    smartmontools
    hdparm
    nvme-cli

    qemu_full
    virt-manager

    file-roller
    preload
    blueman
    fastfetch
    htop
    btop
    angryipscanner
    bleachbit
    alpaca

    powertop
    bluez
    bluez-tools

    whitesur-icon-theme
    whitesur-gtk-theme
    whitesur-cursors
  ];
}
