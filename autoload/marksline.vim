
" формируем полоску меток
function! marksline#tabline()
    let l:paths = source#paths()

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

        call source#add(l:letterUppercase, expand('%:p'))
        break 
    endfor

    call marksline#render()
endfunction

" проверяем есть ли на текущем файле метка
function! s:fileHasMark()
    let l:currentPath = expand('%:p') 
    for [l:letter, l:path] in source#paths()
       if l:path == l:currentPath
           return 1
       endif 
    endfor

    return 0
endfunction

" проверяем есть ли такая метка
function! s:exist(letter)
    for [l:letter, l:path] in source#paths()
        if l:letter == a:letter
            return 1
        endif
    endfor

    return 0
endfunction

" удаляет все метки
function! marksline#delete()
    call source#clear()
endfunction
