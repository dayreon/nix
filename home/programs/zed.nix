{ config, pkgs, ... }:

{
  home.file.".config/zed/settings.json".text = ''
  {
    "theme": "One Dark",
    "lsp": {
      "rust-analyzer": {
        "binary": {
          "path": "/run/current-system/sw/bin/rust-analyzer"
        }
      },
      "typescript-language-server": {
        "binary": {
          "path": "/run/current-system/sw/bin/typescript-language-server"
        },
        "initialization_options": {
          "preferences": {
            "importModuleSpecifierPreference": "relative"
          }
        }
      }
    }
  }
  '';
}