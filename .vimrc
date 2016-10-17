" ###############################
"          VUNDLE SETUP
" ###############################

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'Lokaltog/vim-powerline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-rails'
Plugin 'scrooloose/syntastic'
Plugin 'vim-ruby/vim-ruby'
Plugin 'janko-m/vim-test'
Plugin 'fatih/vim-go'
Plugin 'slim-template/vim-slim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'ap/vim-css-color'
Plugin 'rizzatti/dash.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'Valloric/YouCompleteMe'
Plugin 'ngmy/vim-rubocop'
Plugin 'tpope/vim-endwise'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jiangmiao/auto-pairs'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" ######################
"      CUSTOM SETUP
" ######################

" Leader
let mapleader = ","

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
:au FocusLost * silent! wa   " Autosave all buffers when window loses focus
set autoread      " Automatically refresh anytime something else changes a file
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Use one space, not two, after punctuation.
set nojoinspaces

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set relativenumber
set number
set numberwidth=5

" Automatically delete trailing whitespace
autocmd BufWritePre *.rb :%s/\s\+$//e

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Down> ddp
nnoremap <Up> ddkP

vnoremap <Left> :echoe "Use h"<CR>
vnoremap <Right> :echoe "Use l"<CR>
vnoremap <Up> :echoe "Use k"<CR>
vnoremap <Down> :echoe "Use j"<CR>

" Open Dash with <leader>-d
nnoremap <leader>d :Dash<CR>

" Toggle NERDTree with <leader>-nt
nnoremap <leader>nt :NERDTreeToggle<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Set faster folding commands
set foldmethod=indent
set nofoldenable
noremap <leader>f zc
nnoremap <leader>uf za

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Add some custom words to avoid common misspellings
iab bandwith bandwidth

" Add ability to copy to OS clipboard instead of buffer
nnoremap <leader>yc :w !pbcopy<CR>

" Add some shortcuts for rails.vim helpers
nnoremap <leader>ga :AS<CR>
nnoremap <leader>gr :RS<CR>

" Add shortcut for pulling line up to previous line
nnoremap <leader>J kJx

" Auto-indent and format!
nnoremap <leader>fmt gg=G

" Easier navigation between panes - Ctrl-h, Ctrl-j, Ctrl-k, & Ctrl-l
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Shortcuts for vim-test
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>tn :TestNearest<CR>

" Set comment stuff
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1

" Enabling Solarized dark color scheme
syntax enable
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers = ['rubocop']

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

