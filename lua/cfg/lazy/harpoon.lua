return {
    "theprimeagen/harpoon",
    config = function()
        local mark = require('harpoon.mark')
        local ui = require('harpoon.ui')
        local term = require('harpoon.term')

        vim.keymap.set('n', '<leader>a', mark.add_file)
        vim.keymap.set('n', '<leader>h', ui.toggle_quick_menu)

        vim.keymap.set('n', '<A-j>', function() ui.nav_file(1) end)
        vim.keymap.set('n', '<A-k>', function() ui.nav_file(2) end)
        vim.keymap.set('n', '<A-l>', function() ui.nav_file(3) end)
        vim.keymap.set('n', '<leader>j', function() ui.nav_file(4) end)
        vim.keymap.set('n', '<leader>k', function() ui.nav_file(5) end)
        vim.keymap.set('n', '<leader>l', function() ui.nav_file(6) end)

        vim.keymap.set('n', '<leader>c', function() require('harpoon.cmd-ui').toggle_quick_menu() end)
        vim.keymap.set('n', '<A-i>', function() term.gotoTerminal(1) end)
        vim.keymap.set('n', '<A-o>', function() term.gotoTerminal(2) end)
    end
}
