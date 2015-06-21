### Modules
autoload -Uz compinit promptinit colors
compinit
promptinit
colors

set -o shwordsplit




### Configuration des chemins
PATH="/usr/local/bin/:$PATH"

# SCRIPTS
PATH="/home/amxx/Code/Scripts/:$PATH"

# Go through paths
WORDCHARS=${WORDCHARS/\/}

### Configuration de l’historique
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS

### Configuration des alias
alias ls='ls --color=auto'
alias ll='ls -lhF'
alias la='ls -ahF'
alias grep='grep --color=auto'
alias yu='yaourt -Syua'
alias subl='subl3'
#alias mplayer='mpv --hwdec=vaapi --vo=opengl:lscale=spline36:dither-depth=auto:fbo-format=rgb --no-border'
alias mplayer='mpv --vo=opengl:lscale=spline36:dither-depth=auto:fbo-format=rgb --no-border'
alias mplayer_50='mplayer --autofit=50%'
alias mplayer_hdmi='mplayer --ao="alsa:device=[hw:1,3]"'



### Variables globales
export EDITOR="vim"
export PAGER="less"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


### Configuration des couleurs des TTY
if [ "$TERM" = "linux" ]; then
  echo -en "\e]P0000000" #black
  echo -en "\e]P8555753" #darkgrey
  echo -en "\e]P1ff6b6b" #darkred
  echo -en "\e]P9ff8d8d" #red
  echo -en "\e]P2a3d46e" #darkgreen
  echo -en "\e]PA55ff55" #green
  echo -en "\e]P3eaca75" #brown
  echo -en "\e]PBffd155" #yellow
  echo -en "\e]P4435e87" #darkblue
  echo -en "\e]PC587aa4" #blue
  echo -en "\e]P5cf8243" #darkmagenta
  echo -en "\e]PDf6a24f" #magenta
  echo -en "\e]P6789ec6" #darkcyan
  echo -en "\e]PE46a4ff" #cyan
  echo -en "\e]P7ababab" #lightgrey
  echo -en "\e]PFababab" #white
  #clear #for background artifacting
fi


### Configuration du prompt
setopt promptsubst

#MainC='%B%F{blue}'
#UserC='%B%(#~%F{red}~%F{green})'
#TermC='%B%F{cyan}'
#PathC='%B%F{yellow}'
#TimeC='%F{cyan}'
#CodeC='%B%F{cyan}'

#PS1='%{$MainC%}[$UserC%n@%m%{$MainC%}:$TermC%y%{$MainC%}:$PathC%28<…<%~%<<%{$MainC%}]%#%f%{$reset_color%} '
#RPS1='$TimeC%D{%e.%B.%Y %H.%M}$CodeC [$?]%f%{$reset_color%}'



function powerline_precmd() {
  export PS1="$(powerline-shell.py $? --shell zsh 2> /dev/null)"
}

function install_powerline_precmd()
{
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

install_powerline_precmd





### Configuration des touches 
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history


# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi



# FOCUS TO LAST OPENNED TERMINAL
[[ -n "$DISPLAY" ]] && xset -b
[[ -z "$DISPLAY" ]] && setterm -blength 0
#[[ -n "$DISPLAY" ]] && wmctrl -i -a $(wmctrl -l | grep Terminal | tail -n 1 | cut -d ' ' -f1)


