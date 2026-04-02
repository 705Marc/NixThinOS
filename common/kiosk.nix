{ pkgs, ... }:

{
  # 1. Grundvoraussetzung für Grafik
  hardware.graphics.enable = true;
  virtualisation.vmware.guest.enable = true;

  # 2. User-Rechte erweitern
  users.users.kiosk = {
    isNormalUser = true;
    extraGroups = [ "video" "render" "input" ];
  };

  # 3. Text-Login auf TTY1 deaktivieren
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # 4. Cage Konfiguration
  services.cage = {
    enable = true;
    user = "kiosk";
    program = "${pkgs.firefox}/bin/firefox --kiosk https://nixos.org";
    
    environment = {
      # WICHTIG: Firefox für Wayland
      MOZ_ENABLE_WAYLAND = "1";
      # VM-Kompatibilität
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      # Standard-Wayland Variablen
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_CLASS = "user";
      # Damit Firefox weiß, wo er den Grafik-Socket findet
      XDG_RUNTIME_DIR = "/run/user/1001"; # 1001 ist die ID von User 'kiosk'
    };
  };

  # 5. Notwendige Pakete
  environment.systemPackages = with pkgs; [ 
    firefox
    mesa # Für die Grafik-Bibliotheken
  ];
}