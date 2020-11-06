case ${OSTYPE} in
  darwin*)
    setopt no_global_rcs
    ;;
  linux*)
    ;;
esac

typeset -U path PATH
export PATH=${HOME}/bin:${HOME}/.bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:$PATH

# diff-highlight
export PATH=/usr/local/share/git-core/contrib/diff-highlight/:$PATH

# npm -g
export PATH=${HOME}/node_modules/.bin:$PATH

# krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# direnv
which direnv > /dev/null 2>&1
if [ $? = 0 ]; then
  eval "$(direnv hook zsh)"
fi

# adfs
. $(brew --prefix asdf)/asdf.sh
. ${HOME}/.asdf/plugins/java/set-java-home.zsh

# go
which go > /dev/null 2>&1
if [ $? = 0 ]; then
  export GOPATH=${HOME}/program/go
  export PATH=${GOPATH}/bin:$PATH
fi

# rust
if [ -e ~/.cargo/env ]; then
  source ~/.cargo/env
fi

# 各サーバの個別設定
if [ -e ~/.zshenv_local ]; then
  source ~/.zshenv_local
fi
