return {
	"neovim/nvim-lspconfig",
	opts = {
		diagnostics = {
			underline = true,
			virtual_text = {
				source = "if_many",
			},
			severity_sort = true,
		},
		servers = {},
		setup = {},
		actions = {},
	},
	config = function()
		require("plugins.lspconfig.lspconfig")
	end,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"windwp/nvim-autopairs",
		"williamboman/mason.nvim",
		"creativenull/efmls-configs-nvim",
		"hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
	},
}
