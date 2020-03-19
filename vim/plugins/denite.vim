nnoremap [denite] <Nop>
nmap <C-d> [denite]
nnoremap <silent> [denite]g :<C-u>DeniteCursorWord grep -buffer-name=search-buffer-denite<CR>
nnoremap <silent> [denite]G :<C-u>Denite grep -buffer-name=search-buffer-denite<CR>
nnoremap <silent> [denite]r :<C-u>Denite -resume -buffer-name=search-buffer-denite<CR>
nnoremap <silent> [denite]p :<C-u>Denite file_rec<CR>

"call denite#custom#option('default', 'prompt', '>')
"call denite#custom#option('_', 'highlight_matched_range', 'None')
"call denite#custom#option('_', 'highlight_matched_char', 'None')

"call denite#custom#map('insert', "<Tab>", '<denite:move_to_next_line>')
"call denite#custom#map('insert', "<S-Tab>", '<denite:move_to_previous_line>')

"call denite#custom#map('insert', "<C-t>", '<denite:do_action:tabopen>')
"call denite#custom#map('insert', "<C-s>", '<denite:do_action:vsplit>')
"call denite#custom#map('normal', "s", '<denite:do_action:vsplit>')

" Use pt for grep
call denite#custom#var('grep', 'command', ['pt', '--follow', '--nogroup', '--nocolor', '--hidden'])
call denite#custom#var('grep', 'default_opts', [])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('file_rec', 'command', ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])

" Show directory and buffers
nnoremap <silent><C-d>a :<C-u>Denite file buffer -split=floating file:new<CR>
nnoremap <silent><C-d>b :<C-u>Denite buffer -split=floating file:new<CR>
nnoremap <silent><C-d>f :<C-u>Denite file -split=floating file:new<CR>
nnoremap <silent><C-d>r :<C-u>Denite file/rec -split=floating file:new<CR>
" Grep recursively from current directory
nnoremap <silent><C-d>gr :<C-u>Denite grep -buffer-name=search<CR>
" Grep cursor text from current directory
nnoremap <silent><C-d>, :<C-u>DeniteCursorWord grep -buffer-name=search line<CR>
" Re-display grep results
nnoremap <silent><C-d>gs :<C-u>Denite -resume -buffer-name=search<CR>
" Show comand denite command history
nnoremap <silent><C-d>c :<C-u>Denite command_history -split=floating<CR>

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> o
    \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> s
    \ denite#do_map('do_action', 'split')
    nnoremap <silent><buffer><expr> v
    \ denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> d
    \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
    \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> <Esc>
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> q
    \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
    \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
    \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

