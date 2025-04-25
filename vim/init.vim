set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
let g:python_host_prog = '/Users/igor/.pyenv/versions/neovim/bin/python'
let g:python3_host_prog = '/Users/igor/.pyenv/versions/neovim/bin/python'

set termguicolors

hi! NormalFloat guibg=#1e1e1e guifg=#dddddd
hi! FloatBorder guibg=#1e1e1e guifg=#ffffff
hi! CocFloating guibg=#1e1e1e guifg=#dddddd
hi! CocFloatBorder guibg=#1e1e1e guifg=#ffffff gui=bold

hi! CtrlSpaceNormal      guifg=#dddddd guibg=#1e1e1e
hi! CtrlSpaceSelected    guifg=#ffffff guibg=#444444 gui=bold
hi! CtrlSpaceSearch      guifg=#00ffcc guibg=#1e1e1e
hi! CtrlSpaceStatus      guifg=#cccccc guibg=#1e1e1e
hi! CtrlSpaceBorder      guifg=#999999 guibg=#1e1e1e