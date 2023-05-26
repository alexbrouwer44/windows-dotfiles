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
    require('lualine').setup()
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
    require('gitsigns').setup()
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
-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugins
if packer_bootstrap then
    require('packer').sync()
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile>
  augroup end
]])
