set encoding=utf-8

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

set runtimepath^=~/.vim/bundle/ctrlp.vim

"colorscheme base16-atlas

" https://stackoverflow.com/a/42118416
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

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

" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Or build from source code by using yarn: https://yarnpkg.com
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}

Plug 'MicahElliott/Rocannon'

Plug 'preservim/tagbar'

" https://stackoverflow.com/questions/26788786
Plug 'preservim/nerdcommenter'

"if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
"  Plug 'Shougo/deoplete.nvim'
"  Plug 'roxma/nvim-yarp'
"  Plug 'roxma/vim-hug-neovim-rpc'
"endif

"Plug 'Shougo/echodoc.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'vim-test/vim-test'

Plug 'reasonml-editor/vim-reason-plus'


Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

let g:chadtree_settings = { "theme.icon_glyph_set" : 'ascii' }
if has('nvim')
  Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
endif

let mapleader = ","
nnoremap <leader>e <cmd>CHADopen<cr>
nnoremap <leader>[ <cmd>Files<cr>

Plug 'vim-ctrlspace/vim-ctrlspace'

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

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" vba Plug-in(s) installed via :so %:
"
" https://stackoverflow.com/a/20750630
"

" https://apple.stackexchange.com/questions/168857
"if &term =~ "xterm"
"    let &t_ti = "\<Esc>[?47h"
"    let &t_te = "\<Esc>[?47l"
"endif
