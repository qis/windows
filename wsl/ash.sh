# Path
export PATH="/opt/cmake/bin:/opt/llvm/bin:/opt/vcpkg:${PATH}"

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

alias tm="tmux -2"
alias ta="tm attach -t"
alias ts="tm new-session -s"
alias tl="tm list-sessions"

alias crush="pngcrush -brute -reduce -rem allb -ow"

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

if [ -x "/bin/wslpath" ] && [ -f "/mnt/c/Windows/System32/cmd.exe" ]; then
  export CMD="/mnt/c/Windows/System32/cmd.exe"
  export USER_PROFILE="$(/bin/wslpath -a $(${CMD} /C 'echo %UserProfile%' 2>/dev/null | sed 's/\r//g'))"
fi
