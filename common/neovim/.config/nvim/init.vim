"
"    ____  ____   ___  _     
"   |  _ \|  _ \ / _ \( )___ 
"   | |_) | | | | | | |// __|
"   |  _ <| |_| | |_| | \__ \  --->  NeoVim configs
"   |_| \_\____/ \___/  |___/
"                            
"

set nocompatible              " be iMproved, required
filetype off                  " required

"{{{1 => Vundle for Managing Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" set the runtime path to include Vundle and initialize
set rtp+=~/.local/share/nvim/bundle/Vundle.vim

call vundle#begin()		" required, all plugins must appear after this line.
                                "call vundle#begin('~/some/path/here')

"{{ The Basics }}
    Plugin 'VundleVim/Vundle.vim'                        " let Vundle manage Vundle, required
"   Plugin 'itchyny/lightline.vim'                       " Lightline statusbar
    Plugin 'vim-airline/vim-airline'                     " Airline statusbar
    Plugin 'suan/vim-instant-markdown', {'rtp': 'after'} " Markdown Preview

"{{ Syntax Highlighting and Colors }}
    Plugin 'kovetskiy/sxhkd-vim'                         " sxhkd highlighting
    Plugin 'vim-python/python-syntax'                    " Python highlighting
    Plugin 'ap/vim-css-color'                            " Color previews for CSS

"{{ Themes }}
    Plugin 'morhetz/gruvbox'                             " gruvbox theme (colorscheme gruvbox // set background=dark/light)
    Plugin 'dracula/vim', { 'name': 'dracula' }          " dracula theme (colorscheme dracula // set background=dark/light)


"{{ File management }}
"    Plugin 'vifm/vifm.vim'                               " Vifm
"    Plugin 'scrooloose/nerdtree'                         " Nerdtree
"    Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'     " Highlighting Nerdtree
"    Plugin 'ryanoasis/vim-devicons'                      " Icons for Nerdtree
"{{ Productivity }}
"    Plugin 'vimwiki/vimwiki'                             " VimWiki 
"    Plugin 'jreybert/vimagit'                            " Magit-like plugin for vim

"{{ Junegunn Choi Plugins }}
"    Plugin 'junegunn/goyo.vim'                           " Distraction-free viewing
"    Plugin 'junegunn/limelight.vim'                      " Hyperfocus on a range


call vundle#end()            " required, all Plugins appear before this line

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"}}}1

"{{{1 => General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" COMMENTS CANNOT BE ADDED TO THE SAME LINE OF KEY MAPPINGS !!

set expandtab                 "turns tabs into spaces
set ignorecase                "ignore case sensitive search
set nobackup                  "doesn't set backups
syntax enable                 "enable syntax
"set relativenumber           "turn on relative numbers (rnu)
                              "turn off relative numbers (nornu)
set number                    "show line numbers (nu)
set incsearch                 "incremental search (highlights text while typing
set foldmethod=marker         "marker fold method
set autoindent                "auto indent text"
set laststatus=2              "show a white bar that hightlights the current working file
set noswapfile                "do not create swap files
set t_Co=256                  "Set if term supports 256 colors.
set path+=**                  "Searches current directory recursively.
set mouse=a                   "move the cursor with mouse clicks, also move between  (splitted windows)
set title                     "show title 
set clipboard=unnamedplus     "Copy/paste between vim and other programs.

"ctrl+s saves a file (if location already given)
nnoremap <C-s> :w<CR>

"f,F acts like i,I entering insert mode while in normal/visual
nnoremap f <insert>
nnoremap F <Home><insert>
"vnoremap F <Home><insert>

colorscheme dracula
"colorscheme dracula
"set background=dark
"set background=light


" saves/restore file views for any file
augroup remember_folds
autocmd!
autocmd BufWinLeave * mkview
autocmd BufWinEnter * silent! loadview
augroup END


" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab                   " Use spaces instead of tabs.
set smarttab                    " Be smart using tabs ;)
set shiftwidth=2                " One tab == two spaces.
set tabstop=2                   " One tab == two spaces.
"}}}1


"{{{1 => Splits
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" new split appears bellow/right
set splitbelow splitright

" Removes pipes | that act as seperators on splits
set fillchars+=vert:\

"  ctrl + w, R  =>  swap splits
"  ctrl + w,c   =>  close splits
"  :vs|:terminal => open a terminal inside a vertical split

" Cycle thru splits with  ','  while in normal mode
nnoremap , <C-w>w

" Adjusting split sizes easily
" ctrl + left,up,down,right  keys
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" change 2 split windows from vert to horiz  or  horiz to vert
" use  \ + hh
" use  \ + vv
map <Leader>hh <C-w>t<C-w>H
map <Leader>vv <C-w>t<C-w>K
"}}}1
