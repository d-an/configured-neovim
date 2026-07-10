# Nixvim configuration module (standalone format).
# Options are at the top level (no `programs.nixvim` wrapper).
# For Home Manager / NixOS, wrap this under `programs.nixvim`
# (see flake.nix homeModules / nixosModules).

{ pkgs, ... }:
{
  colorschemes.gruvbox.enable = true;

  opts = {
    expandtab = true;
    signcolumn = "yes:1";
  };

  globals = {
    mapleader = " ";
    maplocalleader = " ";
    expandtab = true;
  };

  plugins.lightline.enable = true;
  plugins.which-key.enable = true;
  plugins.better-escape.enable = true;
  plugins.harpoon.enable = true;
  plugins.neogit.enable = true;

  plugins.telescope = {
    enable = true;
    extensions.fzf-native.enable = true;
    keymaps = {
      "<leader>sf" = { mode = "n"; action = "find_files"; };
      "<leader>s." = { mode = "n"; action = "oldfiles"; };
      "<leader><leader>" = { mode = "n"; action = "buffers"; };
    };
    settings.defaults.file_ignore_patterns = [
      "^.git"
      "^node_modules"
      "^venv"
      "^%.venv"
      "__pycache__"
    ];
  };

  plugins.lsp = {
    enable = true;
    servers.pyright.enable = true;
  };

  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings.sources = [
      { name = "nvim_lsp"; }
      { name = "luasnip"; }
      { name = "buffer"; }
      { name = "path"; }
    ];
  };

  plugins.web-devicons.enable = true;

  keymaps = [
    { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<cr>"; }
    { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<cr>"; }
    { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<cr>"; options.desc = "Goto Definition"; }
    { mode = "n"; key = "gD"; action = "<cmd>lua vim.lsp.buf.declaration()<cr>"; options.desc = "Goto Declaration"; }
    {
      mode = "n";
      key = "<leader>a";
      action = { __raw = "function() require('harpoon'):list():add() end"; };
      options.desc = "Harpoon: Add file";
    }
    {
      mode = "n";
      key = "<C-e>";
      action = { __raw = "function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end"; };
      options.desc = "Harpoon: list";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = { __raw = "function() require('harpoon'):list():select(1) end"; };
      options.desc = "Harpoon: 1st";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = { __raw = "function() require('harpoon'):list():select(2) end"; };
      options.desc = "Harpoon: 2nd";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = { __raw = "function() require('harpoon'):list():select(3) end"; };
      options.desc = "Harpoon: 3rd";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = { __raw = "function() require('harpoon'):list():select(4) end"; };
      options.desc = "Harpoon: 4th";
    }
    { mode = "n"; key = ">"; action = ">0"; options.desc = "indent"; }
    { mode = "n"; key = "<"; action = "<0"; options.desc = "de-indent"; }
    { mode = "v"; key = ">"; action = ">0gv"; options.desc = "indent"; }
    { mode = "v"; key = "<"; action = "<0gv"; options.desc = "de-indent"; }
  ];
}
