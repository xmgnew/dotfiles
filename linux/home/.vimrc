"显示行号
set number
"显示相对行号
"set relativenumber
"高亮当前行
set cursorline
"语法高亮
syntax on 

" 开启自动缩进，新的一行会自动与上一行对齐
set smartindent
set smarttab
" 在输入搜索词时，实时高亮显示匹配项（增量搜索）
set incsearch

" 高亮显示所有搜索结果
set hlsearch

" 搜索时忽略大小写
set ignorecase

" 如果搜索词中包含了大写字母，则自动切换为大小写敏感搜索
set smartcase
" 开启持久化撤销（undo），即使关闭再打开文件，也能撤销之前的更改
"set undofile

" undo目录
"silent !mkdir -p ~/.cache/vim/undo
"set undodir=~/.cache/vim/undo

" 剪贴板 gvim的功能
set clipboard=unnamedplus

" 接管鼠标事件
set mouse=a

" 渲染tab为4格
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" ================================
" 插件管理：vim-plug
" ================================
call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'

call plug#end()

" ================================
" coc.nvim 基础配置
" ================================
set hidden
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes

" 让补全菜单像 IDE
set completeopt=menuone,noselect

" Tab 补全
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()

inoremap <silent><expr> <S-TAB>
      \ pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" 回车确认补全
inoremap <silent><expr> <CR>
      \ pumvisible() ? coc#_select_confirm() : "\<CR>"

" 常用快捷键
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
nmap <leader>rn <Plug>(coc-rename)

" ===== 让补全菜单更深、更不刺眼 =====
set completeopt=menuone,noselect

" 普通菜单背景/文字
hi Pmenu      ctermbg=236 ctermfg=252
" 选中项
hi PmenuSel   ctermbg=240 ctermfg=231
" 滚动条背景/滑块
hi PmenuSbar  ctermbg=235
hi PmenuThumb ctermbg=245

" ===== coc 浮窗/提示也变深 =====
hi CocFloating  ctermbg=236 ctermfg=252
hi CocMenuSel   ctermbg=240 ctermfg=231
hi CocSearch    ctermbg=238 ctermfg=220

" ===== coc 参数提示 / inlay hints 颜色变低存在感 =====
augroup MyCocHintColors
  autocmd!
  autocmd ColorScheme * call s:FixCocHintColors()
  autocmd VimEnter * call s:FixCocHintColors()
augroup END

function! s:FixCocHintColors() abort
  " 终端真彩色
  if exists('+termguicolors') && &termguicolors
    " 文字更暗
    hi CocInlayHint guifg=#6f6f6f guibg=NONE
    " 如果它是浮动块背景太亮，顺便压暗
    hi CocHintFloat guifg=#6f6f6f guibg=#252525
    " 有些版本/主题用这个
    hi CocHintSign  guifg=#6f6f6f guibg=NONE
  else
    " 256 色终端
    hi CocInlayHint ctermfg=243 ctermbg=NONE
    hi CocHintFloat ctermfg=243 ctermbg=235
    hi CocHintSign  ctermfg=243 ctermbg=NONE
  endif
endfunction

" ================================
" NERDTree 配置（VSCode 风格）
" ================================

" F2 打开 / 关闭 NERDTree
nnoremap <F2> :NERDTreeToggle<CR>

" 显示隐藏文件（.git .clangd 等）
let g:NERDTreeShowHidden = 1

" NERDTree 窗口宽度
let g:NERDTreeWinSize = 30

" 打开文件后，光标回到编辑区
let g:NERDTreeQuitOnOpen = 0

" 高亮当前文件
let g:NERDTreeHighlightCursorline = 1

" ================================
" 启动 / 打开文件时自动打开并定位 NERDTree
" ================================

" 如果是用 vim 打开一个文件
" 自动打开 NERDTree，并定位到该文件
autocmd VimEnter * if argc() == 1 && filereadable(argv()[0]) |
      \ execute 'NERDTreeFind' |
      \ wincmd p |
      \ endif

" 如果是 vim 直接打开一个目录
" 自动打开 NERDTree
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) |
      \ execute 'NERDTree' argv()[0] |
      \ wincmd p |
      \ endif

" ===== 让 signcolumn 融入背景，不再像白边 =====
if exists('+termguicolors') && &termguicolors
  hi SignColumn guibg=NONE
else
  hi SignColumn ctermbg=NONE
endif

