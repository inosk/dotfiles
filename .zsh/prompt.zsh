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

# envs
function tool-version-info() {
  local versions=""
  for n in $((ls -1 .*-version) 2>/dev/null); do
    local version=$(echo $(echo $n | sed "s/\.\(.*\)-version/\1/") $(cat $n));
    if [ -z $versions ]; then
      versions=$version
    else
      versions="$versions | $version"
    fi
  done
  echo $versions
  return
}

# aws_profile
function aws_profile_info() {
  if [ -n "$AWS_PROFILE" ]; then
    echo " $AWS_PROFILE"
  else
    echo ""
  fi
  return
}

# prompt_parts
function pp() {
  local content=$1
  local bgcolor=$2
  if [ -z "$content" ]; then
    echo ""
  else
    echo "%K{$bgcolor}%F{black} ${content} %f%k"
  fi
  return
}

# SEPERATOR='\uE0B0'

PATH_C=075
VCS_C=240
AWS_C=216
TOOLS_C=251

PROMPT='
$(pp %~ $PATH_C)$(pp ${vcs_info_msg_0_} $VCS_C)$(pp "$(aws_profile_info)" $AWS_C)$(pp "$(tool-version-info)" $TOOLS_C)
$(kube_ps1)
%(?.%B%F{green}.%B%F{blue})%(?!(๑>ᴗ<) < !(;^ω^%) < )%f%b'

RPROMPT='%D{%H:%M:%S}'
