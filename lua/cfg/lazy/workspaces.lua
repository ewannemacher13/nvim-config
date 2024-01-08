return {
    "natecraddock/workspaces.nvim",

    config = function()
        local workspaces = require('workspaces')
        local telescope = require('telescope')

        workspaces.setup({
            hooks = {
                open = { 'Telescope find_files' }
            }
        })
        telescope.load_extension('workspaces')

        vim.keymap.set('n', '<leader>wo', function() telescope.extensions.workspaces.workspaces() end)
    end
}
