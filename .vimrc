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
"=====================================================


"===============タブやインデントに関する設定===============
"タブ入力を複数の空白文字に置き換える
set expandtab

"画面上でタブ文字が占める幅を規定
set tabstop=2

"連続した空白に対してtab_key やbackspace_keyでカーソルが動く幅を規定
set softtabstop=2

"改行時に前の行のインデントを継続させる
set autoindent

"改行時に前の行の構文をチェックし次の行のインデントを増減させる
set smartindent

"smartindentで増減する幅を規定
set shiftwidth=2

" インデントを設定
autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et
"============================================================


"==================== 検索系============================
"検索結果をハイライト
set hlsearch
"ESC二回押しでハイライトを消す
nnoremap <ESC><ESC> :nohlsearch<CR>

"検索結果に大文字小文字を区別しない
set ignorecase

"検索文字に大文字が含まれていたら、大文字小文字を区別する
set smartcase

"----------検索対象から除外するファイルを指定---------
let Grep_Skip_Dirs = '.svn .git'  "無視するディレクトリ
let Grep_Default_Options = '-I'   "バイナルファイルがgrepしない
let Grep_Skip_Files = '*.bak *~'  "バックアップファイルを無視する
"-----------------------------------------------------

":cn,:cpを、[q、]q にバインディング
nnoremap [q :cprevious<CR>   " 前へ
nnoremap ]q :cnext<CR>       " 次へ
nnoremap [Q :<C-u>cfirst<CR> " 最初へ
nnoremap ]Q :<C-u>clast<CR>  " 最後へ
"======================================================


"====================syntax系=========================
syntax enable
set background=dark
colorscheme desert

"シンタックスハイライト有効
syntax on
"=======================================================


"======================カーソル系========================
"カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set whichwrap=b,s,h,l,<,>,[,],~

"横線を入れる
set cursorline

"行番号を表示する
set number

"INSERTモードのときだけ横線解除
augroup set_cursorline
  autocmd!
  autocmd InsertEnter,InsertLeave * set cursorline!  "redraw!
augroup END

"全角スペースを視覚化
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile,BufRead * match ZenkakuSpace /　/

" タイトルをウインドウ枠に表示する
set title

"カーソルが何行目の何列目に置かれているかを表示する
set ruler

" backspace使用できるように
set backspace=indent,eol,start
"========================================================


"=======================コピー&ペースト系=================
" クリップボード for NeoVim
set clipboard+=unnamedplus

"----------コピーした際に自動インデントでズレない設定----
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
"--------------------------------------------------------

"==========================================================


"======================ファイル操作系=====================
"VimFilter起動時からファイル操作が出来る設定(切り替えはgs)
let g:vimfiler_as_default_explorer = 1
"=========================================================


"====================その他設定===========================
"自動でswpファイル作らない
set noswapfile

"自動補完(タブで移動)
set wildmenu

"保存するコマンド履歴の数を設定
set history=5000

" vimにcoffeeファイルタイプを認識させる
au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee

"Ctags
set tags=./.tags;
"==========================================================


"=================独自キーバインド=========================
"jjでインサートモードを抜ける
inoremap <silent> jj <ESC>

"qで終了
nmap q :q<CR>

"Shift + hで行の先頭
noremap <S-h>   ^

"Shift + lで行の末尾
noremap <S-l>   $

"上下移動を表示行ベースに
noremap j gj
noremap k gk
"==========================================================


"==================tab移動の設定===========================
"---t1,t2...でタブ移動,ttでタブ新規作成,tqでタブ閉じ-------
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
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]t :tablast <bar> tabnew<CR>
" tt 新しいタブを一番右に作る
map <silent> [Tag]q :tabclose<CR>
" tq タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
"==============================================================


"====================== dein ===========================
" deinで管理するディレクトリを指定
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin(expand('~/.vim/dein'))

" dein自体をdeinで管理
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})

"---------deinで管理するプラグイン達----------
"カラースキーム
call dein#add('tomasr/molokai')

"ディレクトリツリーの表示
call dein#add('scrooloose/nerdtree')

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

"rubocopの非同期実行
call dein#add('w0rp/ale')
let g:ale_sign_column_always = 1

"自動保存
call dein#add('vim-scripts/vim-auto-save')
let g:auto_save = 1
let g:auto_save_in_insert_mode = 0

"保存時に自動でctagsが実行される
call dein#add('soramugi/auto-ctags.vim')
let g:auto_ctags = 1
nnoremap <C-h> :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>

"tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>
"tagsジャンプで Ctrl+[ で新しいタブを開いてジャンプに
nnoremap <C-[> :<C-u>tab stj <C-R>=expand('<cword>')<CR><CR>

"taglist
call dein#add('vim-scripts/taglist.vim')
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Auto_Update = 1
let Tlist_File_Fold_Auto_Close = 1

"開いているファイルのコードを実行して結果を画面分割で出力できる
call dein#add('thinca/vim-quickrun')

"VimでGit操作
call dein#add('lambdalisue/gina.vim')
"brにGitHubの該当行を開くコマンドをキーマッピング
vnoremap br :Gina browse :<cr>

" ファイル検索(fzf)
set rtp+=/usr/local/opt/fzf
call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 })
call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

"変更行の左端に記号表示
call dein#add('airblade/vim-gitgutter')

"ファイル操作用
call dein#add('Shougo/vimfiler')

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

"endを自動で入力してくれる
call dein#add('tpope/vim-endwise')

"カッコを七色にする
call dein#add('luochen1990/rainbow')
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" v連打で選択範囲を変える[1文字→単語→段落](<C-v>で元に戻す)
call dein#add('terryma/vim-expand-region')
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Vueファイルのシンタックスハイライト
call dein#add('posva/vim-vue')

" jsxのシンタックスハイライト
call dein#add('maxmellon/vim-jsx-pretty')
call dein#add('pangloss/vim-javascript')
call dein#add('maxmellon/vim-jsx-pretty')

" :GitMessenger でコミットを見れる
call dein#add('rhysd/git-messenger.vim')

" TypeScriptのシンタックスハイライト
call dein#add('leafgarland/typescript-vim')

" EditorConfigの設定
call dein#add('editorconfig/editorconfig-vim')
"--------------------------------------------------

"--------------EasyMotionの設定-------------------
map <Leader> <Plug>(easymotion-prefix)
let g:EasyMotion_do_mapping = 0 " Disable default mappings

"sを押したら2文字サーチに入るよう設定
nmap s <Plug>(easymotion-overwin-f2)

"SmartCaseで検索する
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
"-------------------------------------------------

"---------------NERDTreeの設定---------------------
" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

" デフォルトでツリーを表示させる
let g:nerdtree_tabs_open_on_console_startup=1

"<C-e>でNERDTreeを起動する設定
nnoremap <silent><C-e> :NERDTreeToggle<CR>
"-------------------------------------------------

"--------------indent guideの設定-----------------
set list listchars=tab:\¦\
let g:indentLine_color_term = 111
let g:indentLine_color_gui = '#708090'
"-------------------------------------------------

"-----------------補完の設定--------------------
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 0
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#enable_camel_case = 0
let g:deoplete#enable_ignore_case = 0
let g:deoplete#enable_refresh_always = 0
let g:deoplete#enable_smart_case = 1
let g:deoplete#file#enable_buffer_path = 1
let g:deoplete#max_list = 10000
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
"vim-lspを入れたら動作がかなり遅くなってしまったので一旦コメントアウト
" call dein#add('autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ })
" let g:LanguageClient_serverCommands = {
"       \ 'ruby': ['solargraph', 'stdio'],
"       \}
" call deoplete#custom#var('omni', 'input_patterns', {
"       \ 'ruby': ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::'],
"       \})

if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
"------------------------------------------------------

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
"------------------------------------------------------

"--------------- ステータスラインの設定-------------------
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
"---------------------------------------------------------
"
"--------------- ファイル検索(fzf)の設定-------------------
nnoremap <C-p> :FZFFileList<CR>
"ノーマルモードでfを押すとfzfが起動するキーマップ
nmap f :FZFFileList<CR>
command! FZFFileList call fzf#run({
            \ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
            \ 'sink': 'e'})
" fzfからファイルにジャンプできるようにする
let g:fzf_buffers_jump = 1

" ファイル検索にripgrepを利用(?でプレビュー表示)
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\ 'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
\ <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
\ : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
\ <bang>0)
" Ctrl + gで文字列検索起動
nnoremap <C-g> :Rg<CR>
" Ctrl + oで新しいタブで開く
let g:fzf_action = {
\ 'ctrl-o': 'tab split'
\ }
"---------------------------------------------------------

call dein#end()

" Required:
filetype plugin indent on

" もし、未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif
"===========================================================
