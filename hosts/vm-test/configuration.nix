{ pkgs, ... }:

{
  # 1. Bootloader (für UEFI/VMware Standard)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 2. Netzwerk-Einstellungen
  networking.hostName = "ts01"; 
  networking.networkmanager.enable = true;

  # 3. Zeit & Sprache
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  # 4. Benutzer-Konfiguration
  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # 'wheel' erlaubt sudo
    initialPassword = "nixos"; # BITTE BEIM ERSTEN LOGIN ÄNDERN
    openssh.authorizedKeys.keys = [
      # Hier kannst du deinen Windows-SSH-Key (id_ed25519.pub) einfügen
      # "ssh-ed25519 AAAAC3..."
    ];
  };

  # 5. System-Pakete (Was immer da sein soll)
  environment.systemPackages = with pkgs; [
    git
    nano
    curl
    wget
    htop  # Super zum Überwachen der Ressourcen
    pciutils # Zum Hardware-Check (lspci)
  ];

  # 6. Dienste (SSH & Flakes aktivieren)
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true; # Für den Anfang erlaubt
  };

  # WICHTIG: Flakes im System erlauben
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 7. Vorbereitung für später (Kiosk/Grafik)
  # hardware.opengl.enable = true; 

  # Diese Version nicht ändern! Sie definiert den Stand der State-Files (Logs, DBs)
  system.stateVersion = "25.11"; 
}