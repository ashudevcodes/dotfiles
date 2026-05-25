vim.lsp.config('*',{
  capabilities = vim.tbl_deep_extend(
	'force',
	vim.lsp.protocol.make_client_capabilities(),
	(function()
	  local ok, blink = pcall(require, 'blink.cmp')
	  return ok and blink.get_lsp_capabilities() or {}
	end)()
  ),
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.mod', 'go.work', '.git' },
  settings = {
	gopls = {
	  analyses = { unusedparams = true },
	  staticcheck = true,
	},
  },
})

vim.filetype.add({
  extension = { h = 'c' }
})

vim.lsp.config('clangd', {
    cmd = {
        'clangd',
        '--background-index=false',
        '--limit-results=20',
        '--malloc-trim',
        '--pch-storage=disk',
        '-j=1',
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = { 'compile_commands.json', 'compile_flags.txt', 'Makefile', '.git' },
})


vim.lsp.config('lua_ls', {
    cmd = {
        'lua-language-server',
        '--memory-limit=256',
    },
})
