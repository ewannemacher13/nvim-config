return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
                save_on_ui_close = true,
            },
        })

        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end)
        vim.keymap.set("n", "<leader>h", function()
            local current = vim.api.nvim_buf_get_name(0)
            harpoon.ui:toggle_quick_menu(harpoon:list())
            vim.schedule(function()
                local cwd = vim.fn.getcwd() .. "/"
                local rel_current = current:gsub("^" .. vim.pesc(cwd), "")
                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                for i, line in ipairs(lines) do
                    if line == rel_current or line == current then
                        vim.api.nvim_win_set_cursor(0, { i, 0 })
                        break
                    end
                end
            end)
        end)

        vim.keymap.set("n", "<A-j>", function()
            harpoon:list():select(1)
        end)
        vim.keymap.set("n", "<A-k>", function()
            harpoon:list():select(2)
        end)
        vim.keymap.set("n", "<A-l>", function()
            harpoon:list():select(3)
        end)
        vim.keymap.set("n", "<leader>j", function()
            harpoon:list():select(4)
        end)
        vim.keymap.set("n", "<leader>k", function()
            harpoon:list():select(5)
        end)
        vim.keymap.set("n", "<leader>l", function()
            harpoon:list():select(6)
        end)
    end,
}
