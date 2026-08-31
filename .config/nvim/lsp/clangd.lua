return {
  cmd = {
	'clangd',
	'--background-index-priority=low',
	'--limit-results=20',
	'--malloc-trim',
	'--pch-storage=disk',
	'--limit-references=10',
	'--completion-style=detailed'
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
