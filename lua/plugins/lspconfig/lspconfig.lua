local on_attach = require("util.lsp").on_attach
local diagnostic_signs = require("util.lsp").diagnostic_signs

local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = cmp_nvim_lsp.default_capabilities()

local util = require("lspconfig/util")

for type, icon in pairs(diagnostic_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

lspconfig.omnisharp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "cs", "vb" },
	root_dir = util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json"),
	settings = {
		FormattingOptions = {
			EnableEditorConfigSupport = true,
		},
		ImplementTypeOptions = {
			InsertionBehavior = "WithOtherMembersOfTheSameKind",
			PropertyGenerationBehavior = "PreferAutoProperties",
		},
		RenameOptions = {
			RenameInComments = true,
			RenameInStrings = true,
			RenameOverloads = true,
		},
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableDecompilationSupport = true,
			EnableImportCompletion = true,
			locationPaths = {},
		},
	},
})

-- Golang LSP Configuration
lspconfig.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
})

-- Lua Lsp Configuration
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

-- typescript

lspconfig.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		javascript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
		typescript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
	},
	filetypes = {
		"typescript",
	},
	root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
})

lspconfig.emmet_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = {
		"javascript",
		"css",
		"vue",
		"html",
	},
})

local luacheck = require("efmls-configs.linters.luacheck")
local stylua = require("efmls-configs.formatters.stylua")
local eslint_d = require("efmls-configs.linters.eslint_d")
local prettier_d = require("efmls-configs.formatters.prettier_d")
local fixjson = require("efmls-configs.formatters.fixjson")
local hadolint = require("efmls-configs.linters.hadolint")

-- configure efm server
lspconfig.efm.setup({
	filetypes = {
		"lua",
		"json",
		"jsonc",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"markdown",
		"docker",
		"html",
		"css",
		"c_sharp",
	},
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
		hover = true,
		documentSymbol = true,
		codeAction = true,
		completion = true,
	},
	settings = {
		languages = {
			lua = { luacheck, stylua },
			typescript = { eslint_d, prettier_d },
			json = { eslint_d, fixjson },
			jsonc = { eslint_d, fixjson },
			javascript = { eslint_d, prettier_d },
			javascriptreact = { eslint_d, prettier_d },
			typescriptreact = { eslint_d, prettier_d },
			vue = { eslint_d, prettier_d },
			markdown = { prettier_d },
			docker = { hadolint, prettier_d },
			html = { prettier_d },
			css = { prettier_d },
		},
	},
})

-- Format on Save
local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = lsp_fmt_group,
	callback = function()
		local efm = vim.lsp.get_active_clients({ names = "efm" })

		if vim.tbl_isempty(efm) then
			return
		end

		vim.lsp.buf.format({ name = "efm" })
	end,
})
