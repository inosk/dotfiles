" vim: foldmethod=marker
" vim: foldcolumn=3
" vim: foldlevel=0

" macではshared/.vimrcでdefault offになっているので修正
set modelines=1

if &compatible
  set nocompatible
endif

" vimの起動が遅くなる問題
let g:ruby_path = ""

" settings for dein {{{
if has("nvim")
  let g:python_host_prog = expand("~/.anyenv/envs/pyenv/versions/2.7.12/bin/python")
  let g:python3_host_prog = expand("~/.anyenv/envs/pyenv/versions/3.5.0/bin/python")
  let s:config_root = expand("~/.config/nvim/")
else
  let s:config_root = expand("~/.vim/")
endif

let s:dein_runtimepath = s:config_root . "dein/repos/github.com/Shougo/dein.vim"
execute 'set runtimepath^=' . fnamemodify(s:dein_runtimepath, ':p')

call dein#begin(s:config_root . "dein")

" Add or remove your plugins here:
call dein#load_toml(s:config_root . "dein.toml",      {"lazy": 0})
call dein#load_toml(s:config_root . "dein_lazy.toml", {"lazy": 1})

" You can specify revision/branch/tag.
call dein#add('Shougo/vimshell', { 'rev': '3787e5' })
call dein#end()

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
" }}}
" settings for base {{{
" ----------------------------------------------
"  基本設定
" ----------------------------------------------
set t_Co=256
set autoread                    " 他で変更があったら自動で読み込み
set ai                          " auto indent
set shiftwidth=2                " インデント幅は2
set tabstop=2                   " tabの幅は2
set expandtab                   " tabをホワイトスペースにする
set number                      " 行数を表示
set backspace=indent,eol,start  " バックスペースですべて消せるようにする
set formatoptions=lmoq          " テキスト整形オプション，マルチバイト系を追加
set vb t_vb=                    " ビープを鳴らさない
set nobackup                    " バックアップファイルを作らない
set incsearch                   " インクリメント検索
set clipboard+=unnamed          " OSのクリップボードを使用する
set pastetoggle=<F10>           " pastemodeのtoggleをF10にわりあて
set wildmenu wildmode=list:full " vimからファイルを開く時にリスト表示
set colorcolumn=120
syntax on                       " syntax ハイライトをon

" indent
filetype plugin indent on
augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.java,*.gradle,*.groovy setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

" 分割時は右か下に出す．
set splitright
set splitbelow

" 不可視文字の可視化
set lcs=tab:>-,trail:_,extends:\
set list
highlight SpecialKey cterm=NONE ctermfg=235 ctermbg=0
highlight JpSpace cterm=underline ctermfg=1 ctermbg=0
au BufRead,BufNew * match JpSpace /　/

" vim7.4のsegv対策
if v:version >= 704
  set regexpengine=1
endif

"" カーソルの変更
"if $TERMCAP =~ "screen"
"  let &t_SI .= "\eP\e]50;CursorShape=1\x7\e\\"
"  let &t_EI .= "\eP\e]50;CursorShape=0\x7\e\\"
"elseif &term =~ "xterm"
"  let &t_SI .= "\e]50;CursorShape=1\x7"
"  let &t_EI .= "\e]50;CursorShape=0\x7"
"endif

" 通常モードに戻った時にすぐにカーソルが戻るように
set timeout
set timeoutlen=1000
set ttimeoutlen=0

" C-fでスクロールしきったときに一行になる挙動を修正
" refs: http://itchyny.hatenablog.com/entry/2016/02/02/210000
noremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')

if has("nvim")
  set mouse="a"
endif
" }}}
" settings for folding {{{
set foldenable
autocmd FileType ruby :set foldmethod=indent
autocmd FileType ruby :set foldlevel=1
autocmd FileType ruby :set foldnestmax=2

autocmd InsertEnter * if !exists("w:last_fdm")
       \| let w:last_fdm=&foldmethod
       \| setlocal foldmethod=manual
       \| endif

autocmd InsertLeave,WinLeave * if exists("w:last_fdm")
       \| let &l:foldmethod=w:last_fdm
       \| unlet w:last_fdm
       \| endif

autocmd FileType ruby normal zR
" }}}
" settings for status line {{{
set laststatus=2
"set statusline=%f%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ENC=%{&fileencoding}]\ [POS=%l,%v][LEN=%L]\ [%p%%]
let &statusline = ''
let &statusline .= '%f%m%r%h%w'
let &statusline .= ' [FORMAT=%{&ff}][TYPE=%Y][ENC=%{&fileencoding}]'
let &statusline .= '%{&bomb ? "[BOM]" : ""}'
let &statusline .= ' [POS=%l,%v][LEN=%L][%p%%]'

hi StatusLine term=NONE cterm=NONE ctermfg=white ctermbg=blue
" }}}
" settings for mac os x {{{
" iTerm2でモードによってカーソルを変更
if has("mac")
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  set ambiwidth=double
endif
" }}}
" settings for keymap {{{
" 挿入モードでCtrl+kでクリップボードの内容を貼り付けられるように
imap <C-K> <ESC>"*pa

nnoremap j gj
nnoremap k gk

nnoremap <Space><Space> :<C-u>set nohlsearch<Return>
nnoremap / :<C-u>set hlsearch<Return>/
nnoremap ? :<C-u>set hlsearch<Return>?
nnoremap * :<C-u>set hlsearch<Return>*
nnoremap # :<C-u>set hlsearch<Return>#

nnoremap <C-l> <C-W>>
nnoremap <C-h> <C-W><

" window移動のショートカット
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sw <C-w>w

inoremap <C-a> <Esc>^i
inoremap <C-e> <Esc>$a

" leader(\)をスペースに変換しておく
let mapleader = " "
let g:mapleader = " "
" }}}
" settings for colorscheme {{{
colorscheme hybrid
highlight Normal ctermbg=none
highlight Pmenu ctermbg=4
highlight PmenuSel ctermbg=1
highlight PMenuSbar ctermbg=4
highlight Visual ctermbg=240
highlight Search ctermbg=100
" }}}
" settings for surround.vim {{{
" let g:surround_37 = "<% \r %>"  " %で<% %>くくり
" let g:surround_61 = "<%= \r %>" " =で<%= %>くくり
let g:surround_{char2nr("%")} = "<% \r %>"
let g:surround_{char2nr("=")} = "<%= \r %>"
let g:surround_{char2nr("!")} = "<!-- \r -->"
" }}}
" settings for binary (vim -b) {{{
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END
" }}}
" settings for auto-ctags {{{
set tags+=$HOME/.tags
set tags+=.git/tags
set tags+=.svn/tags
let g:auto_ctags = 0
let g:auto_ctags_directory_list = ['.git', '.svn']
let g:auto_ctags_tags_name = 'tags'
let g:auto_ctags_tags_args = '--exclude=.git --exclude=log/*'
" }}}
" settings for lightline {{{
let g:lightline = {
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'ale' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'MyModified',
        \   'readonly': 'MyReadonly',
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode',
        \ },
        \ 'component_type': {
        \   'ale': 'error',
        \ },
        \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

augroup LightLineonALE
  autocmd!
  autocmd User ALELint call lightline#update()
augroup END
" }}}
" settings for lightline-ale {{{
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \  'linter_checking': 'left',
      \  'linter_warnings': 'warning',
      \  'linter_errors': 'error',
      \  'linter_ok': 'left',
      \ }
" }}}
" settings for switch.vim {{{
let g:switch_custom_definitions =
\ [
\   ['if', 'unless'],
\   ['while', 'until'],
\   ['.blank?', '.present?'],
\   ['include', 'extend'],
\   ['class', 'module'],
\   ['.inject', '.delete_if'],
\   ['.map', '.map!'],
\   ['attr_accessor', 'attr_reader', 'attr_writer'],
\   ['=', '<', '<=', '>', '>=', '~>'],
\   ['yes?', 'no?'],
\   [100, ':continue', ':information'],
\   [101, ':switching_protocols'],
\   [102, ':processing'],
\   [200, ':ok', ':success'],
\   [201, ':created'],
\   [202, ':accepted'],
\   [203, ':non_authoritative_information'],
\   [204, ':no_content'],
\   [205, ':reset_content'],
\   [206, ':partial_content'],
\   [207, ':multi_status'],
\   [208, ':already_reported'],
\   [226, ':im_used'],
\   [300, ':multiple_choices'],
\   [301, ':moved_permanently'],
\   [302, ':found'],
\   [303, ':see_other'],
\   [304, ':not_modified'],
\   [305, ':use_proxy'],
\   [306, ':reserved'],
\   [307, ':temporary_redirect'],
\   [308, ':permanent_redirect'],
\   [400, ':bad_request'],
\   [401, ':unauthorized'],
\   [402, ':payment_required'],
\   [403, ':forbidden'],
\   [404, ':not_found'],
\   [405, ':method_not_allowed'],
\   [406, ':not_acceptable'],
\   [407, ':proxy_authentication_required'],
\   [408, ':request_timeout'],
\   [409, ':conflict'],
\   [410, ':gone'],
\   [411, ':length_required'],
\   [412, ':precondition_failed'],
\   [413, ':request_entity_too_large'],
\   [414, ':request_uri_too_long'],
\   [415, ':unsupported_media_type'],
\   [416, ':requested_range_not_satisfiable'],
\   [417, ':expectation_failed'],
\   [422, ':unprocessable_entity'],
\   [423, ':precondition_required'],
\   [424, ':too_many_requests'],
\   [426, ':request_header_fields_too_large'],
\   [500, ':internal_server_error'],
\   [501, ':not_implemented'],
\   [502, ':bad_gateway'],
\   [503, ':service_unavailable'],
\   [504, ':gateway_timeout'],
\   [505, ':http_version_not_supported'],
\   [506, ':variant_also_negotiates'],
\   [507, ':insufficient_storage'],
\   [508, ':loop_detected'],
\   [510, ':not_extended'],
\   [511, ':network_authentication_required'],
\   ['describe', 'context', 'specific', 'example'],
\   ['before', 'after'],
\   ['be_true', 'be_false'],
\   ['get', 'post', 'put', 'delete'],
\   ['==', 'eql', 'equal'],
\   ['\.to_not', '\.to'],
\   { '\([^. ]\+\)\.should\(_not\|\)': 'expect(\1)\.to\2' },
\   { 'expect(\([^. ]\+\))\.to\(_not\|\)': '\1.should\2' }
\ ]
" }}}
" settings for vim-indent-guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=234
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
" }}}
" settings for vim-markdown {{{
let g:vim_markdown_folding_disabled=1
" }}}
" settings for cursorline {{{
augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END
" }}}
" settings for auto-pairs {{{
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '|':'|'}
" }}}
" settings for rustfmt {{{
let g:rustfmt_autosave = 1
let g:rustfmt_command = '$HOME/.cargo/bin/rustfmt'
" }}}
" settings for racer {{{
let g:racer_cmd = '$HOME/.cargo/bin/racer'
let $RUST_SRC_PATH = '$HOME/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src'
" }}}
" settings for unite.vim {{{
" unite.vim
"let g:unite_enable_split_vertically=1
"noremap <C-u> :Unite -buffer-name=files file buffer file_mru<CR>

" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" unite-outline.vim
noremap <C-u><C-o> :Unite -vertical outline<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q
" }}}
" {{{ settings for ALE
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_statusline_format = ['E %d', 'W %d', 'ok']
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_column_always = 1
" }}}
" settings for neosnippet {{{
imap <C-k> <Plug>(neosnippet_expand_or_jump)>
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" }}}
if has('nvim')
" settings for neoterm {{{
let g:neoterm_position = 'horizontal'

" ren set test lib
nnoremap <silent> ,rn :call neoterm#test#run('all')<cr>
nnoremap <silent> ,rn :call neoterm#test#run('file')<cr>
nnoremap <silent> ,rn :call neoterm#test#run('current')<cr>
nnoremap <silent> ,rr :call neoterm#test#rerun()<cr>

" Useful maps
" open terminal
nnoremap <silent> ,tt :call neoterm#open()<cr>
" hide/close terminal
nnoremap <silent> ,th :call neoterm#close()<cr>
" clear terminal
nnoremap <silent> ,tl :call neoterm#clear()<cr>
" kills the current job (send a <c-c>)
nnoremap <silent> ,tc :call neoterm#kill()<cr>
" }}}
" settings for deoplete{{{
" Use deoplete.
let g:deoplete#enable_at_startup = 1
" Use smartcase.
let g:deoplete#enable_smart_case = 1

let g:deoplete#disable_auto_complete = 1

" Tabで保管
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#mappings#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}

let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.ruby = ['[^. *\t]\.\w*', '\h\w*::']

let deoplete#tag#cache_limit_size = 5000000

" }}}
endif
if !has('nvim')
" settings for supertab {{{
let g:SuperTabDefaultCompletionType = "<c-n>"
" }}}
" {{{ settings for neocomplete
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
  \ 'default' : '',
  \ 'vimshell' : $HOME.'/.vimshell_hist',
  \ 'scheme' : $HOME.'/.gosh_completions'
\ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" }}}
endif
" settings for macros {{{
source $VIMRUNTIME/macros/matchit.vim
" }}}
" settings for vim-rspec {{{
let g:rspec_command = "Dispatch bundle exec rspec {spec}"
nmap <silent>,rc :call RunCurrentSpecFile()<CR>
nmap <silent>,rn :call RunNearestSpec()<CR>
"nmap <leader>l :call RunLastSpec()<CR>
"nmap <leader>a :call RunAllSpecs()<CR>
" }}}
