
"===============文字コードに関する設定================
"ファイル読み込み時の文字コードの設定
set encoding=utf-8

"Vim script内でマルチバイト文字を使う際の設定
scriptencoding uft-8

" 保存時の文字コード
set fileencoding=utf-8

" 読み込み時の文字コードの自動判別. 左側が優先される
set fileencodings=ucs-boms,utf-8,euc-jp,cp932

" 改行コードの自動判別. 左側が優先される
set fileformats=unix,dos,mac

" □や○文字が崩れる問題を解決
set ambiwidth=double

"===============タブやインデントに関する設定===============
"タブ入力を複数の空白文字に置き換える
set expandtab

"画面上でタブ文字が占める幅を規定
set tabstop=2

"連続した空白に対してtab_key やbackspace_keyでカーソルが動く幅を規定
set softtabstop=2

"改行時に前の行のインデントを継続させる
set autoindent

"smartindentで増減する幅を規定
set shiftwidth=2

" インデントを設定
autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et

"==================== 検索系============================
"検索結果をハイライト
set hlsearch

"検索結果に大文字小文字を区別しない
set ignorecase

"検索文字に大文字が含まれていたら、大文字小文字を区別する
set smartcase

"====================syntax系=========================
syntax enable
set background=dark
colorscheme desert

"シンタックスハイライト有効
syntax on

"======================カーソル系========================
"カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set whichwrap=b,s,h,l,<,>,[,],~

"横線を入れる
set cursorline

"行番号を表示する
set number

"全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/

" タイトルをウインドウ枠に表示する
set title

"カーソルが何行目の何列目に置かれているかを表示する
set ruler

" backspace使用できるように
set backspace=indent,eol,start

"=======================コピー&ペースト系=================
" クリップボード for NeoVim
set clipboard+=unnamedplus

"コピーした際に自動インデントでズレない設定
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" ペーストモードを自動で抜ける設定
autocmd InsertLeave * set nopaste

"======================ファイル操作系=====================
"VimFilter起動時からファイル操作が出来る設定(切り替えはgs)
let g:vimfiler_as_default_explorer = 1

"自動でswpファイル作らない
set noswapfile

"自動補完(タブで移動)
set wildmenu

"保存するコマンド履歴の数を設定
set history=5000

" vimにcoffeeファイルタイプを認識させる
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee

"==================マークダウンの設定===========================
" [markdown] configure formatprg
autocmd FileType markdown set formatprg=prettier\ --parser\ markdown

" [markdown] format on save
autocmd! BufWritePre *.md call s:mdfmt()
function s:mdfmt()
    let l:curw = winsaveview()
    silent! exe "normal! a \<bs>\<esc>" | undojoin |
        \ exe "normal gggqG"
    call winrestview(l:curw)
  endfunction

"==================tab移動の設定===========================
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears

    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]

map <silent> [Tag]t :tablast <bar> tabnew<CR>
" tt 新しいタブを一番右に作る
map <silent> [Tag]q :tabclose<CR>
" tq タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

"==================永続Undo===========================
set undofile
if !isdirectory(expand("$HOME/.vim/undodir"))
  call mkdir(expand("$HOME/.vim/ undodir"), "p")
endif
set undodir=$HOME/.vim/undodir

"====================== dein ===========================
" deinで管理するディレクトリを指定
" https://dezanari.com/deinvim-install/
" set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim


" Required:
call dein#begin(expand('~/.vim/dein'))
call dein#add('vim/killersheep')

" dein自体をdeinで管理
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})

"deinで管理するプラグイン達
"カラースキーム
call dein#add('tomasr/molokai')

"coffeescriptを認識させる
call dein#add('kchmck/vim-coffee-script')

" ステータスラインの表示内容強化
call dein#add('itchyny/lightline.vim')

" 末尾の全角と半角の空白文字を赤くハイライト
call dein#add('bronson/vim-trailing-whitespace')

"インデントを可視化
call dein#add('Yggdroot/indentLine')

"カーソル移動を楽に
call dein#add('easymotion/vim-easymotion')

"括弧移動を拡張
call dein#add('tmhedberg/matchit')

"helpの日本語化
call dein#add('vim-jp/vimdoc-ja')

"コメントアウト gccでカレント行 gcで選択行
call dein#add('tomtom/tcomment_vim')

"指定範囲を楽に囲む 選択範囲を、S＋囲むもの
call dein#add('tpope/vim-surround')

"ディレクトリツリーの表示
call dein#add('scrooloose/nerdtree')

" rubocopの非同期実行
" 各言語について色々入ってる
call dein#add('w0rp/ale')
let g:ale_sign_column_always = 1

"自動保存
call dein#add('vim-scripts/vim-auto-save')
let g:auto_save = 1
let g:auto_save_in_insert_mode = 0

"開いているファイルのコードを実行して結果を画面分割で出力できる
call dein#add('thinca/vim-quickrun')

"VimでGit操作
call dein#add('lambdalisue/gina.vim')
"brにGitHubの該当行を開くコマンドをキーマッピング
vnoremap br :Gina browse :<cr>

"変更行の左端に記号表示
call dein#add('airblade/vim-gitgutter')

"ファイル操作用
call dein#add('Shougo/vimfiler')

" TypeScriptのシンタックスハイライト
call dein#add('leafgarland/typescript-vim')

"補完
call dein#add('Shougo/deoplete.nvim')
if !has('nvim')
  call dein#add('roxma/nvim-yarp')
  call dein#add('roxma/vim-hug-neovim-rpc')
endif

"検索で何件目か分かる
call dein#add('osyo-manga/vim-anzu')
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)

" ファイル検索
call dein#add('ctrlpvim/ctrlp.vim')

" Vueファイルのシンタックスハイライト
call dein#add('posva/vim-vue')

" jsxのシンタックスハイライト
call dein#add('maxmellon/vim-jsx-pretty')
call dein#add('pangloss/vim-javascript')

" EditorConfigの設定
call dein#add('editorconfig/editorconfig-vim')

" deniteのインストール
call dein#add('Shougo/denite.nvim')

" file_mruで使うために入れてる
call dein#add('Shougo/neomru.vim')

autocmd FileType denite call s:denite_settings()

"---------------NERDTreeの設定---------------------
" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

" デフォルトでツリーを表示させる
let g:nerdtree_tabs_open_on_console_startup=1

"<C-e>でNERDTreeを起動する設定
nnoremap <silent><C-e> :NERDTreeToggle<CR>
map z :NERDTreeFind

"--------------Deniteの設定-------------------
nnoremap [denite] <Nop>
nmap <C-m> [denite]

" -buffer-name=
nnoremap <silent> [denite]g  :<C-u>Denite grep -buffer-name=search-buffer-denite<CR>

" Denite grep検索結果を再表示する
nnoremap <silent> [denite]r :<C-u>Denite -resume -buffer-name=search-buffer-denite<CR>
" resumeした検索結果の次の行の結果へ飛ぶ
nnoremap <silent> [denite]n :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=+1 -immediately<CR>
" resumeした検索結果の前の行の結果へ飛ぶ
nnoremap <silent> [denite]p :<C-u>Denite -resume -buffer-name=search-buffer-denite -select=-1 -immediately<CR>
"最近使用したファイル一覧
nnoremap <silent> [denite]m :<C-u>Denite -direction=topleft file_mru<CR>

"--------------EasyMotionの設定-------------------
map <Leader> <Plug>(easymotion-prefix)
let g:EasyMotion_do_mapping = 0 " Disable default mappings

"SmartCaseで検索する
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

"--------------indent guideの設定-----------------
set list listchars=tab:\¦\
let g:indentLine_color_term = 111
let g:indentLine_color_gui = '#708090'

"-----------------補完の設定--------------------
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#auto_complete_delay = 0
" let g:deoplete#auto_complete_start_length = 1
" let g:deoplete#enable_camel_case = 0
" let g:deoplete#enable_ignore_case = 0
" let g:deoplete#enable_refresh_always = 0
" let g:deoplete#enable_smart_case = 1
" let g:deoplete#enable_buffer_path = 1
" let g:deoplete#max_list = 10000
" 補完の操作
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
" ハイライトの色設定
highlight Pmenu ctermbg=6
highlight PmenuSel ctermbg=3
highlight PMenuSbar ctermbg=0

if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

"----lightline(ステータスの表示の設定/色の変更とVimFiler時にパスが出るようにしてる)----
let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'LightlineModified',
        \   'readonly': 'LightlineReadonly',
        \   'fugitive': 'LightlineFugitive',
        \   'filename': 'LightlineFilename',
        \   'fileformat': 'LightlineFileformat',
        \   'filetype': 'LightlineFiletype',
        \   'fileencoding': 'LightlineFileencoding',
        \   'mode': 'LightlineMode'
        \ }
        \ }

function! LightlineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
    return fugitive#head()
  else
    return ''
  endif
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

"--------------- ステータスラインの設定-------------------
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
"---------------------------------------------------------

call dein#end()

" Required:
filetype plugin indent on

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

if executable('rg')
  " For ripgrep.
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--color', 'never'])
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

function! s:denite_settings() abort
  nnoremap <silent><buffer><expr><nowait> <CR> denite#do_map('do_action')
  nnoremap <silent><buffer><expr><nowait> <TAB> denite#do_map('choose_action')
  nnoremap <silent><buffer><expr><nowait> <ESC> denite#do_map('quit')
  nnoremap <silent><buffer><expr><nowait> q denite#do_map('quit')
  nnoremap <silent><buffer><expr><nowait> <Space> denite#do_map('toggle_select').'j'
  nnoremap <silent><buffer><expr><nowait> n denite#do_map('quick_move')
  nnoremap <silent><buffer><expr><nowait> i denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr><nowait> p denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr><nowait> t denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr><nowait> v denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr><nowait> s denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr><nowait> <C-h> denite#do_map('restore_sources')
endfunction
