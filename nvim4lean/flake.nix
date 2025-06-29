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
                opts = {
                  background = "light";
                  termguicolors = true;
                };
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
                plugins.nvim-surround.enable = true;
                plugins.treesitter = {
                   enable = true;
                   settings = {
                     incremental_selection = {
                       enable = true;
                       keymaps = {
                         init_selection = false;
                         node_decrement = "]g";
                         node_increment = "[g";
                       };
                     };
                   };
                 };
                plugins.which-key.enable = true;
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
