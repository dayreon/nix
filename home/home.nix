{ config, pkgs, nixpkgs-unstable, ... }:

let
  unstable = import nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  home.username = "decard";
  home.homeDirectory = "/home/decard";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    btop
    neofetch
    tofi
    #waybar
    #wl-clipboard
    #brightnessctl
    #pamixer
    #grim
    #slurp
    unstable.zed
  ];

  programs.kitty = {
      enable = true;
      font = {
        name = "JetBrains Mono";
        size = 12;
      };
      settings = {
        background_opacity = "0.95";
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        # Тут можно добавить любые дополнительные настройки
      '';
  };

  wayland.windowManager.hyprland = {
    enable = true;  # использует системный Hyprland
    settings = {
      monitor = [
        ",preferred,auto,1"  # это значит "для всех мониторов используй оптимальное разрешение"
      ];

      # exec-once = [
      #   "waybar"
      # ];

      bind = [
        "SUPER, D, exec, tofi-drun --drun-launch=true"
        "SUPER, Return, exec, kitty"
        "SUPER, Q, killactive,"
        "SUPER, M, exit,"
        "SUPER, E, exec, dolphin"
        "SUPER, V, togglefloating,"
        "SUPER, R, exec, wofi --show drun"
        "SUPER, P, pseudo,"
        "SUPER, J, togglesplit,"
      ];
    };
  };

  home.file.".config/tofi/config".text = ''
    # Основные настройки
    width = 100%
    height = 40
    border-width = 0
    outline-width = 0
    padding-left = 35%
    padding-top = 20
    result-spacing = 15
    num-results = 5
    font = JetBrains Mono
    font-size = 14

    # Цвета (монохромная тема)
    background-color = #000000A0
    text-color = #FFFFFF
    selection-color = #FFFFFFCC
    prompt-color = #888888

    # Поведение
    prompt-text = "run: "
    hide-cursor = true
    ascii-input = true
  '';

  home.stateVersion = "24.05";
}
