return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "folke/lazydev.nvim",
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim", -- just used so mason-tool-intaller uses lspconfig names (ts_ls) instead of Mason names (typescript-language-server)
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "saghen/blink.cmp",
        { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            },
            pyright = {},
            clangd = {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--query-driver=/opt/dspic33/xc16/v1.50/bin/xc16-gcc"
                    -- "--query-driver=/opt/dspic33/xc16/v1.50/bin/xc16-gcc,/usr/bin/gcc,/usr/bin/g++"
                },
            },
        }

        require("mason").setup()
        local ensure_installed = vim.tbl_keys(servers)
        vim.list_extend(ensure_installed, {
            "stylua",
            { "lua_ls", version = "3.15.0" },
            "black",
        })

        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        -- set global capabilities for all language servers
        vim.lsp.config("*", { capabilities = capabilities })

        for name, config in pairs(servers) do
            if config == true then
                config = {}
            end

            if next(config) ~= nil then
                vim.lsp.config(name, config)
            end

            vim.lsp.enable(name)
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)

                local settings = servers[client.name]
                if type(settings) ~= "table" then
                    settings = {}
                end

                local map = function(keys, func, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = ev.buf })
                end

                local builtin = require("telescope.builtin")

                map("<leader>vws", vim.lsp.buf.workspace_symbol)
                map("<leader>vd", vim.diagnostic.open_float)
                map("<leader>vca", vim.lsp.buf.code_action)
                map("<leader>vi", function()
                    vim.lsp.buf.code_action({
                        apply = true,
                        fitler = function(action)
                            return action.title == "Fix all auto-fixable problems"
                        end,
                    })
                end)
                map("<leader>vrr", builtin.lsp_references)
                map("<leader>vrn", vim.lsp.buf.rename)

                map("gd", builtin.lsp_definitions)
                map("gr", builtin.lsp_references)
                map("gD", vim.lsp.buf.declaration)
                map("gT", vim.lsp.buf.type_definition)

                map("<leader>lr", "<cmd>LspRestart<cr>")

                if settings.server_capabilities then
                    for k, v in pairs(settings.server_capabilities) do
                        if v == vim.NIL then
                            v = nil
                        end

                        client.server_capabilities[k] = v
                    end
                end
            end,
        })

        vim.diagnostic.config({
            virtual_text = true,
            virtual_lines = false,
            update_on_insert = true,
            float = {
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}
