set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set splitright
"set clipboard=unnamed
set hls
set ls
set encoding=UTF-8
set hidden
set belloff=all
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

let mapleader = "\<Space>"

let g:python3_host_prog = system('echo -n $(which python3)')

nnoremap <Leader>g :noh<CR>

" Split window
noremap ss :split<Return><C-w>w
noremap sv :vsplit<Return><C-w>w

" Move window
nnoremap sh <C-w>h
nnoremap sk <C-w>k
nnoremap sj <C-w>j
nnoremap sl <C-w>l
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sr <C-w>r
nnoremap sw <C-w>w

" Resize window
noremap <C-w><left> <C-w><
noremap <C-w><right> <C-w>>
noremap <C-w><up> <C-w>+
noremap <C-w><down> <C-w>-
nnoremap s= <C-w>=
noremap so <C-w>_<C-w>|

" Tab
nnoremap st :<C-u>tabnew<CR>
nnoremap sn gt
nnoremap sp gT

" emacs like keymaps for input mode
imap <C-p> <Up>
imap <C-n> <Down>
imap <C-b> <Left>
imap <C-f> <Right>
imap <C-a> <C-o>:call <SID>home()<CR>
imap <C-e> <End>
imap <C-d> <Del>
imap <C-h> <BS>
imap <C-k> <C-r>=<SID>kill()<CR>

" Lsp keymaps
nnoremap gd :<C-u>LspDefinition<CR>
nnoremap <C-]> :<C-u>LspDefinition<CR>
nnoremap K :<C-u>LspHover<CR>
nnoremap gD :<C-u>LspImplementation<CR>
nnoremap <c-k> :<C-u>LspSignatureHelp<CR>
nnoremap <LocalLeader>R :<C-u>LspRename<CR>
nnoremap <LocalLeader>n :<C-u>LspReferences<CR>

if !has('nvim')
    pythonx import neovim
endif"

if &compatible
    set nocompatible
endif

if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    call dein#load_toml('~/.vim/dein.toml', {'lazy': 0})
    call dein#load_toml('~/.vim/dein_lazy.toml', {'lazy': 1})

    if has('nvim')
        call dein#load_toml('~/.vim/nvim_dein.toml', {'lazy': 0})
    else
        call dein#add('roxma/nvim-yarp')
        call dein#add('roxma/vim-hug-neovim-rpc')
    endif
 
    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
    call dein#install()
endif

filetype plugin indent on
syntax enable

augroup FileTypeCustomize
    autocmd! FileTypeCustomize
    autocmd FileType * set formatoptions=""
    autocmd BufNewFile,BufRead *.kt set filetype=kotlin
    autocmd BufNewFile,BufRead *.swift set filetype=swift
    autocmd BufNewFile,BufRead *.rs set filetype=rust
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee
    autocmd BufNewFile,BufRead *.scala set filetype=scala
    autocmd BufNewFile,BufRead *.gradle set filetype=groovy
    autocmd BufNewFile,BufRead *.volt set filetype=volt
    autocmd BufNewFile,BufRead *.toml set filetype=toml
    autocmd BufNewFile,BufRead *.tf set filetype=terraform
    autocmd BufNewFile,BufRead *.tfstate set filetype=json
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    autocmd BufNewFile,BufRead Makefile set filetype=make
    autocmd FileType sql set sw=2 ts=2 et
    autocmd FileType xml,yaml,eruby,scss,ruby set sw=2 ts=2 et
    autocmd FileType rst set sw=3 ts=3 et
    autocmd FileType python,css,coffee,haskell,php,sh,html,terraform,javascript set sw=4 ts=4 et
    autocmd FileType make set softtabstop=0 noexpandtab
    autocmd FileType vim set foldmarker={{{,}}}
    autocmd FileType vim let g:vim_indent_cont = 0
    autocmd FileType python set nosi

    let g:java_highlight_all = 1
augroup END
