# Neovim Config

Constant work in progress.

I've tried many different Neovim configs and IDE-like setups. But I quickly realized that I don't like all of that and want something simpler and lighter. So the idea behind my config is to keep it clean, use the minimum number of plugins, and NOT override the default key mappings.

## Prerequisites

* [Neovim](https://neovim.io/doc) ≥ v0.12.0
* [git](https://git-scm.com/) ≥ 2.19.0
* [fd](https://github.com/sharkdp/fd)
* [ripgrep](https://github.com/BurntSushi/ripgrep)

## Install

1. Clone this repo to `~/.config/nvim`

```bash
  mkdir -p ~/.config
  git clone git@github.com:slavamak/nvim.git ~/.config/nvim
  cd ~/.config/nvim
```

2. Run `nvim`

   It is highly recommended that you run `:checkhealth` to ensure that your system is healthy.

## Inspiration

The Neovim `v0.12` / `vim.pack` version of this config (structure and ideas) is inspired by MiniMax by Evgeni Chasnovski:

* https://nvim-mini.org/MiniMax/
* https://github.com/nvim-mini/MiniMax
