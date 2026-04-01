# Agent Notes (Neovim Config)

## Requirements

- Requires Neovim `v0.12+` (uses `vim.pack` and the built-in `vim.lsp.config()`/`vim.lsp.enable()` flow).

## Plugin Management (`vim.pack`)

- Plugin state is tracked in `nvim-pack-lock.json`.
- Don’t edit the lockfile by hand. If you need to change plugin revisions/versions, do it via `vim.pack.add()` specs and `vim.pack.update()`.
- Plugin install location is `stdpath('data')/site/pack/core/opt` (managed exclusively by `vim.pack`).

## Config Entry Points

- `init.lua` defines `_G.Config` helpers (autocmd and keymap helpers, plus `Config.now`/`Config.later` wrappers using `mini.misc`).
- `plugin/*.lua` files are sourced automatically on startup in lexical order.
  Add new startup scripts here and keep the numeric prefix scheme (`10_…`, `20_…`, etc.) to control load order.
- `after/*` is reserved for overriding runtime behavior after plugins load:
  `after/ftdetect/` for filetype detection, `after/ftplugin/` for filetype-local options, `after/lsp/<server>.lua` for server definitions.

## Formatting

- If `stylua` is installed, format Lua after edits (prefer formatting touched files, but `stylua .` is fine for this repo).
