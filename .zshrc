export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-shift-select)
source $ZSH/oh-my-zsh.sh

unsetopt autocd
setopt EXTENDED_HISTORY

PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%2~%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Desktop notification (via Ghostty) when a command takes longer than 5 seconds
preexec() { cmd_start_time=$SECONDS }
precmd() {
  if [ $cmd_start_time ]; then
    elapsed=$((SECONDS - cmd_start_time))
    [ $elapsed -gt 5 ] && echo -e "\033]777;notify;Command Complete;Finished in ${elapsed}s\007"
    unset cmd_start_time
  fi
}

[ -f "$HOME/dotfiles/aliases.zsh" ] && source "$HOME/dotfiles/aliases.zsh"
