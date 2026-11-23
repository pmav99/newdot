# Shared Bash/Zsh host classification. Recompute locally; do not trust an
# inherited value when entering another host. Only run hostname at shell startup.
case "$(hostname -f 2>/dev/null || hostname 2>/dev/null)" in
    meluxina.lxp.lu|*.meluxina.lxp.lu) export DOTFILES_POSH_HOST_LABEL=MELUXINA ;;
    *) export DOTFILES_POSH_HOST_LABEL='' ;;
esac
