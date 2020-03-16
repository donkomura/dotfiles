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
" cpp
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
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
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

" for <Leader> replacement
let mapleader = ","

" 変数定義
let $LIBRARY = expand("~/Documents/kyopuro/Library")

" ============================================================
call plug#begin()
" ファイルのツリーを表示
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" gruvboxカラースキーム
Plug 'morhetz/gruvbox'
" terraform用プラグイン
Plug 'hashivim/vim-terraform'
" コードの自動補完用プラグイン
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
" Go: import支援
Plug 'mattn/vim-goimports'
" 整形
Plug 'junegunn/vim-easy-align', { 'on': 'EasyAlign' }
" 範囲指定 + Enterで整形
vmap <Enter> <Plug>(EasyAlign)
" C++ Syntax checking
if has('job') && has('channel') && has('timers')
  Plug 'w0rp/ale'
else
  Plug 'vim-syntastic/syntastic'
endif
" ステータスライン
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" settings for plugins ======================================
" vim-lsp
nmap <silent> gd :LspDefinition<CR>
nmap <silent> <f2> :LspRename<CR>
nmap <silent> <Leader>d :LspTypeDefinition<CR>
nmap <silent> <Leader>r :LspReferences<CR>
nmap <silent> <Leader>i :LspImplementation<CR>
" when using ale, turn off
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_virtual_text_enabled = 0
let g:lsp_signs_enabled = 1
let g:lsp_signs_error = {'text': '✘'}
let g:lsp_signs_warning = {'text': '!!'}
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/.vim/vim-lsp.log')

" オムニ補完
autocmd FileType typescript setlocal omnifunc=lsp#complete

if executable('clangd')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'clangd',
      \ 'cmd': {server_info->['clangd', '--compile-commands-dir', expand('~/.vim/TemplatesForCP')]},
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif

" asyncomplete.vim
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" ale
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_linters = {
    \   'c' : ['clangd'],
    \   'cpp' : ['clangd']
\}
augroup compileflag-text
    autocmd!
    autocmd BufNewFile,BufReadPost * call s:compileflag_text(expand('~/.vim/TemplatesForCP/'))
augroup END

function! s:compileflag_text(loc)
    let files = findfile('compile_flags.txt', escape(a:loc, ' ') . ';', -1)
    for i in reverse(filter(files, 'filereadable(v:val)'))
        let g:ale_cpp_clang_options = system("cat " . i . "| tr '\\n' ' '")
        let g:ale_cpp_gcc_options = system("cat " . i . "| tr '\\n' ' '")
    endfor
endfunction

" terraform vim
let g:terraform_align=1
let g:terraform_fmt_on_save=1

" Powerline系フォントを利用する
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline_theme = 'wombat'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" ------------------------------------
" colorscheme
" ------------------------------------
syntax enable
colorscheme gruvbox
set background=dark
set t_Co=256 " gruvboxをカラースキーマにするときに必要！
" iTerm2で半透明にしているが、vimのcolorschemeを設定すると背景も変更されるため
highlight Normal ctermbg=none

filetype plugin indent on
