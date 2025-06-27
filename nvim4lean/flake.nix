{
  description = "my nixvim configuration for Lean4";
  # inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.nixvim.url = "github:nix-community/nixvim";

  outputs =
    { self, nixvim }:
    {
      packages = builtins.listToAttrs (
        map
          (system: {
            name = system;
            value = {
              default = nixvim.legacyPackages.${system}.makeNixvim {

                colorschemes.gruvbox.enable = true;
                dependencies.lean.enable = false;
                globals = {
                  mapleader = " ";
                  maplocalleader = "  ";
                };
                lsp.inlayHints.enable = true;
                lsp.keymaps = [
                  {
                    key = "gd";
                    lspBufAction = "definition";
                  }
                  {
                    key = "gD";
                    lspBufAction = "references";
                  }
                  {
                    key = "gt";
                    lspBufAction = "type_definition";
                  }
                  {
                    key = "gi";
                    lspBufAction = "implementation";
                  }
                  {
                    key = "k";
                    lspBufAction = "hover";
                  }
                ];
                plugins.blink-cmp = {
                  enable = true;
                  settings.keymap = {
                    preset = "enter";
                  };
                  settings.sources = {
                    default = [
                      "lsp"
                      "path"
                      "buffer"
                      "copilot"
                    ];
                    providers = {
                      copilot = {
                        async = true;
                        module = "blink-copilot";
                        name = "copilot";
                        score_offset = 100;
                        # Optional configurations
                        opts = {
                          max_completions = 3;
                          max_attempts = 4;
                          kind = "Copilot";
                          debounce = 750;
                          auto_refresh = {
                            backward = true;
                            forward = true;
                          };
                        };
                      };
                    };
                  };
                };
                plugins.blink-copilot.enable = true;
                plugins.lean.enable = true;
                plugins.lean.autoLoad = true;
                plugins.lean.settings.mappings = true;
                plugins.lean.settings.progress_bars.enable = false;
                plugins.lualine.enable = true;
                # plugins.lualine.settings.options.icons_enabled = false;
                plugins.nvim-surround.enable = true;
                plugins.which-key.enable = true;
                # plugins.which-key.settings.icons.keys = {
                #   BS = "BS";
                #   C = "C-";
                #   CR = "CR";
                #   D = "D-";
                #   Down = "↓";
                #   Esc = "Esc";
                #   F1 = "F1";
                #   F10 = "F10";
                #   F11 = "F11";
                #   F12 = "F12";
                #   F2 = "F2";
                #   F3 = "F3";
                #   F4 = "F4";
                #   F5 = "F5";
                #   F6 = "F6";
                #   F7 = "F7";
                #   F8 = "F8";
                #   F9 = "F9";
                #   Left = "←";
                #   M = "M-";
                #   NL = "NL";
                #   Right = "→";
                #   S = "S-";
                #   ScrollWheelDown = "⇣";
                #   ScrollWheelUp = "⇡";
                #   Space = "SPC";
                #   Tab = "TAB";
                #   Up = "↑";
                # };
                # plugins.which-key.settings.icons.rules = false;
                # plugins.tree-sitter.enable = true;
                # plugins.treesitter-textobjects.enable = true;

              };
            };
          })
          [
            "x86_64-linux"
            "aarch64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
          ]
      );
    };
}
