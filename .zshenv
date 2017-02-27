case ${OSTYPE} in
  darwin*)
    setopt no_global_rcs
    ;;
  linux*)
    ;;
esac

typeset -U path PATH
export PATH=${HOME}/bin:${HOME}/.bin:/usr/local/bin:/usr/local/sbin:$PATH

# diff-highlight
export PATH=/usr/local/share/git-core/contrib/diff-highlight/:$PATH

# direnv
which direnv > /dev/null 2>&1
if [ $? = 0 ]; then
  eval "$(direnv hook zsh)"
fi

# anyenv
if [ -d $HOME/.anyenv ]; then
  export PATH=$HOME/.anyenv/bin:$PATH
  eval "$(anyenv init -)"
  for D in `ls $HOME/.anyenv/envs`
  do
    export PATH=$HOME/.anyenv/envs/$D/shims:$PATH
  done
fi

# go
export GOPATH=$HOME/.go

# rust
if [ -e ~/.cargo/env ]; then
  source ~/.cargo/env
fi

# 各サーバの個別設定
if [ -e ~/.zshenv_local ]; then
  source ~/.zshenv_local
fi
