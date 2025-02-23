return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mfussenegger/nvim-jdtls",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		-- optional `vim.uv` typings for lazydev
		{ "Bilal2453/luvit-meta", lazy = true },
	},
	opts = {
		autoformat = false,
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		local default_capabilities = vim.lsp.protocol.make_client_capabilities()

		local server_configs = {
			clangd = {},
			pyright = {},
			gopls = {},
			solargraph = {},
			rust_analyzer = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							disable = {
								"missing-fields",
							},
						},
					},
				},
			},
		}

		mason.setup()

		local mason_ensure_installed = vim.tbl_keys(server_configs or {})
		vim.list_extend(mason_ensure_installed, {
			"clangd",
			"stylua",
			"jdtls",
			"pyright",
			"gopls",
			"solargraph",
			"rust_analyzer",
		})
		mason_tool_installer.setup({
			ensure_installed = mason_ensure_installed,
		})

		mason_lspconfig.setup({
			handlers = {
				function(server_name)
					local server_config = server_configs[server_name] or {}
					server_config.capabilities =
						vim.tbl_deep_extend("force", default_capabilities, server_config.capabilities or {})
					lspconfig[server_name].setup(server_config)
				end,
				["jdtls"] = function() end,
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach-keybinds", { clear = true }),
			callback = function(bufnr)
				local nmap = function(keys, func, desc)
					if desc then
						desc = "LSP: " .. desc
					end

					vim.keymap.set("n", keys, func, { buffer = bufnr.buf, desc = desc })
				end

				nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
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
				vim.api.nvim_buf_create_user_command(bufnr.buf, "Format", function(_)
					-- vim.lsp.buf.format()
				end, { desc = "Format current buffer with LSP" })
			end,
		})
	end,
}
