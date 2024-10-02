return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  dependencies = {{'nushell/tree-sitter-nu'}},
  opts = {
  	highlight = { enable = true } ,
	indent = { enable = true},
	ensure_installed = {"diff","lua","toml","regex","luadoc","diff","vim",
  }
  }
  }
