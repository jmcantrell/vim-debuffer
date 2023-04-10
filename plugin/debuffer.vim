if exists('g:loaded_debuffer')
    finish
endif
let g:loaded_debuffer = 1

command! -bang -range -addr=buffers -nargs=* BDelete :silent! <line1>,<line2>call debuffer#delete(<bang>0, <f-args>)
command! -bang -range -addr=buffers -nargs=* BWipeout :silent! <line1>,<line2>call debuffer#wipeout(<bang>0, <f-args>)
