-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
-- The list of available LSPs can be found here: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
return {
  clangd = {},
  -- gopls = {},
  pyright = {},
  rust_analyzer = {},
  ts_ls = {},
  elmls = {},
  html = { filetypes = { 'html', 'twig', 'hbs'} },
  yamlls = {},
  bashls = {},
  biome = {},
  tinymist = {},

  lua_ls = {
    -- cmd = { ... },
    -- filetypes = { ... },
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
}
