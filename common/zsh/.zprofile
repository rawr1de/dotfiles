if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec niri --session
fi

case "$(hostname)" in
    legion)  ssh-add ~/.ssh/id_legion  ;;
    templar) ssh-add ~/.ssh/id_templar ;;
esac
