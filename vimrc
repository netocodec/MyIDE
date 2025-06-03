" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

set fillchars+=vert:\|
colorscheme nightfox
syntax on
set background=dark
set ruler
set mouse=a " set the value to c to disable
set relativenumber
set hidden
set number
set smartindent
set st=4 sw=4 et
set shiftwidth=4
set backspace=indent,eol,start
set tabstop=4
set noexpandtab
let g:vim_json_syntax_conceal = 0
set laststatus=2
set autoread
set statusline="Welcome Netocodec, Ready To Code?!"


" == Plug VIM

call plug#begin()
  Plug 'EdenEast/nightfox.nvim'
  Plug 'preservim/nerdtree'
  Plug 'mattn/emmet-vim'
  Plug 'itchyny/lightline.vim'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'easymotion/vim-easymotion'
  Plug 'othree/yajs.vim'
  Plug 'calviken/vim-gdscript3'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-python/python-syntax'
  Plug 'rust-lang/rust.vim'
call plug#end()

" Opens VIM on the same directory as the file
set autochdir
autocmd BufEnter * silent! lcd %:p:h

" GO Syntax Highlight Configuration
filetype plugin indent on

set autowrite

" Python Syntax Highlight

let g:python_highlight_all = 1

" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Status line types/signatures
let g:go_auto_type_info = 1

" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" Map keys for most used commands.
" Ex: `\b` for building, `\r` for running and `\b` for running test.
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" NERDTree keys
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" VIM Window split manager
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
