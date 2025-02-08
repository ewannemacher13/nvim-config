return {
    "stevearc/oil.nvim",
    --    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        vim.keymap.set("n", "-", "<CMD>Oil<CR>")
        vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>")

        local oil = require("oil");
        oil.setup({
            columns = {},
            keymaps = {
                ["cd"] = "actions.cd",
            },
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
                highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
                    if (entry.type == "file") then
                        local file = io.open(oil.get_current_dir() .. entry.name)
                        if not file then return nil end
                        local content = file:read "*a"
                        file:close()

                        if string.find(content, "expect=fail") then
                            return "OilHidden"
                        end
                    end

                    return nil
                end,
            },
        })
    end
}
