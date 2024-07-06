return {
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            lspconfig.tsserver.setup({
                capabilities = capabilities,
                init_options = {
                    preferences = {
                        disableSuggestions = true,
                    },
                },
            })

            lspconfig.clangd.setup({
                filetypes = { "c", "cpp" },
            })

            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                            disable = { "different-requires" },
                        },
                    },
                },
            })

            lspconfig.gopls.setup({
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                settings = {
                    env = {
                        GOEXPERIMENT = "rangefunc",
                    },
                    formatting = {
                        gofumpt = true,
                    },
                },
            })

            -- lspconfig.tailwindcss.setup({
            -- 	settings = {
            -- 		includeLanguages = {
            -- 			templ = "html",
            -- 		},
            -- 	},
            -- })
        end,
    },
}
