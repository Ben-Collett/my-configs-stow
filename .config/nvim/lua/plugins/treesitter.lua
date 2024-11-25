return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  opts = {
  	highlight = { enable = true } ,
	indent = { enable = true},
	ensure_installed = {"diff","lua","python","toml","regex","luadoc","diff","vim","dart"}
  }
  }
