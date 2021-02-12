let g:marks = 'ABCDEFGHJIKLMNOPQRSTUVWXYZ'

" возвращает список из букв активных меток
function! marksline#letters()
    try
        " получаем список меток
        let l:output = ''
        redir => l:output
        silent exec "normal! :marks " . g:marks . "\<CR>"
        redir END
        let l:lines = split(l:output, "\n")
    catch /.*/
        return []
    endtry

    if len(l:lines) == 0 
        return []
    endif

    " удаляем заголовок
    call remove(l:lines, 0)

    let l:letters = []

    for l:line in l:lines
        let l:matches = matchlist(l:line, '\v(\u{1})\s+(\d+)\s+(\d+)?')
        call add(l:letters, l:matches[1])
    endfor

    return l:letters
endfunction

" пути к помеченным файлам
function! marksline#paths()
    let l:letters = marksline#letters()
    let l:paths = []

    for l:letter in l:letters
        let l:path = getbufinfo(getpos("'" . l:letter)[0])[0].name
        call add(l:paths, [l:letter, l:path]) 
    endfor

    return l:paths
endfunction

" формируем полоску меток
function! marksline#tabline()
    let l:paths = marksline#paths()

    let l:tabline = ''
    let l:count = len(l:paths)

    for l:index in range(l:count)
        let l:letter = l:paths[l:index][0]
        let l:path = l:paths[l:index][1]

        " только название файла
        let l:filename = fnamemodify(l:path, ":t:r")  
        " выделяем букву
        let l:filename = substitute(l:filename, l:letter, '[' . l:letter . ']', "")
        " добавляем в строку
        let l:tabline .= '%#TabLine# ' . l:filename . ' ' 

        " закрашиваем конец строки
        if l:index != l:count - 1
            let l:tabline .= '%#TabLineFill#%T '
        endif
    endfor

    let l:tabline .= '%#TabLineFill#%T'

    return l:tabline
endfunction

function! marksline#render()
    set tabline=%!marksline#tabline()
endfunction

" подбираем для текущего файла подходящую мету и ставим её
function! marksline#add()
    if s:fileHasMark() 
        return 
    endif 

    let l:filename = expand("%:t:r")
    for l:letter in split(l:filename, '\zs')
        let l:letterUppercase = toupper(l:letter)
        if s:exist(l:letterUppercase)
            continue
        endif

        exec "normal! m" . l:letterUppercase 
        return
    endfor

    call marksline#render()
endfunction

" проверяем есть ли на текущем файле метка
function! s:fileHasMark()
    let l:currentPath = expand('%:p') 
    for [l:letter, l:path] in marksline#paths()
       if l:path == l:currentPath
           return 1
       endif 
    endfor

    return 0
endfunction

" проверяем есть ли такая метка
function! s:exist(letter)
    let l:letters = marksline#letters()

    for l:letter in l:letters
        if l:letter == a:letter
            return 1
        endif
    endfor

    return 0
endfunction

" удаляет все метки
function! marksline#delete()
    silent exec "normal! :delmarks " . g:marks . "\<CR>" 
endfunction
