# Virtualisation KVM/QEMU et conteneurs
{ config, pkgs, lib, ... }:

{
  # KVM/QEMU pour machines virtuelles
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };

    # Conteneurs avec Podman
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Packages de virtualisation
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    qemu
  ];
}
