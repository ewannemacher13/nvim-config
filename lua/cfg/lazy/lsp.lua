local function attach(_opts)
    local opts = {buffer = _opts.buffer, remap = false}
	vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set('n', '<leader>vi', function()
		vim.lsp.buf.code_action({
			apply = true,
			filter = function(action)
				return action.title == 'Fix all auto-fixable problems'
			end,
		})
	end, opts)
	vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
	vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
	vim.keymap.set('n', '<leader>lr', "<cmd>LspRestart<cr>", opts)


end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
        ensure_installed = {
            'lua_ls',
            'rust_analyzer',
            'zls',
        },
        handlers = {
            function (server_name)
                require("lspconfig")[server_name].setup({
                    on_attach = attach,
                })
            end,
            ["lua_ls"] = function()
                local lspconfig = require("lspconfig")
                lspconfig.lua_ls.setup({
                    settings = {
                        Lua = {
                            diagnostics = { globals = {"vim"}}
                        }
                    }
                })
            end,
        }
        })

        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
              expand = function(args)
                require('luasnip').lsp_expand(args.body)
              end
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'luasnip' }, -- For luasnip users.
            }, {
              { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            update_on_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
