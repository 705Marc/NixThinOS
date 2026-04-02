{ pkgs, ... }:

{
  # Grafiktreiber aktivieren
  hardware.graphics.enable = true;

  # Einen speziellen User für den Kiosk anlegen
  users.users.kiosk = {
    isNormalUser = true;
    # Automatischer Login für diesen User
  };

  # Cage (Kiosk-Modus) konfigurieren
  services.cage = {
    enable = true;
    user = "kiosk";
    # Hier definieren wir, was gestartet wird. 
    # Zum Testen nehmen wir erst mal den Firefox im Kiosk-Modus.
    program = "${pkgs.firefox}/bin/firefox --kiosk https://nixos.org";
  };

  # Firefox installieren, damit cage ihn findet
  environment.systemPackages = [ pkgs.firefox ];
}