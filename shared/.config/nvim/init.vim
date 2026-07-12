" Change mapleader
let mapleader=","

let fancy_symbols_enabled = 1
set encoding=utf-8

" ============================================================================
" Vim-plug initialization

let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent !mkdir -p ~/.config/nvim/autoload
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1
endif

if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif

call plug#begin("~/.config/nvim/plugged")

" ============================================================================
" Plugins

" Language pack
Plug 'sheerun/vim-polyglot'

" Visual
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'marko-cerovac/material.nvim'
"Plug 'akinsho/bufferline.nvim'
Plug 'noib3/nvim-cokeline'

" Text editing
Plug 'Townk/vim-autoclose'
Plug 'tpope/vim-surround'
Plug 'michaeljsmith/vim-indent-object'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'valloric/MatchTagAlways'
Plug 'scrooloose/nerdcommenter'
Plug 'gcmt/wildfire.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Lint
"Plug 'mfussenegger/nvim-lint'

" Snippets
Plug 'juliosueiras/vim-terraform-snippets'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'andrewstuart/vim-kubernetes'

" Tags
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'vim-scripts/IndexedSearch'

" Status line
Plug 'kyazdani42/nvim-web-devicons'
Plug 'famiu/feline.nvim'

" Completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'APZelos/blamer.nvim'

" HTML
Plug 'mattn/emmet-vim'

" Misc
Plug 'arielrossanigo/dir-configs-override.vim'

" Archived
"Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
"Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
"Plug 'dense-analysis/ale'
"Plug 'mhinz/vim-signify'
"Plug 'mkarmona/colorsbox'
"Plug 'rmehri01/onenord.nvim', { 'branch': 'main' }
"Plug 'catppuccin/nvim'
"Plug 'neomake/neomake'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
"Plug 'ryanoasis/vim-devicons'
"Plug 'nvim-lualine/lualine.nvim'
"Plug 'roxma/nvim-yarp'
"Plug 'tpope/vim-rhubarb'
"Plug 'roxma/vim-hug-neovim-rpc'
"Plug 'Shougo/context_filetype.vim'
"Plug 't9md/vim-choosewin'
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
"Plug 'junegunn/fzf.vim'
"Plug 'fisadev/FixedTaskList.vim'
"Plug 'Shougo/deoplete.nvim'
"Plug 'deoplete-plugins/deoplete-jedi'
"Plug 'davidhalter/jedi-vim'

" Tell vim-plug we finished declaring plugins, so it can load them
call plug#end()

" POST


" ============================================================================
" Install plugins the first time vim runs

if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif

" ============================================================================
" Vim settings and mappings
" You can edit them as you wish
 
" A bunch of things that are set by default in neovim, but not in vim

" no vi-compatible
set nocompatible

" allow plugins by file type (required for plugins!)
filetype plugin on
filetype indent on

" always show status bar
set ls=2

" incremental search
set incsearch
" highlighted search results
set hlsearch

" syntax highlight on
syntax on

" better backup, swap and undos storage for vim (nvim has nice ones by
" default)
set directory=~/.vim/dirs/tmp     " directory to place swap files in
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo
" create needed directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

" tabs and spaces handling
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" show line numbers
set nu

" remove ugly vertical lines on window division
set fillchars+=vert:\ 

" needed so deoplete can auto select the first suggestion
set completeopt+=noinsert
" comment this line to enable autocompletion preview window
" (displays documentation related to the selected completion option)
" disabled by default because preview makes the window flicker
set completeopt-=preview

set completeopt=menu,menuone,noselect


" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

" save as sudo
ca w!! w !sudo tee "%"

" tab navigation mappings
map tt :tabnew 
map <M-Right> :tabn<CR>
imap <M-Right> <ESC>:tabn<CR>
map <M-Left> :tabp<CR>
imap <M-Left> <ESC>:tabp<CR>

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" clear search results
nnoremap <silent> // :noh<CR>

" clear empty spaces at the end of lines on save of python files
autocmd BufWritePre *.py :%s/\s\+$//e

" fix problems with uncommon shells (fish, xonsh) and plugins running commands
" (neomake, ...)
set shell=/bin/bash 

" Ability to add python breakpoints
" (I use ipdb, but you can change it to whatever tool you use for debugging)
au FileType python map <silent> <leader>b Oimport ipdb; ipdb.set_trace()<esc>


" ============================================================================
" Plugins settings and mappings
" Edit them as you wish.

" Tagbar -----------------------------

" toggle tagbar display
map <F4> :TagbarToggle<CR>
" autofocus on tagbar open
let g:tagbar_autofocus = 1

" NERDTree -----------------------------

" toggle nerdtree display
map <F3> :NERDTreeToggle<CR>
" open nerdtree with the current file selected
"nmap ,t :NERDTreeFind<CR>
" don;t show these file types
let NERDTreeIgnore = ['\.pyc$', '\.pyo$']

" Enable folder icons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

" Fix directory colors
highlight! link NERDTreeFlags NERDTreeDir

" Remove expandable arrow
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
let NERDTreeDirArrowExpandable = "\u00a0"
let NERDTreeDirArrowCollapsible = "\u00a0"
let NERDTreeNodeDelimiter = "\x07"

" Autorefresh on tree focus
function! NERDTreeRefresh()
    if &filetype == "nerdtree"
        silent exe substitute(mapcheck("R"), "<CR>", "", "")
    endif
endfunction

autocmd BufEnter * call NERDTreeRefresh()

" Neomake ------------------------------

" Lint
"au BufWritePost <buffer> lua require('lint').try_lint()
"

" Golang  ------------------------------
autocmd BufWritePost *.go !gofmt -w %

" Telescope ------------------------------

nmap <leader>t :Telescope find_files<CR>
nmap <leader>e :lua require('telescope.builtin').tags{only_sort_tags=true}<CR>
nmap <leader>f :Telescope live_grep<CR>
nmap <leader>i :Telescope diagnostics<CR>

" Autoclose ------------------------------

" Fix to let ESC work as espected with Autoclose plugin
" (without this, when showing an autocompletion window, ESC won't leave insert
"  mode)
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}

" Fancy Symbols!!

let g:webdevicons_enable = 1
"
" Custom configurations ----------------

" Include user's custom nvim configurations
let custom_configs_path = "~/.config/nvim/custom.vim"
if filereadable(expand(custom_configs_path))
  execute "source " . custom_configs_path
endif

" Split movement bindings
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Create default mappings
let g:NERDCreateDefaultMappings = 1

set clipboard+=unnamedplus
set cursorline
set termguicolors
set nonumber
set nowrap

" Go-to-next-tag mapping
nnoremap ; :tnext<CR>

" Blamer
let g:blamer_enabled = 1
let g:blamer_delay = 500
let g:blamer_relative_time = 1

" Improve how completion works
inoremap <expr> <tab>   pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

autocmd FileType javascript setlocal ts=2 sts=2 sw=2

" Set border character
set fillchars+=vert:\|

" ============================================================================
" Lua config

lua << EOF

local lsp = require "lspconfig"
lsp.tsserver.setup{}

require('gitsigns').setup{}
require('feline').setup()

require('telescope').setup{
    defaults = {
        file_ignore_patterns = {"vendor"},
        mappings = {
            i = {
                ["<esc>"] = require("telescope.actions").close,
            },
        },
    }
}

require('telescope').setup{ defaults = {  } }

require('telescope').load_extension('fzf')

require('material').setup({
    borders = true,
})
require('material.functions').change_style("deep ocean")

require('cokeline').setup()

local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i" }),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig')['pylsp'].setup {
  capabilities = capabilities,

  settings = {
    -- configure plugins in pylsp
    pylsp = {
      configurationSources = {'flake8'},
      plugins = {
        --flake8 = { enabled = true, },
        flake8 = { enabled = false, },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
      },
    },
  },
}

lspconfig = require "lspconfig"
util = require "lspconfig/util"

lspconfig.gopls.setup {
cmd = {"gopls", "serve"},
filetypes = {"go", "gomod"},
root_dir = util.root_pattern("go.work", "go.mod", ".git"),
settings = {
  gopls = {
    analyses = {
      unusedparams = true,
    },
    staticcheck = true,
  },
},
}

local map = vim.api.nvim_set_keymap
map('n', '<Leader>`',   '<Plug>(cokeline-focus-prev)',  { silent = true })
map('n', '<Leader><Tab>',     '<Plug>(cokeline-focus-next)',  { silent = true })

EOF
