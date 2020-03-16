function fzf-file-find() {
  local file
  file=$(find ${1:-.} -path '*/\.*' -prune -o -type f -print 2> /dev/null | fzf +m)
  BUFFER+="$file"
  zle clear-screen
}

zle -N fzf-file-find
bindkey '^e' fzf-file-find

