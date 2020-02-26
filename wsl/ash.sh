# Path
export PATH="/opt/cmake/bin:/opt/node/bin:/opt/vcpkg:${PATH}"

# Files
umask 0022

# Limits
ulimit -S -c 0

# Unicode
export NCURSES_NO_UTF8_ACS="1"

# Localization
export LANG="en_US.${CHARSET}"
export LC_MESSAGES="en_US.${CHARSET}"
export LC_CTYPE="en_US.${CHARSET}"
export LC_COLLATE="C"
export LC_ALL=

# Applications
export NODE_PATH="/opt/node/lib/node_modules"
export EDITOR="$(which nvim vim vi 2>/dev/null | head -1)"
export PAGER="less"

# Ports
export VCPKG_ROOT="/opt/vcpkg"
export VCPKG_DOWNLOADS="/opt/downloads"
export VCPKG_DEFAULT_TRIPLET="x64-linux"

# Aliases
alias ..="cd .."

alias ls="ls --group-directories-first"
alias ll="ls -lh --full-time"
alias lsa="ls -A"
alias lla="ll -A"

alias vim="${EDITOR} -p"
alias vimdiff="${EDITOR} -d"
alias crush="pngcrush -brute -reduce -rem allb -ow"

alias tm="tmux -2"
alias ta="tm attach -t"
alias ts="tm new-session -s"
alias tl="tm list-sessions"

# Settings
export HISTFILE="${HOME}/.history"

PS1=
if [ -n "${TMUX}" ]; then
  id="$(echo $TMUX | awk -F, '{print $3 + 1}')"
  session="$(tmux ls | head -${id} | tail -1 | cut -d: -f1)"
  PS1="${PS1}\[\e[90m\][\[\e[0m\]${session}\[\e[90m\]]\[\e[0m\] "
fi
if [ $(id -u) -ne 0 ]; then
  PS1="${PS1}\[\e[32m\]\u\[\e[0m\]"
else
  PS1="${PS1}\[\e[31m\]\u\[\e[0m\]"
fi
PS1="${PS1}@\[\e[32m\]\h\[\e[0m\]"
PS1="${PS1} \[\e[34m\]\w\[\e[0m\] "
export PS1

stty werase '^_'

# WSL
if [ -n "$(uname -r | grep Microsoft)" ]; then
  if [ "$(pwd | cut -d/ -f1-4)" = "/mnt/c/Workspace" ]; then
    cd "${HOME}/workspace/$(pwd | cut -d/ -f5-)"
  elif [ "$(pwd | cut -d/ -f1-6)" = "/mnt/c/Users/Qis/Documents" ]; then
    cd "${HOME}/documents/$(pwd | cut -d/ -f7-)"
  elif [ "$(pwd | cut -d/ -f1-6)" = "/mnt/c/Users/Qis/Downloads" ]; then
    cd "${HOME}/downloads/$(pwd | cut -d/ -f7-)"
  fi
fi
