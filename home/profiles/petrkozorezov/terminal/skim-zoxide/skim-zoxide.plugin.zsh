# zoxide+skim integration (originally from https://github.com/wookayin/fzf-fasd/)
__skim_zoxide_zsh_completion() {
  local args cmd slug selected

  args=(${(z)LBUFFER})
  cmd=${args[1]}

  # triggered only at the command 'z'; fallback to default
  if [[ "$cmd" != "z" ]]; then
    zle ${__skim_zoxide_default_completion:-expand-or-complete}
    return
  fi

  if [[ "${#args}" -gt 1 ]]; then
    eval "slug=${args[-1]}"
  fi

  # generate completion list from zoxide
  local matches_count
  matches_count=$(__skim_zoxide_generate_matches "$slug" | head | wc -l)
  if [[ "$matches_count" -gt 1 ]]; then
    # >1 results, invoke skim
    selected=$(__skim_zoxide_generate_matches "$slug" | \
      sk --query="$slug" --reverse --bind 'shift-tab:up,tab:down' --height ${SKIM_TMUX_HEIGHT:-40%}
    )
  elif [[ "$matches_count" -eq 1 ]]; then
    # 1 result, just complete it
    selected=$(__skim_zoxide_generate_matches "$slug")
  else;
    # no result
    return
  fi
  #echo [DEBUG] $selected $matches_count

  # return completion result with $selected
  if [[ -n "$selected" ]]; then
    selected=$(printf %q "$selected")
    if [[ "$selected" != */ ]]; then
      selected="${selected}/"
    fi
    LBUFFER="$cmd $selected"
  fi

  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
}

__skim_zoxide_generate_matches() {
  zoxide query -l "$@"
}

[ -z "$__skim_zoxide_default_completion" ] && {
  binding=$(bindkey '^I')
  [[ $binding =~ 'undefined-key' ]] || __skim_zoxide_default_completion=$binding[(s: :w)2]
  unset binding
}

zle      -N  __skim_zoxide_zsh_completion
bindkey '^I' __skim_zoxide_zsh_completion
