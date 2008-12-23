" Use Vim settings, rather then Vi settings
" This must be first, because it changes other options as a side effect.
set nocompatible

" syntax highlight on
syntax on

" no line wrapping
set nowrap

" expand tabs to spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smarttab
set expandtab

" automatic indenting
set autoindent

" smart indenting
set smartindent

" incremental search
set incsearch
set hlsearch

" turn off current search highlights
map <c-h> :nohlsearch<CR>
imap <c-h> <Esc>:nohlsearch<CR>i

" allow cursor keys to wrap to next/previous line
set whichwrap+=<,>,h,l,[,]

" show autocomplete menus
set wildmenu
set wildignore+=*.pyc,*.zip,*.gz,*.bz,*.tar,*.jpg,*.png,*.gif,*.avi,*.wmv,*.ogg,*.mp3,*.mov

" ctrl-pageup/down are already mapped to switch to the next/previous tabs.
" however "screen" garbles them
map <Esc>[5;5~ <C-PageUp>
map <Esc>[6;5~ <C-PageDown>
imap <Esc>[5;5~ <C-PageUp>
imap <Esc>[6;5~ <C-PageDown>
map <Esc>[1;5H <C-Home>
map <Esc>[1;5F <C-End>
imap <Esc>[1;5H <C-Home>
imap <Esc>[1;5F <C-End>
map <Esc>[1;2C <s-right>
map <Esc>[1;2D <s-left>
imap <Esc>[1;2C <s-right>
imap <Esc>[1;2D <s-left>
map <Esc>[1;2A <s-up>
map <Esc>[1;2B <s-down>
imap <Esc>[1;2A <s-up>
imap <Esc>[1;2B <s-down>
map <Esc>[1;2H <s-home>
map <Esc>[1;2F <s-end>
imap <Esc>[1;2H <s-home>
imap <Esc>[1;2F <s-end>
map <Esc>[1;5C <c-right>
map <Esc>[1;5D <c-left>
imap <Esc>[1;5C <c-right>
imap <Esc>[1;5D <c-left>
map <Esc>[1;6C <s-c-right>
map <Esc>[1;6D <s-c-left>
imap <Esc>[1;6C <s-c-right>
imap <Esc>[1;6D <s-c-left>

" some other tab shortcuts
map <c-k> :tabnext<CR>
map <c-j> :tabprevious<CR>
map <c-n> :tabnew<CR>
"map <c-e> :tabclose<CR>
imap <c-k> <Esc>:tabnext<CR>i
imap <c-j> <Esc>:tabprevious<CR>i
imap <c-n> <Esc>:tabnew<CR>i
"imap <c-e> <Esc>:tabclose<CR>i

" movement shortcuts
map <c-left> b
map <c-right> w
imap <c-left> <Esc>bi
imap <c-right> <Esc>wwi

"
" selection shortcuts
"
imap <s-left> <Esc>v
imap <s-right> <Esc>lv
imap <c-s-left> <Esc>vb
imap <c-s-right> <Esc>lve
imap <s-down> <Esc>v<down>
imap <s-up> <Esc>v<up>
imap <s-end> <Esc>v<end>
imap <s-home> <Esc>v<home>
map <s-left> v<left>
map <s-right> v<right>
map <c-s-left> vb
map <c-s-right> ve
map <s-down> v<down>
map <s-up> v<up>
map <s-end> v<end>
map <s-home> v<home>
vmap <s-left> <left>
vmap <s-right> <right>
vmap <c-s-left> b
vmap <c-s-right> e
vmap <s-down> <down>
vmap <s-up> <up>
vmap <s-end> <end>
vmap <s-home> <home>

"
" Python related
"
map <c-p> :set ft=python<CR>
map <c-e> <Plug>PimpEvalFile
imap <c-e> <Esc><Plug>PimpEvalFilea
vmap <c-e> <Plug>PimpEvalBlock

let &guifont="Monospace 10"

" stop cursor blinking
set gcr=a:blinkon0

" for the csapprox plugin
set t_Co=256

" turn on all filetype plugins
filetype plugin indent on

