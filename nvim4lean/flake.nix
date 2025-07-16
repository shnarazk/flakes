{
  description = "my nixvim configuration for Lean4";
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
                pname = "nixvim";
                version = "20250716-1";
                colorschemes.gruvbox.enable = true;
                dependencies.lean.enable = false;
                extraConfigLua = ''
                  vim.cmd('cabbrev bc bd')
                  vim.cmd('cabbrev o edit')
                '';
                globals = {
                  mapleader = " ";
                  maplocalleader = "  ";
                };
                keymaps = [
                  # Insert mode Emacs-like movement
                  {
                    mode = "i";
                    key = "<C-b>";
                    action = "<Left>";
                    options.desc = "Emacs-like: Move left";
                  }
                  {
                    mode = "i";
                    key = "<C-f>";
                    action = "<Right>";
                    options.desc = "Emacs-like: Move right";
                  }
                  {
                    mode = "i";
                    key = "<C-a>";
                    action = "<Home>";
                    options.desc = "Emacs-like: Beginning of line";
                  }
                  {
                    mode = "i";
                    key = "<C-e>";
                    action = "<End>";
                    options.desc = "Emacs-like: End of line";
                  }
                  {
                    mode = "i";
                    key = "<C-p>";
                    action = "<Up>";
                    options.desc = "Emacs-like: Move up";
                  }
                  {
                    mode = "i";
                    key = "<C-n>";
                    action = "<Down>";
                    options.desc = "Emacs-like: Move down";
                  }
                  {
                    mode = "i";
                    key = "<C-d>";
                    action = "<Del>";
                    options.desc = "Emacs-like: Delete character";
                  }
                  {
                    mode = "n";
                    key = "U";
                    action = "<C-r>";
                    options.desc = "Redo";
                  }
                  {
                    mode = "n";
                    key = "ge";
                    action = "G";
                    options.desc = "Goto last line";
                  }
                  {
                    mode = "n";
                    key = "gn";
                    action = ":bnext<CR>";
                    options.desc = "Goto next buffer";
                  }
                  {
                    mode = "n";
                    key = "gp";
                    action = ":bprev<CR>";
                    options.desc = "Goto previous buffer";
                  }
                ];
                lsp.inlayHints.enable = true;
                lsp.keymaps = [
                  {
                    key = "gd";
                    lspBufAction = "definition";
                    options.desc = "Go to Definition";
                  }
                  {
                    key = "gD";
                    lspBufAction = "references";
                    options.desc = "Go to Reference";
                  }
                  {
                    key = "gt";
                    lspBufAction = "type_definition";
                    options.desc = "Go to Type Definition";
                  }
                  {
                    key = "gi";
                    lspBufAction = "implementation";
                    options.desc = "Go to Implementation";
                  }
                  {
                    key = "<leader>k";
                    lspBufAction = "hover";
                    options.desc = "Symbol info";
                  }
                  {
                    key = "<leader>r";
                    lspBufAction = "rename";
                    options.desc = "Rename symbol";
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
              		    lualine_b = ["branch" "diff"];
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
                                return ""
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
