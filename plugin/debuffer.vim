if exists('g:loaded_debuffer')
    finish
endif
let g:loaded_debuffer = 1

command! -bang -range -addr=buffers -nargs=* BDelete call debuffer#delete(<bang>0, <line1>, <line2>, <f-args>)
command! -bang -range -addr=buffers -nargs=* BWipeout call debuffer#wipeout(<bang>0, <line1>, <line2>, <f-args>)
