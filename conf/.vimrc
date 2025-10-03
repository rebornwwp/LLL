" Pathogen load
filetype off

call pathogen#infect()
call pathogen#helptags()

filetype plugin indent on
syntax on

set number

set ruler 
"打开文件类型检测功能
filetype on
 
"关闭vi模式
set nocp
 
"与windows共享剪贴板
set clipboard+=unnamed
 
"取消VI兼容，VI键盘模式不易用
set nocompatible
 
 
"历史命令保存行数 
set history=100 
 
"当文件被外部改变时自动读取
set autoread 
 
"取消自动备份及产生swp文件
set nobackup
set nowb
set noswapfile
 
"允许区域选择
set selection=exclusive
set selectmode=mouse,key
 
"高亮光标所在行
set cursorline
 
"取消光标闪烁
set novisualbell
 
"总是显示状态行
set laststatus=2
 
"状态栏显示当前执行的命令
set showcmd
 
"标尺功能，显示当前光标所在行列号
set ruler
 
"设置命令行高度为3
set cmdheight=1
 
"粘贴时保持格式
set paste
 
"高亮显示匹配的括号
set showmatch
 
"在搜索的时候忽略大小写
set ignorecase
 
"高亮被搜索的句子
set hlsearch
 
"在搜索时，输入的词句的逐字符高亮（类似firefox的搜索）
set incsearch
 
"继承前一行的缩进方式，特别适用于多行注释
set autoindent
 
 
"统一缩进为4
set softtabstop=4
set shiftwidth=4
 
"允许使用退格键，或set backspace=2
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
 
"取消换行
set nowrap

hi Search term=reverse ctermfg=235 ctermbg=15 guifg=#282828 guibg=#ffffff
let g:pymode = 1

let g:pymode_warnings = 1

let g:pymode_options_max_line_length = 79

let g:pymode_options_colorcolumn = 1

let g:pymode_quickfix_minheight = 3

let g:pymode_quickfix_maxheight = 6

let g:pymode_indent = 1

let g:pymode_folding = 1

let g:pymode_motion = 1

let g:pymode_python = 'python3'

let g:pymode_run = 1
let g:pymode_run_bind = '<leader>r'

let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'
let g:pymode_breakpoint_cmd = ''

let g:pymode_lint = 1
let g:pymode_lint_on_write = 1
let g:pymode_lint_on_fly = 0
let g:pymode_lint_message = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
let g:pymode_lint_options_pep8 = {'max_line_length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pylint =
        \ {'max-line-length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pep257 = {}

let g:pymode_rope_show_doc_bind = '<C-c>d'
let g:pymode_rope_regenerate_on_write = 1

let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_completion_bind = '<C-Space>'
let g:pymode_rope_autoimport = 0
let g:pymode_rope_autoimport_modules = ['os', 'shutil', 'datetime']
let g:pymode_rope_autoimport_import_after_complete = 0

let g:pymode_rope_rename_bind = '<C-c>rr'

let g:pymode_rope_organize_imports_bind = '<C-c>ro'
let g:pymode_rope_autoimport_bind = '<C-c>ra'

let g:pymode_rope_extract_method_bind = '<C-c>rm'
let g:pymode_rope_extract_variable_bind = '<C-c>rl'

let g:pymode_syntax = 1
let g:pymode_syntax_slow_sync = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_print_as_function = 0
let g:pymode_syntax_highlight_async_await = g:pymode_syntax_all
let g:pymode_syntax_highlight_equal_operator = g:pymode_syntax_all
let g:pymode_syntax_highlight_self = g:pymode_syntax_all
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

let g:pymode_syntax_string_formatting = g:pymode_syntax_all
let g:pymode_syntax_string_format = g:pymode_syntax_all
let g:pymode_syntax_string_templates = g:pymode_syntax_all
let g:pymode_syntax_doctests = g:pymode_syntax_all
let g:pymode_syntax_builtin_objs = g:pymode_syntax_all
let g:pymode_syntax_string_formatting = g:pymode_syntax_all
let g:pymode_syntax_builtin_types = g:pymode_syntax_all
let g:pymode_syntax_highlight_exceptions = g:pymode_syntax_all
let g:pymode_syntax_docstrings = g:pymode_syntax_all

"Python 注释
function InsertPythonComment()
    exe 'normal'.1.'G'
    let line = getline('.')
    if line =~ '^#!.*$' || line =~ '^#.*coding:.*$'
        return
    endif
    normal O
    call setline('.', '#!/usr/bin/env python')
    normal o
    call setline('.', '# -*- coding:utf-8 -*-')
    normal o
    call setline('.', '#')
    normal o
    call setline('.', '#   Author  :   '.g:python_author)
    normal o
    call setline('.', '#   E-mail  :   '.g:python_email)
    normal o
    call setline('.', '#   Date    :   '.strftime("%y/%m/%d %H:%M:%S"))
    normal o
    call setline('.', '#   Desc    :   ')
    normal o
    call setline('.', '#')
    normal o
    call cursor(7, 18)
endfunction
function InsertCommentWhenOpen()
    if a:lastline == 1 && !getline('.')
        call InsertPythonComment()
    end
endfunc
au FileType python :%call InsertCommentWhenOpen()
au FileType python map <F4> :call InsertPythonComment()<cr>

let g:python_author = 'vito'
let g:python_email  = 'rebornwwp.gmail.com'

" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
 set termguicolors
endif

" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Theme
syntax enable
colorscheme tender
let g:lightline = { 'colorscheme': 'tender' }

set laststatus=2

let g:indentLine_char = '┆'
let g:indentLine_concealcursor = 'inc'
let g:indentLine_conceallevel = 2

"NERDTree快捷键
nmap <F2> :NERDTree  <CR>
" NERDTree.vim
let g:NERDTreeWinPos="left"
let g:NERDTreeWinSize=25
let g:NERDTreeShowLineNumbers=1
let g:neocomplcache_enable_at_startup = 1

