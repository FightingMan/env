function! <SID>BlockDocFunc(type)
    let l:paste = &g:paste
    let &g:paste = 1

    let l:workline = line(".") + 1
    let l:commentline = l:workline - 2
    let l:name = substitute(getline("."), '^\(.*\)\/\/.*$', '\1', "")
    let l:name = substitute(getline("."), '^\(.*\)\/\*.*$', '\1', "")
    let l:name = substitute(l:name, '\s\+$', '', "")
    let l:name = substitute(l:name, '{$', '', "")
    let l:name = substitute(l:name, '\s\+$', '', "")
    let l:name = substitute(l:name, '^\s\+', '', "")
    let l:indent = matchstr(getline("."), '^\s*')

    exe 'norm! ' . l:commentline . 'G$'
    if (a:type == 1)
        exe 'norm! o'. l:indent . '/* {{{ ' . l:name . ' */'
    else
        exe 'norm! o'. l:indent . '/* {{{ */'
    endif

    exe 'norm! j$%'

    let l:indent2 = matchstr(getline("."), '^\s*')
    exe 'norm! o' . l:indent2 . '/* }}} */'
    exe 'norm! ' . l:workline . 'G^'

    let &g:paste = l:paste
endfunction

autocmd FileType go,c,php,cpp,h,hpp nnoremap <silent> <Leader>v :call <SID>BlockDocFunc(1)<CR>
autocmd FileType go,c,php,cpp,h,hpp nnoremap <silent> <Leader>b :call <SID>BlockDocFunc(0)<CR>

function! <SID>InsertGoHead()

    let cur_line = 1
    call append(cur_line-1, "/**")
    call append(cur_line, " * Description")
    let cur_line = cur_line + 1
    call append(cur_line, " *")
    let cur_line = cur_line + 1
    call append(cur_line, " * @file ".<SID>GetFileName())
    let cur_line = cur_line + 1
    call append(cur_line, " * @date ".<SID>GetDate())
    let cur_line = cur_line + 1
    call append(cur_line, " * @author ".<SID>GetUserName()." <".<SID>GetEmail().">")
    let cur_line = cur_line + 1
    call append(cur_line, " * @copyright (c) ".<SID>GetYear()." ".<SID>GetCopyowner())
    let cur_line = cur_line + 1
    call append(cur_line, " */")
    "call append(line("$"), "/* vim: set ts=4 sw=4 sts=4 tw=100 et: */")
    call append(line("$"), "/*")
    call append(line("$"), " * Local variables:")
    call append(line("$"), " * tab-width: 4")
    call append(line("$"), " * c-basic-offset: 4")
    call append(line("$"), " * End:")
    call append(line("$"), " * vim600: noet sw=4 ts=4 fdm=marker")
    call append(line("$"), " * vim<600: noet sw=4 ts=4")
    call append(line("$"), " */")

    "startinsert!

    call cursor(line('$') - 8, 1)
endfunction

function! <SID>GetFileName()
    let fname = expand("%")
    return fname
endfunction

function! <SID>GetDate()
    "windows
    let date = system("date /T")
    if (v:shell_error!=0)
        "linux
        let date = system("date +\"%Y-%m-%d %H:%M:%S\" ")
    endif

    if (date[strlen(date)-1]=="\n")
        let date = strpart(date, 0, strlen(date)-1)
    endif
    return date
endfunction

function! <SID>GetUserName()
    let home = $HOME
    let user = matchstr(home, '[^/\\]\+$')
    return user
endfunction

function! <SID>GetEmail()
    return "jianghua01@baidu.com"
endfunction

function! <SID>GetCopyowner()
    return "Baidu Inc."
endfunction

function! <SID>GetYear()
    return strftime("%Y")
endfunction

autocmd BufNewFile *.go :call <SID>InsertGoHead()
autocmd BufNewFile *.php :call <SID>InsertGoHead()
autocmd BufNewFile *.c :call <SID>InsertGoHead()
autocmd BufNewFile *.cpp :call <SID>InsertGoHead()
autocmd BufNewFile *.h :call <SID>InsertGoHead()
autocmd BufNewFile *.hpp :call <SID>InsertGoHead()

autocmd FileType hpp,h,go,c,cpp,java,sh,awk,vim,sed,perl,python,php,javascript,css nnoremap <silent> <Leader>h :call <SID>InsertGoHead()<CR>
