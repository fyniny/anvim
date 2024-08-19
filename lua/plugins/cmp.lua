local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1].sub(col, col):match "%s" == nil
end

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-emoji",
    "jc-doyle/cmp-pandoc-references",
    "kdheepak/cmp-latex-symbols",
  },
  opts = function(_, opts)
    local cmp = require "cmp"
    opts.completion = {
      completeopt = "menu,menuone,noinsert",
    }
    opts.sources = cmp.config.sources {
      { name = "nvim_lsp", priority = 1000 },
      { name = "luasnip", priority = 900 },
      { name = "path", priority = 750 },
      { name = "pandoc_references", priority = 725 },
      { name = "latex_symbols", priority = 700 },
      { name = "emoji", priority = 700 },
      { name = "calc", priority = 650 },
      { name = "buffer", priority = 250 },
    }

    -- 这里有毒，lua的map和其他语言的map可能语法不一样，不能单个复制，这里需要填入一个大map中
    opts.mapping = {
      ["<CR>"] = cmp.config.disable,
      ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
      ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
      ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
      ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
      ["<Tab>"] = cmp.mapping(function(fallback)
        -- idea输入方式
        if cmp.visible() then
          local entry = cmp.get_selected_entry()
          if not entry then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
          else
            if has_words_before() then
              cmp.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
              }
            else
              cmp.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = false,
              }
            end
          end
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.config.disable,
    }
    return opts
  end,
}
