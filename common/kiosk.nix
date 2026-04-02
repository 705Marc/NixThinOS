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
    tty = 1; # Festlegen auf TTY1
    
    # Der absolute Pfad zu Firefox
    program = "${pkgs.firefox}/bin/firefox --kiosk https://nixos.org";
    
    # Diese Variablen sind der "Joker" für VMs
    environment = {
      WLR_RENDERER_ALLOW_SOFTWARE = "1"; # Erzwingt Start auch ohne 3D-Beschleunigung
      WLR_NO_HARDWARE_CURSORS = "1";     # Behebt oft unsichtbare Mauszeiger in VMware
      XDG_SESSION_TYPE = "wayland";
    };
  };

  # 5. Firefox installieren
  environment.systemPackages = [ pkgs.firefox ];
}