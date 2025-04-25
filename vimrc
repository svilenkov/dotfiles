set encoding=utf-8

" Prevents Neovim's new Lua filetype detection crash when no file is passed to
" nvim, especially during nvim install.sh.
if argc() == 0 || bufexists(1)
  filetype on
  filetype indent on
  filetype plugin on
endif

" set cm=blowfish2
set viminfo=
set nobackup
set nowritebackup
set modelines=0
set nomodeline
set nocompatible      " We're running Vim, not Vi!
set laststatus=2
set tabstop=2
set pyxversion=3
set shiftwidth=2
set showtabline=0

" https://stackoverflow.com/q/2414626
set hidden

let g:coc_global_extensions = ['coc-solargraph']
let g:python3_host_prog = '$HOME/.pyenv/versions/'. system('pyenv latest -p | tr -d "\n"') . '/bin/python3'
let g:python_version = '3'
let g:neovim_rpc#py = 'python3'
let s:pyeval = function('py3eval')

syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
set number

let mapleader = ","

set runtimepath^=~/.vim/bundle/ctrlp.vim

" https://stackoverflow.com/a/42118416
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" https://apple.stackexchange.com/questions/168857
"if &term =~ "xterm"
"    let &t_ti = "\<Esc>[?47h"
"    let &t_te = "\<Esc>[?47l"
"endif

" https://github.com/vim-airline/vim-airline/issues/124#issuecomment-22389800
set ttimeoutlen=1

" https://vi.stackexchange.com/a/2163
set backspace=indent,eol,start

" https://superuser.com/questions/558876
set signcolumn=yes

" https://stackoverflow.com/a/28334012
highlight clear SignColumn

let g:CtrlSpaceDefaultMappingKey = "<C-space> "
nnoremap <silent><C-p> :CtrlSpace O<CR>

" Paste from system clipboard (+)
nnoremap <leader><S-P> :put +<CR>

" Yank current line into system clipboard
nnoremap <leader>c "+yy

" Yank visually selected text into system clipboard
vnoremap <leader>c "+y

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1

nnoremap <leader>1 <Plug>AirlineSelectTab1

call plug#begin('~/.vim/plugged')

Plug 'dstein64/vim-startuptime'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'vim-syntastic/syntastic'
Plug 'rust-lang/rust.vim'
" Motion enchancements
Plug 'justinmk/vim-sneak'
" UI enhancements
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'MicahElliott/Rocannon'
Plug 'preservim/tagbar'
" https://stackoverflow.com/questions/26788786
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-test/vim-test'
Plug 'reasonml-editor/vim-reason-plus'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'hashivim/vim-terraform'
Plug 'vim-syntastic/syntastic'
Plug 'juliosueiras/vim-terraform-completion'
Plug 'hecal3/vim-leader-guide'
Plug 'pearofducks/ansible-vim'
"Plug 'neoclide/coc-clangd', {'do': 'yarn install --frozen-lockfile'}

if has('nvim')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
  Plug 'fannheyward/telescope-coc.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'build': ':TSUpdate'}
	Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}
endif

"else
""  Plug 'Shougo/deoplete.nvim'
""  Plug 'roxma/nvim-yarp'
""  Plug 'roxma/vim-hug-neovim-rpc'
"endif
"Plug 'Shougo/echodoc.vim'

let g:chadtree_settings = { "theme.icon_glyph_set" : 'ascii' }
nnoremap <leader>e <cmd>CHADopen<cr>
nnoremap <leader>[ <cmd>Files<cr>

call plug#end()

"let g:deoplete#enable_at_startup = 0
"call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

set cmdheight=2
let g:echodoc_enable_at_startup = 1

let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/usr/local/lib/rustlib"

let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'

""" Customize colors
func! s:my_colors_setup() abort
    " this is an example
    hi Pmenu ctermbg=0 ctermfg=13 guifg=#ffa0a0 guibg=#d7e5dc
    hi PmenuSel guibg=#b7c7b7 gui=NONE
    hi PmenuSbar guibg=#bcbcbc
    hi PmenuThumb guibg=#585858
endfunc

augroup colorscheme_coc_setup | au!
    au ColorScheme * call s:my_colors_setup()
augroup END

call s:my_colors_setup()

" NERDCommenter Key Mappings
let g:NERDCreateDefaultMappings = 0
nmap <leader>nc <Plug>NERDCommenterComment        " ,nc = comment line(s)
nmap <leader>nu <Plug>NERDCommenterUncomment      " ,nu = uncomment
nmap <leader>nt <Plug>NERDCommenterToggle         " ,nt = toggle comment
nmap <leader>ny <Plug>NERDCommenterYank           " ,ny = yank with comment
nmap <leader>n$ <Plug>NERDCommenterToEOL          " ,n$ = comment to end-of-line
nmap <leader>n<Space> <Plug>NERDCommenterToggle   " ,n<Space> = toggle smart

vmap <leader>nc <Plug>NERDCommenterComment
vmap <leader>nu <Plug>NERDCommenterUncomment
vmap <leader>nt <Plug>NERDCommenterToggle
vmap <leader>ny <Plug>NERDCommenterYank
vmap <leader>n$ <Plug>NERDCommenterToEOL
vmap <leader>n<Space> <Plug>NERDCommenterToggle


" Leader + number = switch to tab N
nnoremap <leader>1 :tabnext 1<CR>
nnoremap <leader>2 :tabnext 2<CR>
nnoremap <leader>3 :tabnext 3<CR>
nnoremap <leader>4 :tabnext 4<CR>
nnoremap <leader>5 :tabnext 5<CR>
nnoremap <leader>6 :tabnext 6<CR>
nnoremap <leader>7 :tabnext 7<CR>
nnoremap <leader>8 :tabnext 8<CR>
nnoremap <leader>9 :tabnext 9<CR>

" ,tn = new tab
nnoremap <leader>tn :tabnew<CR>

" ,tc = close tab
nnoremap <leader>tc :tabclose<CR>

" ,[ = previous tab
nnoremap <leader>[ :tabprevious<CR>

" ,<Left> = previous buffer
nnoremap <leader><Left> :bprevious<CR>

" ,<Right> = next buffer
nnoremap <leader><Right> :bnext<CR>

" ,<BS> = delete buffer
nnoremap <leader><BS> :bd<CR>

" ,b<number> = go to buffer <number>
" Uses expression map to allow input like `,b3`
for i in range(1, 9)
  execute 'nnoremap <leader>b'.i.' :buffer '.i.'<CR>'
endfor

" Resize vertically with -/+ keys (no shift needed!)
nnoremap <leader>h :vertical resize -5<CR>  " Shrink width
nnoremap <leader>l :vertical resize +5<CR>  " Grow width

" Resize horizontally with j/k keys
nnoremap <leader>j :resize -2<CR>  " Shrink height
nnoremap <leader>k :resize +2<CR>  " Grow height

" vba Plug-in(s) installed via :so %:
"
" https://stackoverflow.com/a/20750630
"

function! s:init_lynx()
  nnoremap <nowait><buffer> <C-F> i<PageDown><C-\><C-N>
  tnoremap <nowait><buffer> <C-F> <PageDown>

  nnoremap <nowait><buffer> <C-B> i<PageUp><C-\><C-N>
  tnoremap <nowait><buffer> <C-B> <PageUp>

  nnoremap <nowait><buffer> <C-D> i:DOWN_HALF<CR><C-\><C-N>
  tnoremap <nowait><buffer> <C-D> :DOWN_HALF<CR>

  nnoremap <nowait><buffer> <C-U> i:UP_HALF<CR><C-\><C-N>
  tnoremap <nowait><buffer> <C-U> :UP_HALF<CR>

  nnoremap <nowait><buffer> <C-N> i<Delete><C-\><C-N>
  tnoremap <nowait><buffer> <C-N> <Delete>

  nnoremap <nowait><buffer> <C-P> i<Insert><C-\><C-N>
  tnoremap <nowait><buffer> <C-P> <Insert>

  nnoremap <nowait><buffer> u     i<Left><C-\><C-N>
  nnoremap <nowait><buffer> U     i<C-U><C-\><C-N>
  nnoremap <nowait><buffer> <CR>  i<CR><C-\><C-N>
  nnoremap <nowait><buffer> gg    i:HOME<CR><C-\><C-N>
  nnoremap <nowait><buffer> G     i:END<CR><C-\><C-N>
  nnoremap <nowait><buffer> zl    i:SHIFT_LEFT<CR><C-\><C-N>
  nnoremap <nowait><buffer> zL    i:SHIFT_LEFT<CR><C-\><C-N>
  nnoremap <nowait><buffer> zr    i:SHIFT_RIGHT<CR><C-\><C-N>
  nnoremap <nowait><buffer> zR    i:SHIFT_RIGHT<CR><C-\><C-N>
  nnoremap <nowait><buffer> gh    i:HELP<CR><C-\><C-N>
  nnoremap <nowait><buffer> cow   i:LINEWRAP_TOGGLE<CR><C-\><C-N>

  tnoremap <buffer> <C-C> <C-G><C-\><C-N>
  nnoremap <buffer> <C-C> i<C-G><C-\><C-N>
endfunction

command! -nargs=1 Web       vnew|call termopen('lynx -scrollbar '.shellescape(substitute(<q-args>,'#','%23','g')))|call <SID>init_lynx()
command! -nargs=1 Websearch vnew|call termopen('lynx -scrollbar https://duckduckgo.com/?q='.shellescape(substitute(<q-args>,'#','%23','g')))|call <SID>init_lynx()
