"参考资料： https://linux.cn/article-5880-1.html
"> mkdir -p ~/.vim/bundle 
"> git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"> Windows 版本参考： http://blog.csdn.net/zhuxiaoyang2000/article/details/8636472


"关闭 VI 的一致性模式，避免以前版本的一些 Bug 和局限
set nocompatible

"开启语法高亮
syntax enable
set syntax=on
"设置 C/C++ 方式自动对齐
set autoindent
set smartindent
set cindent

set smartcase

"设置 TAB 键宽度
set tabstop=4
"设置按空格键可以一次删除4个空格
set softtabstop=4
set smarttab
"设置自动对齐空格数
set shiftwidth=4

"配置退格键的工作方式
set backspace=indent,eol,start
"显示行号
set number
"高亮显示搜索匹配的字符
set hlsearch
"编辑过程中编辑器右下角显示光标的行列信息
set ruler

"设置模式匹配，当光标定位到左括号时，会匹配相应的右括号
set showmatch
"在状态栏显示正在输入的命令
set showcmd

"突出显示当前的行和列
"set cursorline
"set cursorcolumn

"设置取消备份，禁止临时文件生成
set nobackup
set noswapfile

"自动检测文件类型
filetype off
"针对不同文件采取不同的缩进方式
filetype indent on
"允许插件
filetype plugin on
"启用智能补全
filetype plugin indent on
"set runtimepath+=$GOROOT/misc/vim


"set filetype=python
au BufNewFile,BufRead *.py,*.pyw setf python
autocmd FileType python setlocal et sta sw=4 sts=4

"set filetype=go
autocmd BufWritePre *.go :Fmt

set completeopt=longest,menu

"设置 Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"使用 Vundle 来管理 Vundle
Plugin 'gmarik/vundle'

"Powerline 插件，状态栏增强显示
Plugin 'Lokaltog/vim-powerline'
"Vim 有一个状态栏，加上 Powerline 就会有两个状态栏
set laststatus=2
let g:Powerline_symbols='fancy'

Plugin 'c.vim'

Plugin 'cpp.vim'

Plugin 'pydiction'
"pydiction 设置
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'
let g:pydiction_menu_height = 20 "default is 15

"miniBufExplorer
Plugin 'minibufexplorerpp'
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1
let g:miniBufExplMoreThanOne=0


"WM
Plugin 'NERD_tree-Project'
Plugin 'nerdtree-ack'
Plugin 'winmanager'
Plugin 'ctags.vim'
Plugin 'taglist.vim'
nmap wm :WMToggle<CR>
let g:NERDTree_title="[NERDTree]"  
let g:winManagerWindowLayout="NERDTree|TagList"  
  
function! NERDTree_Start()  
    exec 'NERDTree'  
endfunction  
  
function! NERDTree_IsValid()  
    return 1  
endfunction  
  
"omnicppcomplete
Plugin 'omnicppcomplete'
set nocp

call vundle#end()

"guifont
if has ("gui_running")
	colo desert
	set guifont=Monaco:h13
	set go=
else
	colo desert
endif

if has("multi_byte")
    " UTF-8 编码
    set encoding=utf-8
    set termencoding=utf-8
    set formatoptions+=mM
    set fencs=utf-8,gbk

    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif

    if has("win32")
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
        language messages zh_CN.utf-8
    endif
else
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte"
endif

:inoremap ( ()<LEFT>
:inoremap { {}<ESC>i<CR><ESC>O
:inoremap [ []<LEFT>
:inoremap < <><LEFT>
:inoremap ' ''<LEFT>
:inoremap " ""<LEFT>

function! RemovePairs()
    let l:line = getline(".")
    let l:previous_char = l:line[col(".")-1] "取得当前光标前一个字符
    if index(["(", "[", "{"], l:previous_char) != -1
        let l:original_pos = getpos(".")
        execute "normal %"
        let l:new_pos = getpos(".")
 
        ""<LEFT> 如果没有匹配的右括号
        if l:original_pos == l:new_pos
            execute "normal! a\<BS>"
            return
        end
        let l:line2 = getline(".")
        if len(l:line2) == col(".")
            ""<LEFT> 如果右括号是当前行最后一个字符
            execute "normal! v%xa""
        else
            ""<LEFT> 如果右括号不是当前行最后一个字符
            execute "normal! v%xi""
        end
    else
        execute "normal! a\<BS>"
    end
endfunction

" 用退格键删除一个左括号时同时删除对应的右括号
inoremap <BS> <ESC>:call RemovePairs()<CR>a

" 输入一个字符时，如果下一个字符也是括号，则删除它，避免出现重复字符
function! RemoveNextDoubleChar(char)
    let l:line = getline(".")
    let l:next_char = l:line[col(".")] "取得当前光标后一个字符
    if a:char == l:next_char
        execute "normal! l"
    else
        execute "normal! i" . a:char . ""
    end
endfunction

inoremap ) <ESC>:call RemoveNextDoubleChar(')')<CR>a
inoremap ] <ESC>:call RemoveNextDoubleChar(']')<CR>a
inoremap } <ESC>:call RemoveNextDoubleChar('}')<CR>a

