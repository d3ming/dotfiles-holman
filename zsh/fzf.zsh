# fzf setup
# Requires: brew install fzf
# Sets up keybindings, completion, and custom @ file-picker trigger

# Initialize fzf shell integration (CTRL-T, CTRL-R, ALT-C)
eval "$(fzf --zsh)"

# Default fzf options
export FZF_DEFAULT_OPTS="--height 40% --reverse --border"

# Use fd if available (faster, respects .gitignore), fallback to find
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
else
  export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/.git/*'"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# @ trigger: opens fzf file picker and expands path in-place
# Only triggers at word boundaries (start of line or after space/=)
# Inserts @ normally in all other contexts (e.g. HEAD@{1}, emails)
_fzf_at_file_trigger() {
  local last_char="${LBUFFER[-1]}"

  if [[ -z "$LBUFFER" || "$last_char" == " " || "$last_char" == "=" || "$last_char" == "'" || "$last_char" == '"' ]]; then
    local file
    file=$(fd --type f --hidden --follow --exclude .git 2>/dev/null \
      | fzf --height 40% --reverse --border \
          --preview 'cat {} 2>/dev/null || echo "(binary or unreadable)"' \
          --preview-window=right:50%:wrap)

    if [[ -n "$file" ]]; then
      LBUFFER="${LBUFFER}${file}"
    fi
  else
    LBUFFER="${LBUFFER}@"
  fi

  zle reset-prompt
}

zle -N _fzf_at_file_trigger
bindkey '@' _fzf_at_file_trigger
