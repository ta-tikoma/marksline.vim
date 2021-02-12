let g:marks = 'ABCDEFGHJIKLMNOPQRSTUVWXYZ'

" ########################################
" # источкни меток глобальная переменная #
" ########################################

" хранит массив из ['Буква метки', 'Абсолютный путь к файлу']
let g:markssource = []

" возвращает массив из ['Буква метки', 'Абсолютный путь к файлу']
function! source#paths()
    " let l:letters = marksline#letters()
    " let l:paths = []
    "
    " for l:letter in l:letters
    "     let l:path = getbufinfo(getpos("'" . l:letter)[0])[0].name
    "     call add(l:paths, [l:letter, l:path]) 
    " endfor
    "
    " return l:paths
    return g:markssource
endfunction

function! source#add(letter, path)
    exec "normal! m" . a:letter
    call add(g:markssource, [a:letter, a:path])
endfunction

function! source#clear()
    silent exec "normal! :delmarks " . g:marks . "\<CR>" 
    let g:markssource = []
endfunction


" ########################################
" # источкни меток реальные метки        #
" ########################################

" возвращает массив из ['Буква метки', 'Абсолютный путь к файлу']
" function! source#paths()
"     let l:letters = marksline#letters()
"     let l:paths = []
"
"     for l:letter in l:letters
"         let l:path = getbufinfo(getpos("'" . l:letter)[0])[0].name
"         call add(l:paths, [l:letter, l:path]) 
"     endfor
"
"     return l:paths
" endfunction

" возвращает список из букв активных меток
" function! source#letters()
"     try
"         " получаем список меток
"         let l:output = ''
"         redir => l:output
"         silent exec "normal! :marks " . g:marks . "\<CR>"
"         redir END
"         let l:lines = split(l:output, "\n")
"     catch /.*/
"         return []
"     endtry
"
"     if len(l:lines) == 0 
"         return []
"     endif
"
"     " удаляем заголовок
"     call remove(l:lines, 0)
"
"     let l:letters = []
"
"     for l:line in l:lines
"         let l:matches = matchlist(l:line, '\v(\u{1})\s+(\d+)\s+(\d+)?')
"         call add(l:letters, l:matches[1])
"     endfor
"
"     return l:letters
" endfunction

" function! source#add(letter, path)
"     exec "normal! m" . a:letter
" endfunction

" function! source#clear()
"     silent exec "normal! :delmarks " . g:marks . "\<CR>" 
" endfunction
