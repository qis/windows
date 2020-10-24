if [ -x "/bin/wslpath" ] && [ -f "/mnt/c/Windows/System32/cmd.exe" ]; then
  export CMD="/mnt/c/Windows/System32/cmd.exe"
  USERPROFILE="$(/bin/wslpath -a $(${CMD} /C 'echo %UserProfile%' 2>/dev/null | sed 's/\r//g') 2>/dev/null)" \
    && export USERPROFILE
fi

alias crush="pngcrush -brute -reduce -rem allb -ow"
