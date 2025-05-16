# padcosta.nvim

Simple neovim plugin which makes sure one blank line is present before control statement.

## Dependencies

Control statements are detected using [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).

## Installation

### Lazy.nvim

Add padcosta to your plugin spec (e.g. in `lua/plugins/padcosta.lua`):

```lua
return {
  "buvis/padcosta.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
  config = function()
    require("padcosta").setup()
  end
}
```

### Packer.nvim

Add padcosta to your `plugins.lua` or `init.lua`:

```lua
use {
  "buvis/padcosta.nvim",
  requires = { "nvim-treesitter/nvim-treesitter" },
  run = ":TSUpdate",
  config = function()
    require("padcosta").setup()
  end
}
```

## Configuration

### Activate debugging mode

If something isn't working as expected, you can enable debugging mode to get more information about what is happening.

Pass this to `setup()` or include in `opts` if you use LazyVim.

```lua
{ debug = true }
```
