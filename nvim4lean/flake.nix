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
                    key = "<leader>k";
                    lspBufAction = "hover";
                  }
                ];
                opts = {
                  background = "light";
                  cursorline = true;
                  termguicolors = true;
                };
                plugins.blink-cmp = {
                  enable = true;
                  settings.keymap = {
                    preset = "enter";
                    "<Up>" = ["select_prev" "fallback"];
                    "<Down>" = ["select_next" "fallback"];
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
                plugins.lualine = {
            		  enable = true;
            		  settings = {
            		    sections = {
              		    lualine_a = ["mode"];
              		    lualine_b = ["branch" "diff" "diagnostics"];
              		    lualine_c = ["filename"];
              		    lualine_x = [
              		      "diagnostics"
                        {
                          __unkeyed-1 = {
                            __raw = ''
                              function()
                                local ok, stat = pcall(vim.fn.VMInfos)
                                if ok and stat.total ~= nil then
                                  return " " .. stat.total .. " sel"
                                end
                                return "none"
                              end
                            '';
                          };
                          # icon = "";
                        }
                      ];
              		    lualine_y = ["filetype"];
                	    lualine_z = ["location"];
              	    };
            		  };
            		};
                plugins.nvim-surround.enable = true;
                plugins.treesitter = {
                   enable = false;
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
                plugins.visual-multi = {
                  enable = true;
                  settings = {
                    default_mappings = 1;
                    maps = {
                      "Add Cursor Down" = "<S-c>";
                      "Add Cursor Up" = "<S-C-c>";
                    };
                    mouse_mapping = 0;
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
