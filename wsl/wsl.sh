if [ -x "/bin/wslpath" ] && [ -f "/mnt/c/Windows/System32/cmd.exe" ]; then
  export CMD="/mnt/c/Windows/System32/cmd.exe"
  USERPROFILE="$(/bin/wslpath -a $(${CMD} /C 'echo %UserProfile%' 2>/dev/null | sed 's/\r//g') 2>/dev/null)" \
    && export USERPROFILE
fi

alias crush="pngcrush -brute -reduce -rem allb -ow"

md() {
  if [ -z "$(which generate-md)" ]; then
    echo "error: missing generate-md application"
    echo ""
    echo "installation instructions:"
    echo ""
    echo "  sudo npm install -g markdown-styles"
    echo ""
    exit 1
  fi
  if [ -z "${1}" ]; then
    echo "error: missing input file"
    exit 1
  fi
  if [ -z "${2}" ]; then
    echo "error: missing output file"
    exit 1
  fi
  generate-md --layout jasonm23-swiss --input "${1}" --output "${2}"
}
