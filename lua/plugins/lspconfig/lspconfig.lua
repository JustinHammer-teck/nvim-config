local diagnostic_signs = require("util.lsp").diagnostic_signs

local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local util = require("lspconfig/util")

for type, icon in pairs(diagnostic_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		if vim.lsp.buf.format then
			vim.lsp.buf.format()
		elseif vim.lsp.buf.formatting then
			vim.lsp.buf.formatting()
		end
	end, { desc = "Format current buffer with LSP" })
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
		"go",
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
