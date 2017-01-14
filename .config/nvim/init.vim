call plug#begin('~/.config/nvim/plugged')

Plug 'pangloss/vim-javascript'
Plug 'walm/jshint.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'mattn/emmet-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'fholgado/minibufexpl.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'scrooloose/nerdtree'
Plug 'jtratner/vim-flavored-markdown'
Plug 'scrooloose/nerdcommenter'
Plug 'rking/ag.vim'
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/syntastic'
Plug 'valloric/MatchTagAlways'
Plug 'Lokaltog/vim-easymotion'
Plug 'gcmt/wildfire.vim'
Plug 'tpope/vim-surround'
Plug 'docunext/closetag.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'fatih/vim-go'
Plug 'jiangmiao/auto-pairs'
Plug 'vimwiki/vimwiki'
Plug 'PeterRincker/vim-argumentative'
Plug 'leafgarland/typescript-vim'
Plug 'mkarmona/colorsbox'
Plug 'mxw/vim-jsx'
Plug 'floobits/floobits-neovim'
Plug 'tpope/vim-fireplace'
Plug 'klen/python-mode'

call plug#end()

" Change mapleader
let mapleader=","

" Theme
colorscheme colorsbox-stnight

" Powerline font
let g:airline_powerline_fonts = 1

" Split movement bindings
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Toggle NERDTree
map <leader>n :NERDTreeToggle<CR>

" CtrlP mappings
let g:ctrlp_map = '<leader>t'
nmap <leader>r :CtrlPTag<cr>

" Go-to-next-tag mapping
nnoremap ; :tnext<CR>

" Cycle through buffers
nmap <leader><Tab> :MBEbn<CR>
nmap <leader>` :MBEbp<CR>

" Ag search
nmap <leader>f :Ag! 

" Centralize backups, swapfiles and undo history
set backup
set backupdir=~/.config/nvim/backups
set directory=~/.config/nvim/swaps
set undofile
set undodir=~/.config/nvim/undo

" Easymotion binding and config
nmap <space> <Plug>(easymotion-s2)
let g:EasyMotion_smartcase = 1

" Deoplete settings
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

" Don't require .jsx for syntax highlighting
let g:jsx_ext_required = 0

" Syntastic checkers
let g:syntastic_javascript_checkers = ['eslint']

" Python-mode
let g:pymode_lint = 1
let g:pymode_lint_unmodified = 1
let g:pymode_lint_ignore = 'E501,W'
let g:pymode_folding = 0
let g:pymode_rope_completion = 0
let g:pymode_options = 0
let g:pymode_run = 0

" Misc
set clipboard+=unnamedplus
set cursorline
set expandtab
set gdefault
set hidden
set hlsearch
set ignorecase
set incsearch
set nowrap
set shiftwidth=2
set splitright
set tabstop=2
set wildchar=<TAB>
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*.pyc,*.egg-info,dist
set wildignore+=*/smarty/*,*/vendor/*,*/node_modules/*,*/.git/*,*/.hg/*,*/.svn/*,*/.sass-cache/*,*/log/*,*/tmp/*,*/build/*,*/ckeditor/*,*/doc/*
set termguicolors
