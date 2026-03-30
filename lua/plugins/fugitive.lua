local function jump_to_first_change()
    local lnum = vim.fn.search('^[A-Z?!]\\{1,2\\} ', 'nw')
    if lnum > 0 then
        vim.api.nvim_win_set_cursor(0, { lnum, 0 })
    end
end

return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set('n', '<leader>gs', function()
            local splitbelow = vim.o.splitbelow
            vim.o.splitbelow = false
            vim.cmd.Git()
            vim.o.splitbelow = splitbelow
            jump_to_first_change()
        end)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "fugitive",
            callback = function(args)
                vim.keymap.set('n', '<CR>', function()
                    local path = vim.fn['fugitive#PorcelainCfile']()
                    if path ~= '' then
                        if vim.fn.isdirectory(path) == 1 then
                            local git_file = path .. '/.git'
                            if vim.fn.filereadable(git_file) == 1 or vim.fn.isdirectory(git_file) == 1 then
                                -- resolve the actual git dir (.git in a submodule is a file pointing elsewhere)
                                local git_dir
                                if vim.fn.isdirectory(git_file) == 1 then
                                    git_dir = git_file
                                else
                                    local lines = vim.fn.readfile(git_file)
                                    local rel = lines[1] and lines[1]:match('^gitdir: (.+)')
                                    if rel then
                                        git_dir = rel:sub(1, 1) == '/' and rel or (path .. '/' .. rel)
                                    end
                                end
                                if git_dir then
                                    local normalized = vim.fn.fnamemodify(git_dir, ':p:s?/$??')
                                    vim.cmd('edit fugitive://' .. normalized .. '//')
                                    jump_to_first_change()
                                end
                                return
                            end
                        end
                        vim.cmd('edit ' .. vim.fn.fnameescape(path))
                    end
                end, { buffer = args.buf })
            end,
        })
    end,
}
