return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  event = "BufReadPre",
	build = ":MasonUpdate",
  opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}
