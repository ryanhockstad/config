local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		go = { "golines" },
		lua = { "stylua" },
	},

	format_on_save = {
		lsp_fallback = true,
		timeout_ms = 500,
	},

	format_after_save = {
		lsp_fallback = true,
	},
	notify_on_error = true,
})
