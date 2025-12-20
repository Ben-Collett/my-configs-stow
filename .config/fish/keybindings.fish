bind -e -M insert \cl
bind -e -M insert \cj
bind -e -M insert \ck
bind -e -M insert \ch
bind \cd exit
bind -M insert ctrl-g 'echo; git status -s' repaint
bind -M insert ctrl-f yy repaint
bind -M insert ctrl-s 'echo; eza --icons' repaint
bind -M insert \ck up-or-search
bind -M insert \cj complete
