# vim: foldmethod=marker
# vim: foldcolumn=3
# vim: foldlevel=0

#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

### Added by Zinit's installer {{{
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk }}}
# plugins {{{
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light mollifier/anyframe
zinit light jonmosco/kube-ps1
# }}}

# lang
export LANG=ja_JP.utf-8

# keep background processes at full speed
setopt NOBGNICE

## restart running processes on exit
#setopt HUP

# zsh version info
autoload -Uz is-at-least

# zmv
autoload -Uz zmv

## never ever beep ever
setopt NO_BEEP

autoload -U colors && colors
export TERM=xterm-256color

bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# correct wrong command
setopt correct

# slim list
setopt list_packed

# jobsの出力デフォルトをjobs -lにする
setopt long_list_jobs

# less のデフォルトオプション
export LESS='-i -X -R -F'

# kill terminal lock
stty stop undef

# completions {{{
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit && compinit

zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' keep-prefix
zstyle ':completion:*:default' list-colors ''
zstyle ':completion:*' verbose yes
setopt list_types
setopt magic_equal_subst
setopt auto_menu
setopt complete_in_word #allow tab completion in the middle of a word
setopt extended_glob
setopt interactivecomments # enable comment in console

# 履歴の前方一致検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
# }}}
# history {{{
HISTFILE=~/.zsh_history
HISTSIZE=500000
SAVEHIST=500000
DIRSTACKSIZE=100
setopt hist_ignore_all_dups # 重複があれば古いものを消す
setopt hist_expire_dups_first
setopt hist_reduce_blanks # 余計な空白を詰める
setopt extended_history
setopt inc_append_history
setopt share_history # ヒストリの共有
# }}}
# auto_pushd {{{
DIRSTACKSIZE=100 # cdの履歴サイズ
setopt auto_pushd # cdの履歴を残す
setopt pushd_ignore_dups # 履歴の重複を無視
# }}}
# prompt {{{
setopt prompt_subst # コマンドの実行結果とかをpromptに使いたい時に指定

# vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*'     formats "%F{green}%c%u%b%f"
zstyle ':vcs_info:*' actionformats '%F{green}%b%f(%F{red}%a%f)'
#zstyle ':vcs_info:*'     actionformats '[%b|%a]'
precmd () { vcs_info }

# 配色
PROMPT_BACKGROUD_COLOR=
PATH_COLOR='yellow'
SEPERATOR='❘'
SEPERATOR_COLOR=244
SEPERATOR_INFO="%F{$SEPERATOR_COLOR} ${SEPERATOR} %f"
PATH_INFO="%F{$PATH_COLOR}%~%f"

AWS_PROFILE_INFO=$([ -n $AWS_PROFILE ] && echo " $AWS_PROFILE" )
PROMPT='
%K{$PROMPT_BACKGROUD_COLOR}${PATH_INFO} ${vcs_info_msg_0_}%k
$AWS_PROFILE_INFO $(kube_ps1)
%(?.%B%F{green}.%B%F{blue})%(?!(๑>ᴗ<) < !(;^ω^%) < )%f%b'

RPROMPT='%D{%H:%M:%S}'
# }}}
# alias {{{
case ${OSTYPE} in
  darwin*)
    alias ll='ls -lG'
    alias lla='ls -laG'
    alias el='exa -gHl --git'
    ;;
  linux*)
    alias ll='ls -l --color=tty'
    alias lla='ls -la --color=tty'
    ;;
esac

if [ -e /usr/local/bin/vim ]; then
  alias vi='/usr/local/bin/vim'
  export EDITOR=/usr/local/bin/vim
else
  alias vi='vim'
  export EDITOR=vim
fi

alias grep='grep --color=auto'
alias rmrf='rm -rf'
#alias ctags='ctags -f .tags'

if which gtags > /dev/null 2>&1; then
  alias gtags="gtags --gtagslabel=pygments"
fi
# }}}
# auto ls {{{
# cd するたびにllをたたく.ただし50個以上項目がある場合は個数の表示にとどめる
function chpwd() {
  if [ $(ls -l | wc -l) -le 50 ]; then
    case ${OSTYPE} in
      darwin*); ls -Gl;;
      linux*);  ls -l --color=tty;;
    esac
  else
    echo "$(ls -l | wc -l) items exist in `pwd`"
  fi
}
# }}}
# include {{{
if [ -e ~/.zsh/ghq.zsh ]; then
  source ~/.zsh/ghq.zsh
fi

if [ -e ~/.zsh/git-completion.bash ]; then
  source ~/.zsh/git-completion.bash
fi

if [ -e ~/.zsh/complete-ec2-host-ip.zsh ]; then
  source ~/.zsh/complete-ec2-host-ip.zsh
fi

if [ -e ~/.zsh/peco-git-branches.zsh ]; then
  source ~/.zsh/peco-git-branches.zsh
fi

if [ -e ~/.zsh/fzf-file-find.zsh ]; then
  source ~/.zsh/fzf-file-find.zsh
fi

if [ -e ~/.zshrc_local ]; then
  source ~/.zshrc_local
fi
# }}}
# anyframe{{{
bindkey "^r" anyframe-widget-put-history
bindkey "^k" anyframe-widget-kill
# }}}
# zsh-comletions {{{
fpath=($HOME/.zinit/plugins/zsh-users---zsh-completions/src $fpath)
autoload -Uz compinit && compinit
# }}}
# zsh-syntax-highlighting {{{
source $HOME/.zinit/plugins/zsh-users---zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# }}}
