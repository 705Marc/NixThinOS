{ pkgs, ... }:

{
  # 1. Grafik & VMware Treiber
  hardware.graphics.enable = true;
  virtualisation.vmware.guest.enable = true;

  # 2. Kiosk-User mit allen nötigen Rechten
  users.users.kiosk = {
    isNormalUser = true;
    extraGroups = [ "video" "render" "input" ];
  };

  # 3. Den Text-Login auf TTY1 deaktivieren (sehr wichtig!)
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # 4. Cage Kiosk Konfiguration
  services.cage = {
    enable = true;
    user = "kiosk";
    program = "${pkgs.firefox}/bin/firefox --kiosk https://nixos.org";
    environment = {
      # WICHTIG: Sagt Firefox, dass er Wayland nutzen soll
      MOZ_ENABLE_WAYLAND = "1";
      # Erlaubt Software-Rendering in der VM
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "cage";
    };
  };

  # 5. Firefox installieren
  environment.systemPackages = [ pkgs.firefox ];
}