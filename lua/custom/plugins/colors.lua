local M = {}

local palettes = {
  main = {
    _nc = "#16141f",
    --base = "#191724",
    base = "NONE",
    surface = "#1f1d2e",
    overlay = "#26233a",
    muted = "#6e6a86",
    subtle = "#908caa",
    text = "#e0def4",
    love = "#eb6f92",
    gold = "#f6c177",
    rose = "#ebbcba",
    pine = "#31748f",
    foam = "#9ccfd8",
    iris = "#c4a7e7",
    leaf = "#95b1ac",
    highlight_low = "#21202e",
    highlight_med = "#403d52",
    highlight_high = "#524f67",
    none = "NONE",
  },
  rosepine = {
    _nc = "#16141f",
    base = "#191724",
    surface = "#1f1d2e",
    overlay = "#26233a",
    muted = "#6e6a86",
    subtle = "#908caa",
    text = "#e0def4",
    love = "#eb6f92",
    gold = "#f6c177",
    rose = "#ebbcba",
    pine = "#31748f",
    foam = "#9ccfd8",
    iris = "#c4a7e7",
    leaf = "#95b1ac",
    highlight_low = "#21202e",
    highlight_med = "#403d52",
    highlight_high = "#524f67",
    none = "NONE",
  },
}

local styles = {
  bold = true,
  italic = true,
  transparency = false,
}

local options_groups = {
  border = "muted",
  link = "iris",
  panel = "surface",

  error = "love",
  hint = "iris",
  info = "foam",
  ok = "leaf",
  warn = "gold",
  note = "pine",
  todo = "rose",

  git_add = "foam",
  git_change = "rose",
  git_delete = "love",
  git_dirty = "rose",
  git_ignore = "muted",
  git_merge = "iris",
  git_rename = "pine",
  git_stage = "iris",
  git_text = "rose",
  git_untracked = "subtle",

  h1 = "iris",
  h2 = "foam",
  h3 = "rose",
  h4 = "gold",
  h5 = "pine",
  h6 = "leaf",
}

local palette = palettes.main

local utilities = {}
local color_cache = {}

---@param color string Palette key or hex value
function utilities.parse_color(color)
	if color_cache[color] then
		return color_cache[color]
	end

	if color == nil then
		print("Invalid color: " .. color)
		return nil
	end

	color = color:lower()

	if not color:find("#") and color ~= "NONE" then
		color = palette[color] or vim.api.nvim_get_color_by_name(color)
	end

	color_cache[color] = color
	return color
end
local blend_cache = {}
---@param color string
local function color_to_rgb(color)
	local function byte(value, offset)
		return bit.band(bit.rshift(value, offset), 0xFF)
	end

	local new_color = vim.api.nvim_get_color_by_name(color)
	if new_color == -1 then
		new_color = vim.opt.background:get() == "dark" and 000 or 255255255
	end

	return { byte(new_color, 16), byte(new_color, 8), byte(new_color, 0) }
end
---@param fg string Foreground color
---@param bg string Background color
---@param alpha number Between 0 (background) and 1 (foreground)
function utilities.blend(fg, bg, alpha)
	local cache_key = fg .. bg .. alpha
	if blend_cache[cache_key] then
		return blend_cache[cache_key]
	end

	local fg_rgb = color_to_rgb(fg)
	local bg_rgb = color_to_rgb(bg)

	local function blend_channel(i)
		local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	local result = string.format("#%02X%02X%02X", blend_channel(1), blend_channel(2), blend_channel(3))

	blend_cache[cache_key] = result
	return result
end

local function set_highlights()

  local groups = {}
  for group, color in pairs(options_groups) do
    groups[group] = utilities.parse_color(color)
  end

  local function make_border(fg)
    fg = fg or groups.border
    return {
      fg = fg,
      bg = (not styles.transparency) and palette.surface or "NONE",
    }
  end

  local default_highlights = {
    ColorColumn = { bg = palette.surface },
    Conceal = { bg = "NONE" },
    CurSearch = { fg = palette.base, bg = palette.gold },
    Cursor = { fg = palette.text, bg = palette.highlight_high },
    CursorColumn = { bg = palette.overlay },
    -- CursorIM = {},
    CursorLine = { bg = palette.overlay },
    CursorLineNr = { fg = palette.text, bold = styles.bold },
    -- DarkenedPanel = { },
    -- DarkenedStatusline = {},
    DiffAdd = { bg = groups.git_add, blend = 20 },
    DiffChange = { bg = groups.git_change, blend = 20 },
    DiffDelete = { bg = groups.git_delete, blend = 20 },
    DiffText = { bg = groups.git_text, blend = 40 },
    diffAdded = { link = "DiffAdd" },
    diffChanged = { link = "DiffChange" },
    diffRemoved = { link = "DiffDelete" },
    Directory = { fg = palette.foam, bold = styles.bold },
    -- EndOfBuffer = {},
    ErrorMsg = { fg = groups.error, bold = styles.bold },
    FloatBorder = make_border(),
    FloatTitle = { fg = palette.foam, bg = groups.panel, bold = styles.bold },
    FoldColumn = { fg = palette.muted },
    Folded = { fg = palette.text, bg = groups.panel },
    IncSearch = { link = "CurSearch" },
    LineNr = { fg = palette.muted },
    MatchParen = { fg = palette.pine, bg = palette.pine, blend = 25 },
    ModeMsg = { fg = palette.subtle },
    MoreMsg = { fg = palette.iris },
    NonText = { fg = palette.muted },
    Normal = { fg = palette.text, bg = palette.base },
    --NormalFloat = { bg = groups.panel },
    NormalFloat = { bg = palette.base },
    NormalNC = { fg = palette.text, bg = palette.base },
    NvimInternalError = { link = "ErrorMsg" },
    Pmenu = { fg = palette.subtle, bg = groups.panel },
    PmenuExtra = { fg = palette.muted, bg = groups.panel },
    PmenuExtraSel = { fg = palette.subtle, bg = palette.overlay },
    PmenuKind = { fg = palette.foam, bg = groups.panel },
    PmenuKindSel = { fg = palette.subtle, bg = palette.overlay },
    PmenuSbar = { bg = groups.panel },
    PmenuSel = { fg = palette.text, bg = palette.overlay },
    PmenuThumb = { bg = palette.muted },
    Question = { fg = palette.gold },
    QuickFixLine = { fg = palette.foam },
    -- RedrawDebugNormal = {},
    RedrawDebugClear = { fg = palette.base, bg = palette.gold },
    RedrawDebugComposed = { fg = palette.base, bg = palette.pine },
    RedrawDebugRecompose = { fg = palette.base, bg = palette.love },
    Search = { fg = palette.text, bg = palette.gold, blend = 20 },
    SignColumn = { fg = palette.text, bg = "NONE" },
    SpecialKey = { fg = palette.foam },
    SpellBad = { sp = palette.subtle, undercurl = true },
    SpellCap = { sp = palette.subtle, undercurl = true },
    SpellLocal = { sp = palette.subtle, undercurl = true },
    SpellRare = { sp = palette.subtle, undercurl = true },
    StatusLine = { fg = palette.subtle, bg = groups.panel },
    StatusLineNC = { fg = palette.muted, bg = groups.panel, blend = 60 },
    StatusLineTerm = { fg = palette.base, bg = palette.pine },
    StatusLineTermNC = { fg = palette.base, bg = palette.pine, blend = 60 },
    Substitute = { link = "IncSearch" },
    TabLine = { fg = palette.subtle, bg = groups.panel },
    TabLineFill = { bg = groups.panel },
    TabLineSel = { fg = palette.text, bg = palette.overlay, bold = styles.bold },
    Title = { fg = palette.foam, bold = styles.bold },
    VertSplit = { fg = groups.border },
    Visual = { bg = palette.iris, blend = 15 },
    -- VisualNOS = {},
    WarningMsg = { fg = groups.warn, bold = styles.bold },
    -- Whitespace = {},
    WildMenu = { link = "IncSearch" },
    WinBar = { fg = palette.subtle, bg = groups.panel },
    WinBarNC = { fg = palette.muted, bg = groups.panel, blend = 60 },
    WinSeparator = { fg = groups.border },

    DiagnosticError = { fg = groups.error },
    DiagnosticHint = { fg = groups.hint },
    DiagnosticInfo = { fg = groups.info },
    DiagnosticOk = { fg = groups.ok },
    DiagnosticWarn = { fg = groups.warn },
    DiagnosticDefaultError = { link = "DiagnosticError" },
    DiagnosticDefaultHint = { link = "DiagnosticHint" },
    DiagnosticDefaultInfo = { link = "DiagnosticInfo" },
    DiagnosticDefaultOk = { link = "DiagnosticOk" },
    DiagnosticDefaultWarn = { link = "DiagnosticWarn" },
    DiagnosticFloatingError = { link = "DiagnosticError" },
    DiagnosticFloatingHint = { link = "DiagnosticHint" },
    DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
    DiagnosticFloatingOk = { link = "DiagnosticOk" },
    DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
    DiagnosticSignError = { link = "DiagnosticError" },
    DiagnosticSignHint = { link = "DiagnosticHint" },
    DiagnosticSignInfo = { link = "DiagnosticInfo" },
    DiagnosticSignOk = { link = "DiagnosticOk" },
    DiagnosticSignWarn = { link = "DiagnosticWarn" },
    DiagnosticUnderlineError = { sp = groups.error, undercurl = true },
    DiagnosticUnderlineHint = { sp = groups.hint, undercurl = true },
    DiagnosticUnderlineInfo = { sp = groups.info, undercurl = true },
    DiagnosticUnderlineOk = { sp = groups.ok, undercurl = true },
    DiagnosticUnderlineWarn = { sp = groups.warn, undercurl = true },
    DiagnosticVirtualTextError = { fg = groups.error, bg = groups.error, blend = 10 },
    DiagnosticVirtualTextHint = { fg = groups.hint, bg = groups.hint, blend = 10 },
    DiagnosticVirtualTextInfo = { fg = groups.info, bg = groups.info, blend = 10 },
    DiagnosticVirtualTextOk = { fg = groups.ok, bg = groups.ok, blend = 10 },
    DiagnosticVirtualTextWarn = { fg = groups.warn, bg = groups.warn, blend = 10 },

    Boolean = { fg = palette.rose },
    Character = { fg = palette.gold },
    Comment = { fg = palette.subtle, italic = styles.italic },
    Conditional = { fg = palette.pine },
    Constant = { fg = palette.gold },
    Debug = { fg = palette.rose },
    Define = { fg = palette.iris },
    Delimiter = { fg = palette.subtle },
    Error = { fg = palette.love },
    Exception = { fg = palette.pine },
    Float = { fg = palette.gold },
    Function = { fg = palette.rose },
    Identifier = { fg = palette.text },
    Include = { fg = palette.pine },
    Keyword = { fg = palette.pine },
    Label = { fg = palette.foam },
    LspCodeLens = { fg = palette.subtle },
    LspCodeLensSeparator = { fg = palette.muted },
    LspInlayHint = { fg = palette.muted, bg = palette.muted, blend = 10 },
    LspReferenceRead = { bg = palette.highlight_med },
    LspReferenceText = { bg = palette.highlight_med },
    LspReferenceWrite = { bg = palette.highlight_med },
    Macro = { fg = palette.iris },
    Number = { fg = palette.gold },
    Operator = { fg = palette.subtle },
    PreCondit = { fg = palette.iris },
    PreProc = { link = "PreCondit" },
    Repeat = { fg = palette.pine },
    Special = { fg = palette.foam },
    SpecialChar = { link = "Special" },
    SpecialComment = { fg = palette.iris },
    Statement = { fg = palette.pine, bold = styles.bold },
    StorageClass = { fg = palette.foam },
    String = { fg = palette.gold },
    Structure = { fg = palette.foam },
    Tag = { fg = palette.foam },
    Todo = { fg = palette.rose, bg = palette.rose, blend = 20 },
    Type = { fg = palette.foam },
    TypeDef = { link = "Type" },
    Underlined = { fg = palette.iris, underline = true },
    Added = { fg = groups.git_add },
    Changed = { fg = groups.git_change },
    Removed = { fg = groups.git_delete },

    healthError = { fg = groups.error },
    healthSuccess = { fg = groups.info },
    healthWarning = { fg = groups.warn },

    htmlArg = { fg = palette.iris },
    htmlBold = { bold = styles.bold },
    htmlEndTag = { fg = palette.subtle },
    htmlH1 = { link = "markdownH1" },
    htmlH2 = { link = "markdownH2" },
    htmlH3 = { link = "markdownH3" },
    htmlH4 = { link = "markdownH4" },
    htmlH5 = { link = "markdownH5" },
    htmlItalic = { italic = styles.italic },
    htmlLink = { link = "markdownUrl" },
    htmlTag = { fg = palette.subtle },
    htmlTagN = { fg = palette.text },
    htmlTagName = { fg = palette.foam },

    markdownDelimiter = { fg = palette.subtle },
    markdownH1 = { fg = groups.h1, bold = styles.bold },
    markdownH1Delimiter = { link = "markdownH1" },
    markdownH2 = { fg = groups.h2, bold = styles.bold },
    markdownH2Delimiter = { link = "markdownH2" },
    markdownH3 = { fg = groups.h3, bold = styles.bold },
    markdownH3Delimiter = { link = "markdownH3" },
    markdownH4 = { fg = groups.h4, bold = styles.bold },
    markdownH4Delimiter = { link = "markdownH4" },
    markdownH5 = { fg = groups.h5, bold = styles.bold },
    markdownH5Delimiter = { link = "markdownH5" },
    markdownH6 = { fg = groups.h6, bold = styles.bold },
    markdownH6Delimiter = { link = "markdownH6" },
    markdownLinkText = { link = "markdownUrl" },
    markdownUrl = { fg = groups.link, sp = groups.link, underline = true },

    mkdCode = { fg = palette.foam, italic = styles.italic },
    mkdCodeDelimiter = { fg = palette.rose },
    mkdCodeEnd = { fg = palette.foam },
    mkdCodeStart = { fg = palette.foam },
    mkdFootnotes = { fg = palette.foam },
    mkdID = { fg = palette.foam, underline = true },
    mkdInlineURL = { link = "markdownUrl" },
    mkdLink = { link = "markdownUrl" },
    mkdLinkDef = { link = "markdownUrl" },
    mkdListItemLine = { fg = palette.text },
    mkdRule = { fg = palette.subtle },
    mkdURL = { link = "markdownUrl" },

    --- Treesitter
    --- |:help treesitter-highlight-groups|
    ["@variable"] = { fg = palette.text, italic = styles.italic },
    ["@variable.builtin"] = { fg = palette.love, italic = styles.italic, bold = styles.bold },
    ["@variable.parameter"] = { fg = palette.iris, italic = styles.italic },
    ["@variable.parameter.builtin"] = { fg = palette.iris, italic = styles.italic, bold = styles.bold },
    ["@variable.member"] = { fg = palette.foam },

    ["@constant"] = { fg = palette.gold },
    ["@constant.builtin"] = { fg = palette.gold, bold = styles.bold },
    ["@constant.macro"] = { fg = palette.gold },

    ["@module"] = { fg = palette.text },
    ["@module.builtin"] = { fg = palette.text, bold = styles.bold },
    ["@label"] = { link = "Label" },

    ["@string"] = { link = "String" },
    -- ["@string.documentation"] = {},
    ["@string.regexp"] = { fg = palette.iris },
    ["@string.escape"] = { fg = palette.pine },
    ["@string.special"] = { link = "String" },
    ["@string.special.symbol"] = { link = "Identifier" },
    ["@string.special.url"] = { fg = groups.link },
    -- ["@string.special.path"] = {},

    ["@character"] = { link = "Character" },
    ["@character.special"] = { link = "Character" },

    ["@boolean"] = { link = "Boolean" },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Number" },
    ["@float"] = { link = "Number" },

    ["@type"] = { fg = palette.foam },
    ["@type.builtin"] = { fg = palette.foam, bold = styles.bold },
    -- ["@type.definition"] = {},

    ["@attribute"] = { fg = palette.iris },
    ["@attribute.builtin"] = { fg = palette.iris, bold = styles.bold },
    ["@property"] = { fg = palette.foam, italic = styles.italic },

    ["@function"] = { fg = palette.rose },
    ["@function.builtin"] = { fg = palette.rose, bold = styles.bold },
    -- ["@function.call"] = {},
    ["@function.macro"] = { link = "Function" },

    ["@function.method"] = { fg = palette.rose },
    ["@function.method.call"] = { fg = palette.iris },

    ["@constructor"] = { fg = palette.foam },
    ["@operator"] = { link = "Operator" },

    ["@keyword"] = { link = "Keyword" },
    -- ["@keyword.coroutine"] = {},
    -- ["@keyword.function"] = {},
    ["@keyword.operator"] = { fg = palette.subtle },
    ["@keyword.import"] = { fg = palette.pine },
    ["@keyword.storage"] = { fg = palette.foam },
    ["@keyword.repeat"] = { fg = palette.pine },
    ["@keyword.return"] = { fg = palette.pine },
    ["@keyword.debug"] = { fg = palette.rose },
    ["@keyword.exception"] = { fg = palette.pine },

    ["@keyword.conditional"] = { fg = palette.pine },
    ["@keyword.conditional.ternary"] = { fg = palette.pine },

    ["@keyword.directive"] = { fg = palette.iris },
    ["@keyword.directive.define"] = { fg = palette.iris },

    --- Punctuation
    ["@punctuation.delimiter"] = { fg = palette.subtle },
    ["@punctuation.bracket"] = { fg = palette.subtle },
    ["@punctuation.special"] = { fg = palette.subtle },

    --- Comments
    ["@comment"] = { link = "Comment" },
    -- ["@comment.documentation"] = {},

    ["@comment.error"] = { fg = groups.error },
    ["@comment.warning"] = { fg = groups.warn },
    ["@comment.todo"] = { fg = groups.todo, bg = groups.todo, blend = 15 },
    ["@comment.hint"] = { fg = groups.hint, bg = groups.hint, blend = 15 },
    ["@comment.info"] = { fg = groups.info, bg = groups.info, blend = 15 },
    ["@comment.note"] = { fg = groups.note, bg = groups.note, blend = 15 },

    --- Markup
    ["@markup.strong"] = { bold = styles.bold },
    ["@markup.italic"] = { italic = styles.italic },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },

    ["@markup.heading"] = { fg = palette.foam, bold = styles.bold },

    ["@markup.quote"] = { fg = palette.text },
    ["@markup.math"] = { link = "Special" },
    ["@markup.environment"] = { link = "Macro" },
    ["@markup.environment.name"] = { link = "@type" },

    -- ["@markup.link"] = {},
    ["@markup.link.markdown_inline"] = { fg = palette.subtle },
    ["@markup.link.label.markdown_inline"] = { fg = palette.foam },
    ["@markup.link.url"] = { fg = groups.link },

    -- ["@markup.raw"] = { bg = palette.surface },
    -- ["@markup.raw.block"] = { bg = palette.surface },
    ["@markup.raw.delimiter.markdown"] = { fg = palette.subtle },

    ["@markup.list"] = { fg = palette.pine },
    ["@markup.list.checked"] = { fg = palette.foam, bg = palette.foam, blend = 10 },
    ["@markup.list.unchecked"] = { fg = palette.text },

    -- Markdown headings
    ["@markup.heading.1.markdown"] = { link = "markdownH1" },
    ["@markup.heading.2.markdown"] = { link = "markdownH2" },
    ["@markup.heading.3.markdown"] = { link = "markdownH3" },
    ["@markup.heading.4.markdown"] = { link = "markdownH4" },
    ["@markup.heading.5.markdown"] = { link = "markdownH5" },
    ["@markup.heading.6.markdown"] = { link = "markdownH6" },
    ["@markup.heading.1.marker.markdown"] = { link = "markdownH1Delimiter" },
    ["@markup.heading.2.marker.markdown"] = { link = "markdownH2Delimiter" },
    ["@markup.heading.3.marker.markdown"] = { link = "markdownH3Delimiter" },
    ["@markup.heading.4.marker.markdown"] = { link = "markdownH4Delimiter" },
    ["@markup.heading.5.marker.markdown"] = { link = "markdownH5Delimiter" },
    ["@markup.heading.6.marker.markdown"] = { link = "markdownH6Delimiter" },

    ["@diff.plus"] = { fg = groups.git_add, bg = groups.git_add, blend = 20 },
    ["@diff.minus"] = { fg = groups.git_delete, bg = groups.git_delete, blend = 20 },
    ["@diff.delta"] = { bg = groups.git_change, blend = 20 },

    ["@tag"] = { link = "Tag" },
    ["@tag.attribute"] = { fg = palette.iris },
    ["@tag.delimiter"] = { fg = palette.subtle },

    --- Non-highlighting captures
    -- ["@none"] = {},
    ["@conceal"] = { link = "Conceal" },
    ["@conceal.markdown"] = { fg = palette.subtle },

    -- ["@spell"] = {},
    -- ["@nospell"] = {},

    --- Semantic
    ["@lsp.type.comment"] = {},
    ["@lsp.type.comment.c"] = { link = "@comment" },
    ["@lsp.type.comment.cpp"] = { link = "@comment" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.interface"] = { link = "@interface" },
    ["@lsp.type.keyword"] = { link = "@keyword" },
    ["@lsp.type.namespace"] = { link = "@namespace" },
    ["@lsp.type.namespace.python"] = { link = "@variable" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.variable"] = {}, -- defer to treesitter for regular variables
    ["@lsp.type.variable.svelte"] = { link = "@variable" },
    ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
    ["@lsp.typemod.operator.injected"] = { link = "@operator" },
    ["@lsp.typemod.string.injected"] = { link = "@string" },
    ["@lsp.typemod.variable.constant"] = { link = "@constant" },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    ["@lsp.typemod.variable.injected"] = { link = "@variable" },

    --- Plugins
    -- lewis6991/gitsigns.nvim
    GitSignsAdd = { fg = groups.git_add, bg = "NONE" },
    GitSignsChange = { fg = groups.git_change, bg = "NONE" },
    GitSignsDelete = { fg = groups.git_delete, bg = "NONE" },
    SignAdd = { fg = groups.git_add, bg = "NONE" },
    SignChange = { fg = groups.git_change, bg = "NONE" },
    SignDelete = { fg = groups.git_delete, bg = "NONE" },

    -- hrsh7th/nvim-cmp
    CmpItemAbbr = { fg = palette.subtle },
    CmpItemAbbrDeprecated = { fg = palette.subtle, strikethrough = true },
    CmpItemAbbrMatch = { fg = palette.text, bold = styles.bold },
    CmpItemAbbrMatchFuzzy = { fg = palette.text, bold = styles.bold },
    CmpItemKind = { fg = palette.subtle },
    CmpItemKindClass = { link = "StorageClass" },
    CmpItemKindFunction = { link = "Function" },
    CmpItemKindInterface = { link = "Type" },
    CmpItemKindMethod = { link = "PreProc" },
    CmpItemKindSnippet = { link = "String" },
    CmpItemKindVariable = { link = "Identifier" },

    -- nvim-telescope/telescope.nvim
    TelescopeBorder = make_border(),
    TelescopeMatching = { fg = palette.rose },
    TelescopeNormal = { link = "NormalFloat" },
    TelescopePromptNormal = { link = "TelescopeNormal" },
    TelescopePromptPrefix = { fg = palette.subtle },
    TelescopeSelection = { fg = palette.text, bg = palette.overlay },
    TelescopeSelectionCaret = { fg = palette.rose, bg = palette.overlay },
    TelescopeTitle = { fg = palette.foam, bold = styles.bold },

    -- rcarriga/nvim-dap-ui
    DapUIBreakpointsCurrentLine = { fg = palette.gold, bold = styles.bold },
    DapUIBreakpointsDisabledLine = { fg = palette.muted },
    DapUIBreakpointsInfo = { link = "DapUIThread" },
    DapUIBreakpointsLine = { link = "DapUIBreakpointsPath" },
    DapUIBreakpointsPath = { fg = palette.foam },
    DapUIDecoration = { link = "DapUIBreakpointsPath" },
    DapUIFloatBorder = make_border(),
    DapUIFrameName = { fg = palette.text },
    DapUILineNumber = { link = "DapUIBreakpointsPath" },
    DapUIModifiedValue = { fg = palette.foam, bold = styles.bold },
    DapUIScope = { link = "DapUIBreakpointsPath" },
    DapUISource = { fg = palette.iris },
    DapUIStoppedThread = { link = "DapUIBreakpointsPath" },
    DapUIThread = { fg = palette.gold },
    DapUIValue = { fg = palette.text },
    DapUIVariable = { fg = palette.text },
    DapUIType = { fg = palette.iris },
    DapUIWatchesEmpty = { fg = palette.love },
    DapUIWatchesError = { link = "DapUIWatchesEmpty" },
    DapUIWatchesValue = { link = "DapUIThread" },

    -- folke/trouble.nvim
    TroubleText = { fg = palette.subtle },
    TroubleCount = { fg = palette.iris, bg = palette.surface },
    TroubleNormal = { fg = palette.text, bg = groups.panel },

    -- nvim-treesitter/nvim-treesitter-context
    TreesitterContext = { bg = palette.overlay },
    TreesitterContextLineNumber = { fg = palette.rose, bg = palette.overlay },

    -- yetone/avante.nvim
    AvanteTitle = { fg = palette.highlight_high, bg = palette.rose },
    AvanteReversedTitle = { fg = palette.rose },
    AvanteSubtitle = { fg = palette.highlight_med, bg = palette.foam },
    AvanteReversedSubtitle = { fg = palette.foam },
    AvanteThirdTitle = { fg = palette.highlight_med, bg = palette.iris },
    AvanteReversedThirdTitle = { fg = palette.iris },
    AvantePromptInput = { fg = palette.text, bg = groups.panel },
    AvantePromptInputBorder = { fg = groups.border },

    -- Saghen/blink.cmp
    BlinkCmpDoc = { bg = palette.highlight_low },
    BlinkCmpDocSeparator = { bg = palette.highlight_low },
    BlinkCmpDocBorder = { fg = palette.highlight_high },
    BlinkCmpGhostText = { fg = palette.muted },

    BlinkCmpLabel = { fg = palette.muted },
    BlinkCmpLabelDeprecated = { fg = palette.muted, strikethrough = true },
    BlinkCmpLabelMatch = { fg = palette.text, bold = styles.bold },

    BlinkCmpDefault = { fg = palette.highlight_med },
    BlinkCmpKindText = { fg = palette.pine },
    BlinkCmpKindMethod = { fg = palette.foam },
    BlinkCmpKindFunction = { fg = palette.foam },
    BlinkCmpKindConstructor = { fg = palette.foam },
    BlinkCmpKindField = { fg = palette.pine },
    BlinkCmpKindVariable = { fg = palette.rose },
    BlinkCmpKindClass = { fg = palette.gold },
    BlinkCmpKindInterface = { fg = palette.gold },
    BlinkCmpKindModule = { fg = palette.foam },
    BlinkCmpKindProperty = { fg = palette.foam },
    BlinkCmpKindUnit = { fg = palette.pine },
    BlinkCmpKindValue = { fg = palette.love },
    BlinkCmpKindKeyword = { fg = palette.iris },
    BlinkCmpKindSnippet = { fg = palette.rose },
    BlinkCmpKindColor = { fg = palette.love },
    BlinkCmpKindFile = { fg = palette.foam },
    BlinkCmpKindReference = { fg = palette.love },
    BlinkCmpKindFolder = { fg = palette.foam },
    BlinkCmpKindEnum = { fg = palette.foam },
    BlinkCmpKindEnumMember = { fg = palette.foam },
    BlinkCmpKindConstant = { fg = palette.gold },
    BlinkCmpKindStruct = { fg = palette.foam },
    BlinkCmpKindEvent = { fg = palette.foam },
    BlinkCmpKindOperator = { fg = palette.foam },
    BlinkCmpKindTypeParameter = { fg = palette.iris },
    BlinkCmpKindCodeium = { fg = palette.foam },
    BlinkCmpKindCopilot = { fg = palette.foam },
    BlinkCmpKindSupermaven = { fg = palette.foam },
    BlinkCmpKindTabNine = { fg = palette.foam },
  }

  local transparency_highlights = {
    DiagnosticVirtualTextError = { fg = groups.error },
    DiagnosticVirtualTextHint = { fg = groups.hint },
    DiagnosticVirtualTextInfo = { fg = groups.info },
    DiagnosticVirtualTextOk = { fg = groups.ok },
    DiagnosticVirtualTextWarn = { fg = groups.warn },

    FloatBorder = { fg = palette.muted, bg = "NONE" },
    FloatTitle = { fg = palette.foam, bg = "NONE", bold = styles.bold },
    Folded = { fg = palette.text, bg = "NONE" },
    NormalFloat = { bg = "NONE" },
    Normal = { fg = palette.text, bg = "NONE" },
    NormalNC = { fg = palette.text, bg = "NONE" },
    Pmenu = { fg = palette.subtle, bg = "NONE" },
    PmenuExtra = { fg = palette.text, bg = "NONE" },
    PmenuKind = { fg = palette.foam, bg = "NONE" },
    SignColumn = { fg = palette.text, bg = "NONE" },
    StatusLine = { fg = palette.subtle, bg = "NONE" },
    StatusLineNC = { fg = palette.muted, bg = "NONE" },
    TabLine = { bg = "NONE", fg = palette.subtle },
    TabLineFill = { bg = "NONE" },
    TabLineSel = { fg = palette.text, bg = "NONE", bold = styles.bold },

    -- ["@markup.raw"] = { bg = "none" },
    ["@markup.raw.markdown_inline"] = { fg = palette.gold },
    -- ["@markup.raw.block"] = { bg = "none" },

    TelescopeNormal = { fg = palette.subtle, bg = "NONE" },
    TelescopePromptNormal = { fg = palette.text, bg = "NONE" },
    TelescopeSelection = { fg = palette.text, bg = "NONE", bold = styles.bold },
    TelescopeSelectionCaret = { fg = palette.rose },

    TroubleNormal = { bg = "NONE" },

    TreesitterContext = { bg = "NONE" },
    TreesitterContextLineNumber = { fg = palette.rose, bg = "NONE" },
  }

  local highlights = {}
  for group, highlight in pairs(default_highlights) do
    highlights[group] = highlight
  end
  if styles.transparency then
    for group, highlight in pairs(transparency_highlights) do
      highlights[group] = highlight
    end
  end

  for group, highlight in pairs(highlights) do
    if highlight.blend ~= nil and (highlight.blend >= 0 and highlight.blend <= 100) and highlight.bg ~= nil then
      highlight.bg = utilities.blend(highlight.bg, highlight.blend_on or palette.base, highlight.blend / 100)
    end

    highlight.blend = nil
    highlight.blend_on = nil

    if highlight._nvim_blend ~= nil then
      highlight.blend = highlight._nvim_blend
    end

    vim.api.nvim_set_hl(0, group, highlight)
  end

end

function M.colorscheme()

  vim.opt.termguicolors = true
  if vim.g.colors_name then
    vim.cmd("hi clear")
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "my-default"

  vim.o.background = "dark"


  set_highlights()
end

return M
