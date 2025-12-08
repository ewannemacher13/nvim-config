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
            harpoon.ui:toggle_quick_menu(harpoon:list())
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
