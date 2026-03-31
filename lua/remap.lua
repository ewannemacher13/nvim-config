vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- don't yank when pasting over highlighted text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- don't yank on 'd'
vim.keymap.set({ "n", "v" }, "d", [["_d]])
vim.keymap.set({ "n", "v" }, "<leader>d", "d")

-- don't yank on 'c'
vim.keymap.set({ "n", "v" }, "c", [["_c]])
vim.keymap.set({ "n", "v" }, "<leader>c", "c")

-- don't yank on 'x' in normal mode
vim.keymap.set("n", "x", [["_x]])
vim.keymap.set("n", "X", [["_X]])
vim.keymap.set({ "n", "v" }, "<Del>", [["_x]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>")

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- Switch between C/C++ source and header files
-- Finds the file with the same stem and opposite extension whose path
-- differs in the fewest components (allows src/ <-> include/ style layouts).
local function switch_header_source()
    local header_exts = { h = true, hpp = true, hxx = true }
    local source_exts = { c = true, cpp = true, cxx = true, cc = true }

    local ext = vim.fn.expand("%:e"):lower()
    local stem = vim.fn.expand("%:t:r")
    local current_dir = vim.fn.expand("%:p:h")
    local current_dirs = vim.split(current_dir, "/", { plain = true })

    local targets
    if source_exts[ext] then
        targets = { "h", "hpp", "hxx" }
    elseif header_exts[ext] then
        targets = { "c", "cpp", "cxx", "cc" }
    else
        return
    end

    local candidates = {}
    for _, target_ext in ipairs(targets) do
        local found = vim.fn.glob("**/" .. stem .. "." .. target_ext, false, true)
        for _, f in ipairs(found) do
            table.insert(candidates, vim.fn.fnamemodify(f, ":p"))
        end
    end

    if #candidates == 0 then
        vim.notify("No matching header/source found", vim.log.levels.WARN)
        return
    end

    -- Pick the candidate whose directory path differs in the fewest components
    -- when aligned from the end (so deep/src/foo and deep/include/foo score 1 diff)
    local best, best_diff = nil, math.huge
    for _, candidate in ipairs(candidates) do
        local cand_dirs = vim.split(vim.fn.fnamemodify(candidate, ":h"), "/", { plain = true })
        local diff = 0
        local len = math.max(#current_dirs, #cand_dirs)
        for i = 0, len - 1 do
            if current_dirs[#current_dirs - i] ~= cand_dirs[#cand_dirs - i] then
                diff = diff + 1
            end
        end
        if diff < best_diff then
            best_diff = diff
            best = candidate
        end
    end

    if best then
        vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.fnamemodify(best, ":.")))
    end
end

vim.keymap.set("n", "<leader>ah", switch_header_source, { desc = "Switch header/source" })
