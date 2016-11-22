############################# BASH HAX ###########################################################
#Color Mod
export PS1="\[\033[33;10m\]\w\[\033[m\]:🐨  "
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
alias ls='ls -GFh'

alias sourcebash='source ~/.bash_profile'
alias mybash='sublime ~/.bash_profile'

############################### Custom git functions #############################################
function git_add_first_unstaged_file() {
    if [[ $(git diff --name-only) ]]; then
        FILE_NAME=$(git diff --name-only | sed -n "1 p")
        printf "%s has been added.\n" "$FILE_NAME"
        git add $FILE_NAME
    else
      echo "There are currently no unstaged changes."
    fi
}
alias gaf='git_add_first_unstaged_file'

function git_diff_first_unstaged_file() {
    if [[ $(git diff --name-only) ]]; then
      git diff $(git diff --name-only | sed -n '1 p')
    else
      echo "There are currently no unstaged changes."
    fi
}
alias gdf='git_diff_first_unstaged_file'