function! debuffer#command(bang, command, args) range abort
    let buffers = {}
    let bang = a:bang ? '!' : ''
    let original_window_id = win_getid()
    let empty_buffer_number = 0
    let num_other_buffers = 0

    if a:0 > 0
        for value in a:args
            let buffer_number = value =~# '^\d\+$' ? str2nr(value) : bufnr(value)
            let buffers[buffer_number] = win_findbuf(buffer_number)
        endfor
    else
        for buffer_number in range(a:firstline, a:lastline)
            let buffers[buffer_number] = win_findbuf(buffer_number)
        endfor
    endif

    for buffer_number in range(1, bufnr('$'))
        if !has_key(buffers, buffer_number) && buflisted(buffer_number) && getbufvar(buffer_number, '&modifiable')
            let num_other_buffers += 1
        endif
    endfor

    for [buffer_number, window_ids] in items(buffers)
        if !getbufvar(buffer_number, '&modified') || a:bang
            for window_id in window_ids
                call win_gotoid(window_id)

                if num_other_buffers < 1
                    if empty_buffer_number == 0
                        enew!
                        let empty_buffer_number = bufnr('%')
                    else
                        execute $'buffer! {empty_buffer_number}'
                    endif
                else
                    let other_buffer_number = bufnr('#')
                    if other_buffer_number > 0 && buflisted(other_buffer_number) && other_buffer_number != buffer_number
                        buffer! #
                    else
                        bprevious!
                    endif
                endif
            endfor
        endif

        execute $'{command}{bang} {buffer_number}'
    endfor

    call win_gotoid(original_window_id)
endfunction

function! debuffer#delete(bang, ...) abort
    call debuffer#command(a:bang, 'bdelete', a:000)
endfunction

function! debuffer#wipeout(bang, ...) abort
    call debuffer#command(a:bang, 'bwipeout', a:000)
endfunction

function! debuffer#unload(bang, ...) abort
    call debuffer#command(a:bang, 'bunload', a:000)
endfunction
