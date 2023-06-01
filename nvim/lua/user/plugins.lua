local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').reset()

local pac = require('packer')
pac.init({
    max_jobs = 10,
  })
require('packer').init({
  compile_path = vim.fn.stdpath('data')..'/site/plugin/packer_compiled.lua',
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'solid' })
    end,
  },
})

local use = pac.use

-- Packer can manage itself.
use('wbthomason/packer.nvim')

-- One Dark theme.
use({
  'jessarcher/onedark.nvim',
  config = function()
    vim.cmd('colorscheme onedark')

    vim.api.nvim_set_hl(0, 'FloatBorder', {
      fg = vim.api.nvim_get_hl_by_name('NormalFloat', true).background,
      bg = vim.api.nvim_get_hl_by_name('NormalFloat', true).background,
    })

    -- Make the cursor line background invisible
    vim.api.nvim_set_hl(0, 'CursorLineBg', {
      fg = vim.api.nvim_get_hl_by_name('CursorLine', true).background,
      bg = vim.api.nvim_get_hl_by_name('CursorLine', true).background,
    })

    vim.api.nvim_set_hl(0, 'NvimTreeIndentMarker', { fg = '#30323E' })

    vim.api.nvim_set_hl(0, 'StatusLineNonText', {
      fg = vim.api.nvim_get_hl_by_name('NonText', true).foreground,
      bg = vim.api.nvim_get_hl_by_name('StatusLine', true).background,
    })

    vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { fg = '#2F313C' })
  end,
})
-- Commenting support.
use('tpope/vim-commentary')

-- Add, change, and delete surrounding text.
use('tpope/vim-surround')

-- Useful commands like :Rename and :SudoWrite.
use('tpope/vim-eunuch')

-- Pairs of handy bracket mappings, like [b and ]b.
use('tpope/vim-unimpaired')

-- Indent autodetection with editorconfig support.
use('tpope/vim-sleuth')

-- Allow plugins to enable repeating of commands.
use('tpope/vim-repeat')

-- Add more languages.
use('sheerun/vim-polyglot')

-- Navigate seamlessly between Vim windows and Tmux panes.
use('christoomey/vim-tmux-navigator')

-- Jump to the last location when opening a file.
use('farmergreg/vim-lastplace')

-- Enable * searching with visually selected text.
use('nelstrom/vim-visual-star-search')

-- Automatically create parent dirs when saving.
use('jessarcher/vim-heritage')

-- Text objects for HTML attributes.
use({
  'whatyouhide/vim-textobj-xmlattr',
  requires = 'kana/vim-textobj-user',
})

-- Automatically set the working directory to the project root.
use({
  'airblade/vim-rooter',
  setup = function()
    -- Instead of this running every time we open a file, we'll just run it once when Vim starts.
    vim.g.rooter_manual_only = 1
  end,
  config = function()
    vim.cmd('Rooter')
  end,
})

-- Automatically add closing brackets, quotes, etc.
use({
  'windwp/nvim-autopairs',
  config = function()
    require('nvim-autopairs').setup()
  end,
})

-- Add smooth scrolling to avoid jarring jumps
use({
  'karb94/neoscroll.nvim',
  config = function()
    require('neoscroll').setup()
  end,
})

-- All closing buffers without closing the split window.
use({
  'famiu/bufdelete.nvim',
  config = function()
    vim.keymap.set('n', '<Leader>q', ':Bdelete<CR>')
  end,
})

-- Split arrays and methods onto multiple lines, or join them back up.
use({
  'AndrewRadev/splitjoin.vim',
  config = function()
    vim.g.splitjoin_html_attributes_bracket_on_new_line = 1
    vim.g.splitjoin_trailing_comma = 1
    vim.g.splitjoin_php_method_chain_full = 1
  end,
})

-- Automatically fix indentation when pasting code.
use({
  'sickill/vim-pasta',
  config = function()
    vim.g.pasta_disabled_filetypes = { 'fugitive' }
  end,
})

use({
  'nvim-telescope/telescope.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',
    'nvim-telescope/telescope-live-grep-args.nvim',
    'natecraddock/telescope-zf-native.nvim',
  },
  config = function()
    local actions = require('telescope.actions')

	vim.cmd([[
	  highlight link TelescopePromptTitle PMenuSel
	  highlight link TelescopePreviewTitle PMenuSel
	  highlight link TelescopePromptNormal NormalFloat
	  highlight link TelescopePromptBorder FloatBorder
	  highlight link TelescopeNormal CursorLine
	  highlight link TelescopeBorder CursorLineBg
	]])

	require('telescope').setup({
	  defaults = {
		path_display = { truncate = 1 },
		prompt_prefix = '   ',
		selection_caret = '  ',
		layout_config = {
		  prompt_position = 'top',
		},
		sorting_strategy = 'ascending',
		mappings = {
		  i = {
			['<esc>'] = actions.close,
			['<C-Down>'] = actions.cycle_history_next,
			['<C-Up>'] = actions.cycle_history_prev,
		  },
		},
		file_ignore_patterns = { '.git/' },
	  },
	  pickers = {
		find_files = {
		  hidden = true,
		},
		buffers = {
		  previewer = false,
		  layout_config = {
			width = 80,
		  },
		},
		oldfiles = {
		  prompt_title = 'History',
		},
		lsp_references = {
		  previewer = false,
		},
	  },
	})

	require('telescope').load_extension('zf-native')
	require('telescope').load_extension('live_grep_args')

	vim.keymap.set('n', '<leader>f', [[<cmd>lua require('telescope.builtin').find_files()<CR>]])
	vim.keymap.set('n', '<leader>F', [[<cmd>lua require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' })<CR>]])
	vim.keymap.set('n', '<leader>b', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
	vim.keymap.set('n', '<leader>g', [[<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>]])
	vim.keymap.set('n', '<leader>h', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]])
	vim.keymap.set('n', '<leader>s', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])
  end,
})

-- File tree sidebar
use({
  'kyazdani42/nvim-tree.lua',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    require('nvim-tree').setup({
	  git = {
		ignore = false,
	  },
	  view = {
	    width = 70
	  },
	  renderer = {
		group_empty = true,
		icons = {
		  show = {
			folder_arrow = false,
		  },
		},
		indent_markers = {
		  enable = true,
		},
	  },
	})

	vim.keymap.set('n', '<Leader>n', ':NvimTreeFindFileToggle<CR>')
  end,
})

-- A Status line.
use({
  'nvim-lualine/lualine.nvim',
  requires = 'kyazdani42/nvim-web-devicons',
  config = function()
    local separator = { '"▏"', color = 'StatusLineNonText' }

	require('lualine').setup({
	  options = {
		section_separators = '',
		component_separators = '',
		globalstatus = true,
		theme = {
		  normal = {
			a = 'StatusLine',
			b = 'StatusLine',
			c = 'StatusLine',
		  },
		},
	  },
	  sections = {
		lualine_a = {
		  'mode',
		  separator,
		},
		lualine_b = {
		  'branch',
		  'diff',
		  separator,
		  '"🖧  " .. tostring(#vim.tbl_keys(vim.lsp.buf_get_clients()))',
		  { 'diagnostics', sources = { 'nvim_diagnostic' } },
		  separator,
		},
		lualine_c = {
		  'filename'
		},
		lualine_x = {
		  'filetype',
		  'encoding',
		  'fileformat',
		},
		lualine_y = {
		  separator,
		  '(vim.bo.expandtab and "␠ " or "⇥ ") .. " " .. vim.bo.shiftwidth',
		  separator,
		},
		lualine_z = {
		  'location',
		  'progress',
		},
	  },
	})
  end,
})

-- Display buffers as tabs.
use({
  'akinsho/bufferline.nvim',
  requires = 'kyazdani42/nvim-web-devicons',
  after = 'onedark.nvim',
  config = function()
    require('bufferline').setup({
	  options = {
		indicator = {
		  icon = ' ',
		},
		show_close_icon = false,
		tab_size = 0,
		max_name_length = 25,
		offsets = {
		  {
			filetype = 'NvimTree',
			text = '  Files',
			highlight = 'StatusLine',
			text_align = 'left',
		  },
		},
		separator_style = 'slant',
		modified_icon = '',
		custom_areas = {
		  left = function()
			return {
			  { text = '    ', fg = '#8fff6d' },
			}
		  end,
		},
	  },
	  highlights = {
		fill = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
		background = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
		tab = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
		tab_close = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
		close_button = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		  fg = { attribute = 'fg', highlight = 'StatusLineNonText' },
		},
		close_button_visible = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		  fg = { attribute = 'fg', highlight = 'StatusLineNonText' },
		},
		close_button_selected = {
		  fg = { attribute = 'fg', highlight = 'StatusLineNonText' },
		},
		buffer_visible = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
		modified = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
		modified_visible = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
		duplicate = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
		duplicate_visible = {
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
		separator = {
		  fg = { attribute = 'bg', highlight = 'StatusLine' },
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
		separator_selected = {
		  fg = { attribute = 'bg', highlight = 'StatusLine' },
		  bg = { attribute = 'bg', highlight = 'Normal' }
		},
		separator_visible = {
		  fg = { attribute = 'bg', highlight = 'StatusLine' },
		  bg = { attribute = 'bg', highlight = 'StatusLine' },
		},
	  },
	})
  end,
})

-- Display indentation lines.
use({
  'lukas-reineke/indent-blankline.nvim',
  config = function()
    require('indent_blankline').setup()
  end,
})

use({
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup({current_line_blame = true})
    vim.keymap.set('n', ']h', ':Gitsigns next_hunk<CR>')
    vim.keymap.set('n', '[h', ':Gitsigns prev_hunk<CR>')
    vim.keymap.set('n', 'gs', ':Gitsigns stage_hunk<CR>')
    vim.keymap.set('n', 'gS', ':Gitsigns undo_stage_hunk<CR>')
    vim.keymap.set('n', 'gp', ':Gitsigns preview_hunk<CR>')
    vim.keymap.set('n', 'gb', ':Gitsigns blame_line<CR>')
  end,
})

-- Git commands.
use({
  'tpope/vim-fugitive',
  requires = 'tpope/vim-rhubarb',
})

--- Floating terminal.
use({
  'voldikss/vim-floaterm',
  config = function()
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.keymap.set('n', '<F1>', ':FloatermToggle<CR>')
    vim.keymap.set('t', '<F1>', '<C-\\><C-n>:FloatermToggle<CR>')
    vim.cmd([[
      highlight link Floaterm CursorLine
      highlight link FloatermBorder CursorLineBg
    ]])
  end
})

-- Improved syntax highlighting
use({
  'nvim-treesitter/nvim-treesitter',
  run = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  requires = {
    'JoosepAlviste/nvim-ts-context-commentstring',
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    require('nvim-treesitter.configs').setup({
	  ensure_installed = 'all',
	  highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
	  },
	  context_commentstring = {
		enable = true,
	  },
	  textobjects = {
		select = {
		  enable = true,
		  lookahead = true,
		  keymaps = {
			['if'] = '@function.inner',
			['af'] = '@function.outer',
			['ia'] = '@parameter.inner',
			['aa'] = '@parameter.outer',
		  },
		}
	  }
	})
  end,
})

-- Language Server Protocol.
use({
  'neovim/nvim-lspconfig',
  requires = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'b0o/schemastore.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'jayp0521/mason-null-ls.nvim',
  },
  config = function()
      -- Setup Mason to automatically install LSP servers
      require('mason').setup()
      require('mason-lspconfig').setup({ automatic_installation = true })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- PHP
      require('lspconfig').intelephense.setup({ capabilities = capabilities })

      -- Vue, JavaScript, TypeScript
      require('lspconfig').volar.setup({
	capabilities = capabilities,
	-- Enable "Take Over Mode" where volar will provide all JS/TS LSP services
	-- This drastically improves the responsiveness of diagnostic updates on change
	filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      })

      -- Tailwind CSS
      require('lspconfig').tailwindcss.setup({ capabilities = capabilities })

      -- JSON
      require('lspconfig').jsonls.setup({
	capabilities = capabilities,
	settings = {
	  json = {
	    schemas = require('schemastore').json.schemas(),
	  },
	},
      })

      -- null-ls
      require('null-ls').setup({
	sources = {
	  require('null-ls').builtins.diagnostics.eslint_d.with({
	    condition = function(utils)
	      return utils.root_has_file({ '.eslintrc.js' })
	    end,
	  }),
	  require('null-ls').builtins.diagnostics.trail_space.with({ disabled_filetypes = { 'NvimTree' } }),
	  require('null-ls').builtins.formatting.eslint_d.with({
	    condition = function(utils)
	      return utils.root_has_file({ '.eslintrc.js' })
	    end,
	  }),
	  require('null-ls').builtins.formatting.prettierd,
	},
      })

      require('mason-null-ls').setup({ automatic_installation = true })

      -- Keymaps
      vim.keymap.set('n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>')
      vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
      vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
      vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>')
      vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>')
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
      vim.keymap.set('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')

      -- Commands
      vim.api.nvim_create_user_command('Format', vim.lsp.buf.format, {})

      -- Diagnostic configuration
      vim.diagnostic.config({
	virtual_text = false,
	float = {
	  source = true,
	}
      })

      -- Sign configuration
      vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
      vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
      vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
      vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
    end,
})

-- Completion
use({
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'onsails/lspkind-nvim',
  },
  config = function()
    local cmp = require('cmp')
	local luasnip = require('luasnip')
	local lspkind = require('lspkind')

	require('luasnip/loaders/from_snipmate').lazy_load()

	local has_words_before = function()
	  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	cmp.setup({
	  snippet = {
		expand = function(args)
		  luasnip.lsp_expand(args.body)
		end,
	  },
	  formatting = {
		format = lspkind.cmp_format(),
	  },
	  mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			cmp.select_next_item()
		  elseif luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		  elseif has_words_before() then
			cmp.complete()
		  else
			fallback()
		  end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
		  if cmp.visible() then
			cmp.select_prev_item()
		  elseif luasnip.jumpable(-1) then
			luasnip.jump(-1)
		  else
			fallback()
		  end
		end, { "i", "s" }),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	  },
	  sources = {
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'luasnip' },
		{ name = 'buffer' },
		{ name = 'path' },
	  },
	  experimental = {
		ghost_text = true,
	  },
	})
  end,
})

-- PHP Refactoring Tools
use({
  'phpactor/phpactor',
  ft = 'php',
  run = 'composer install --no-dev --optimize-autoloader --ignore-platform-reqs',
  config = function()
    vim.keymap.set('n', '<Leader>cm', ':PhpactorContextMenu<CR>')
    vim.keymap.set('n', '<Leader>cn', ':PhpactorClassNew<CR>')
  end,
})

-- Automatically set up your configuration after cloning packer.nvim
if packer_bootstrap then
    require('packer').sync()
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile>
  augroup end
]])
