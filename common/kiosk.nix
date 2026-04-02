{ pkgs, ... }:

{
  # Grafik-Support
  hardware.graphics.enable = true;

  # Kiosk-User anlegen
  users.users.kiosk = {
    isNormalUser = true;
    extraGroups = [ "video" ];
  };

  # Autologin auf tty1 (damit Cage sofort startet)
  services.getty.autologinUser = "kiosk";

  services.cage = {
    enable = true;
    user = "kiosk";
    # Umgebungsvariable für Software-Rendering in VMs hinzufügen
    extraArguments = [ "-s" ]; 
    program = "${pkgs.firefox}/bin/firefox --kiosk https://nixos.org";
  };

  # WICHTIG für VMware: Gast-Erweiterungen aktivieren
  virtualisation.vmware.guest.enable = true;

  environment.systemPackages = [ pkgs.firefox ];
}