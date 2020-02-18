" setting
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" クリップボード共有
set clipboard+=unnamed
" ファイル作成時にテンプレートを貼り付ける
autocmd BufNewFile *.cpp 0r ~/.vim/TemplatesForCP/template.cpp
" バックスペース有効化
set backspace=indent,eol,start

" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
" set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
set t_Co=256
nnoremap j gj
nnoremap k gk


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
" inoremap " ""<Left><CR><ESC><S-o>
" inoremap ' ''<Left><CR><ESC><S-o>
inoremap <C-@> <ESC>

"dein Scripts-----------------------------
if &compatible
    set nocompatible               " Be iMproved
endif

let s:dein_path = expand('~/.cache/dein')
let s:dein_repo_path = s:dein_path . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_path)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_path, ':p')
endif

if dein#load_state(s:dein_path)
  call dein#begin(s:dein_path)

  let g:config_dir  = expand('~/.cache/userconfig')
  let s:toml        = g:config_dir . '/plugin.toml'
  let s:lazy_toml   = g:config_dir . '/plugin_lazy.toml'

  " TOML 読み込み
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable
" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------

" Note: Skip initialization for vim-tiny or vim-small.
 if 0 | endif

 if &compatible
   set nocompatible               " Be iMproved
 endif

 " Required:
 set runtimepath+=~/.vim/bundle/neobundle.vim/

 " Required:
 call neobundle#begin(expand('~/.vim/bundle/'))

 " Let NeoBundle manage NeoBundle
 " Required:
 NeoBundleFetch 'Shougo/neobundle.vim'
 NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }

if has('lua') " lua機能が有効になっている場合・・・・・・①
    " コードの自動補完
    NeoBundle 'Shougo/neocomplete.vim'
    " スニペットの補完機能
    NeoBundle "Shougo/neosnippet"
    " スニペット集
    NeoBundle 'Shougo/neosnippet-snippets'
endif

" settings for neocomplete, neosnippet
if neobundle#is_installed('neocomplete.vim')
    " Vim起動時にneocompleteを有効にする
    let g:neocomplete#enable_at_startup = 1
    " smartcase有効化. 大文字が入力されるまで大文字小文字の区別を無視する
    let g:neocomplete#enable_smart_case = 1
    " 3文字以上の単語に対して補完を有効にする
    let g:neocomplete#min_keyword_length = 3
    " 区切り文字まで補完する
    let g:neocomplete#enable_auto_delimiter = 1
    " 1文字目の入力から補完のポップアップを表示
    let g:neocomplete#auto_completion_start_length = 1
    " バックスペースで補完のポップアップを閉じる
    inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

    imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
    imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
endif
 " Plugins ---------------------------------
 " Refer to |:NeoBundle-examples|.
 " Note: You don't set neobundle setting in .gvimrc!

" ファイルをtree表示してくれる
NeoBundle 'scrooloose/nerdtree'
" Ctrl+eで開く
 nnoremap <silent><C-e> :NERDTreeToggle<CR>
 " color scheme
NeoBundle 'tomasr/molokai'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'morhetz/gruvbox'
NeoBundle 'sickill/vim-monokai'
NeoBundle 'Vimjas/vim-python-pep8-indent'
NeoBundle 'hashivim/vim-terraform'
NeoBundle 'fatih/vim-go'
NeoBundle 'prabirshrestha/async.vim'
NeoBundle 'prabirshrestha/asyncomplete.vim'
NeoBundle 'prabirshrestha/asyncomplete-lsp.vim'
NeoBundle 'prabirshrestha/vim-lsp'
NeoBundleLazy 'junegunn/vim-easy-align', {
  \ 'autoload': {
  \   'commands' : ['EasyAlign'],
  \   'mappings' : ['<Plug>(EasyAlign)'],
  \ }}

" C++ Syntax checking
if has('job') && has('channel') && has('timers')
  NeoBundle 'w0rp/ale'
else
  NeoBundle 'vim-syntastic/syntastic'
endif

" ALE for C++
let g:ale_completion_enabled = 1
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" let g:ale_c_clang_options = "-std=c++14 -I/usr/local/include"
let g:ale_cpp_clang_options = "-std=c++14 -I/usr/local/include"
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_linters = {
    \   'c' : ['clangd'],
    \   'cpp' : ['clangd']
\}

" using language-server
let g:lsp_diagnostics_enabled = 0
let g:lsp_log_verbose = 1       " debug
let g:lsp_log_file = expand('~/.vim/vim-lsp.log')
" let g:asyncomplete_log_file = expand('~/asyncomplete.log')

if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
endif

" vim-easy-align {{{
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)
" }}}

" syntasticを入れると、cppのシンタックスチェックがめちゃくちゃになるゾ☆
" NeoBundle 'scrooloose/syntastic'
" let g:syntastic_python_checkers = ['pyflakes', 'pep8']

" lightline.vim 設定
NeoBundle 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'wombat'
      \ }

" terraform vim
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" vim-go setting
let g:go_template_autocreate = 0
let g:go_null_module_warning = 0
let g:go_fmt_command = "goimports"
let g:go_metalinter_autosave = 1
" ------------------------------------
" colorscheme
" ------------------------------------
syntax enable
colorscheme gruvbox
set background=dark
set t_Co=256 " gruvboxをカラースキーマにするときに必要！
" iTerm2で半透明にしているが、vimのcolorschemeを設定すると背景も変更されるため
highlight Normal ctermbg=none

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
