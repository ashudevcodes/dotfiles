return {
  cmd = {
	'clangd',
	'--background-index=false',
	'--limit-results=20',
	'--malloc-trim',
	'--pch-storage=disk',
	'-j=1',
},
  filetypes = { 'c', 'c.doxygen', 'cpp', 'cpp.doxygen', 'objc', 'objcpp', 'cuda' },
  root_markers = {
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac', -- AutoTools
    '.git',
  },
}
