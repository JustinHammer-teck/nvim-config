local config = function()
  require("nvim-treesitter.configs").setup({
		indent = {
			enable = true,
		},
		autotag = {
			enable = true,
		},
		ensure_installed = {
			"markdown",
			"json",
			"typescript",
			"javascript",
			"go",
			"yaml",
			"bash",
			"lua",
			"gitignore",
			"vue",
			"dockerfile",
			"c_sharp",
		},
		auto_install = true,
		hightlight = {
			enable = true,
			additional_vim_regex_highlighting = true,
		},
	})
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = config,
	},
	{ -- Automatically add closing tags for HTML and JSX
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		opts = {},
	},
}
