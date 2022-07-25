# Fix man page formatting (colours)

````
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
````

````
export MANPAGER="less -R --use-color -Dd+r -Du+b"
````

| Original | With LESS+GROFF defined | With MANPAGER defined |
| --- | --- | --- |
| <img src="man-ls-black-and-white.jpg" width="450"/> | <img src="man-ls-colour.jpg" width="450"/> | <img src="man-ls-colour2.jpg" width="450"> |