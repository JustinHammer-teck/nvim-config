return {
	"jmederosalvarado/roslyn.nvim",
	dependencies = { "nvim-lspconfig", "cmp-nvim-lsp" },
	event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
	config = function()
		---@type table|nil
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, {
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = false,
				},
			},
		})
		require("roslyn").setup({
			capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), capabilities),
			on_attach = function() end,
		})
	end,
}
