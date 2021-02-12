set showtabline=2

command! MarksDeleteAll call marksline#delete()

augroup matksline
    autocmd!
    autocmd VimEnter * call marksline#delete()
    autocmd VimEnter * call marksline#render()
    autocmd BufWritePost,FileWritePost * call marksline#add()
augroup END
