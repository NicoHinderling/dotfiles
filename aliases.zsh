alias c='code'
alias szsh='source ~/.zshrc'
alias myzsh='c ~/.zshrc'
alias coffee='caffeinate'

alias 1l='git log --oneline'
alias hodl='ga .; gcmsg "hodl" --no-verify'
alias unhodl='git reset HEAD^'
alias amend='ga .; git commit --amend --no-edit'
alias stash='git stash'
alias pop='git stash pop'
alias cont='git rebase --continue'
alias p='git pull'
alias b="git branch --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'"

branchtinder() {
  local branches=() to_delete=()
  while IFS= read -r branch; do
    branches+=("$branch")
  done < <(git branch --format='%(refname:short)' | grep -vE '^(main|master)$')

  if [[ ${#branches[@]} -eq 0 ]]; then
    echo "No branches to review!"; return 0
  fi

  echo "🔥 Git Tinder — ${#branches[@]} branches to review"
  echo "============="
  echo ""
  echo "Say y to mark for deletion, n to keep."
  echo ""
  printf "Are you ready? (y/n): "
  read -rk1 ready
  echo ""
  [[ "$ready" != [yY] ]] && echo "Maybe next time." && return 0
  echo ""

  local i=1 total=${#branches[@]}
  for branch in "${branches[@]}"; do
    local last_commit=$(git log -1 --format='%cr - %s' "$branch" -- 2>/dev/null)
    echo "[$i/$total] $branch"
    [[ -n "$last_commit" ]] && echo "  $last_commit"
    printf "  Delete? (y/n): "
    read -rk1 answer
    echo ""
    [[ "$answer" == [yY] ]] && to_delete+=("$branch")
    echo ""
    ((i++))
  done

  if [[ ${#to_delete[@]} -eq 0 ]]; then
    echo "No branches marked for deletion."; return 0
  fi

  echo "🗑  Will delete:"
  for branch in "${to_delete[@]}"; do echo "  - $branch"; done
  echo ""
  printf "Confirm? (y/n): "
  read -rk1 confirm
  echo ""
  if [[ "$confirm" == [yY] ]]; then
    for branch in "${to_delete[@]}"; do git branch -D "$branch"; done
    echo "✅ Deleted ${#to_delete[@]} branch(es)."
  else
    echo "Cancelled."
  fi
}

del-old() {
  local target_branch="${1:-}"

  if [[ -z "$target_branch" ]]; then
    if git show-ref --verify --quiet "refs/heads/main"; then
      target_branch="main"
    elif git show-ref --verify --quiet "refs/heads/master"; then
      target_branch="master"
    else
      echo "fatal: neither 'main' nor 'master' branch found" >&2
      return 1
    fi
  fi

  if ! git show-ref --verify --quiet "refs/heads/$target_branch"; then
    echo "fatal: no branch named '$target_branch' found in this repo" >&2
    return 1
  fi

  local dominated=()

  for branch in $(git for-each-ref refs/heads/ --format='%(refname:short)'); do
    local ancestor=$(git merge-base "$target_branch" "$branch" 2>/dev/null)
    local tree=$(git rev-parse "${branch}^{tree}" 2>/dev/null)

    if [[ -n "$ancestor" && -n "$tree" ]]; then
      local dangling=$(git commit-tree "$tree" -p "$ancestor" -m "Temp commit for $branch")
      local cherry=$(git cherry "$target_branch" "$dangling" 2>/dev/null)

      if [[ "$cherry" == -* ]]; then
        dominated+=("$branch")
      fi
    fi
  done

  if [[ ${#dominated[@]} -gt 0 ]]; then
    git checkout "$target_branch"
    for branch in "${dominated[@]}"; do
      git branch -D "$branch"
    done
  fi
}

alias delold='del-old'

ship() {
    ga .; gcmsg "$1"; git push
}
backup() {
    current_branch=$(git rev-parse --abbrev-ref HEAD) && git branch -D "${current_branch}_backup" 2>/dev/null || true && git checkout -b "${current_branch}_backup" && git checkout "$current_branch"
}
finddir() {
    find . -type d -name "$1" -prune
}

findfile() {
    find . -type f -name "$1"
}

cpwd() {
    pwd | tr -d '\n' | pbcopy
}

trash() {
  for file in "$@"; do
    /usr/bin/osascript -e "tell application \"Finder\" to delete POSIX file \"$(realpath "$file")\"" >/dev/null
  done
}

h() {
  local count=${1:-40}

  local total_entries=$(grep -c '^: [0-9]*:' ~/.zsh_history 2>/dev/null || echo 0)

  grep -E '^: [0-9]+:' ~/.zsh_history | tail -n "$count" | tail -r | while IFS= read -r line; do
    timestamp=$(echo "$line" | sed -E 's/^: ([0-9]+):[0-9]+;.*/\1/')
    command=$(echo "$line" | sed -E 's/^: [0-9]+:[0-9]+;//')
    formatted_date=$(date -r "$timestamp" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "Invalid")

    printf "%4d  %s  %s\n" "$total_entries" "$formatted_date" "$command"
    ((total_entries--))
  done
}

newrbm() {
    local target=""

    if git show-ref --verify --quiet refs/remotes/origin/main || git show-ref --verify --quiet refs/heads/main; then
        target="main"
    elif git show-ref --verify --quiet refs/remotes/origin/master || git show-ref --verify --quiet refs/heads/master; then
        target="master"
    else
        echo "No main or master branch found"
        return 1
    fi

    echo "Fetching latest $target from origin and rebasing..."
    git fetch origin "$target" && git rebase "origin/$target"
}

rbm() {
    if git show-ref --verify --quiet refs/heads/main; then
        git checkout main && git pull && git checkout - && git rebase main
    elif git show-ref --verify --quiet refs/heads/master; then
        git checkout master && git pull && git checkout - && git rebase master
    else
        echo "No main or master branch found"
        return 1
    fi
}

m() {
    if git show-ref --verify --quiet refs/heads/main; then
        git checkout main
    elif git show-ref --verify --quiet refs/heads/master; then
        git checkout master
    else
        echo "No main or master branch found"
        return 1
    fi
}
