export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "mollifier/anyframe"

# pluginのload
zplug load

# anyframe{{{
bindkey "^r" anyframe-widget-put-history
bindkey "^k" anyframe-widget-kill
# }}}
# zsh-comletions {{[
plugins=(… zsh-completions)
autoload -U compinit && compinit
# ]}}
# zsh-syntax-highlighting {{{
source $ZPLUG_REPOS/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# }}}
