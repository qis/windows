# Path
export PATH="/opt/cmake/bin:/opt/vcpkg:${PATH}"

# Files
umask 0022

# Limits
ulimit -S -c 0

# Unicode
export NCURSES_NO_UTF8_ACS="1"
export MM_CHARSET="UTF-8"

# Localization
export LANG="C.UTF-8"
export LC_MESSAGES="C.UTF-8"
export LC_COLLATE="C.UTF-8"
export LC_CTYPE="C.UTF-8"
export LC_ALL=

# Applications
export EDITOR="vim"
export PAGER="less"

# Ports
export VCPKG_ROOT="/opt/vcpkg"
export VCPKG_DOWNLOADS="/opt/downloads"
export VCPKG_DEFAULT_TRIPLET="x64-linux"

# Colors
export CLICOLOR=1
export LSCOLORS="ExGxFxdxCxDxDxBxAbBxFx"
export LS_COLORS="di=1;34:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=1;34"

# Aliases
alias ..="cd .."

alias ls="ls --color=auto --group-directories-first"
alias ll="ls -lh --time-style long-iso"
alias lsa="ls -A"
alias lla="ll -A"

alias tm="tmux -2"
alias ta="tm attach -t"
alias ts="tm new-session -s"
alias tl="tm list-sessions"

alias crush="pngcrush -brute -reduce -rem allb -ow"
alias grep="grep --color=auto"

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
