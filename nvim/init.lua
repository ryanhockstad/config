require("config")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tags:append("~/.dotfiles/.tags")

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.o.termguicolors = true

require("lazy").setup({
	spec = {import = "plugins"},
	ui = { border = "rounded" },
})

