#
# Maintains a frequently used file and directory list for fast access.
#
# Authors:
#   Wei Dai <x@wei23.net>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Load dependencies.
pmodload 'editor'

# If the command doesn't exist externally, we need to fall back to the bundled
# submodule.
if (( ! $+commands[fasd] )); then
  source "${0:h}/external/fasd" || return 1
fi

#
# Initialization
#

cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/prezto/fasd-cache.zsh"
if [[ "${commands[fasd]}" -nt "$cache_file" \
      || "${ZDOTDIR:-$HOME}/.zpreztorc" -nt "$cache_file" \
      || ! -s "$cache_file"  ]]; then
  # Set the base init arguments.
  init_args=(zsh-hook)

  # Set fasd completion init arguments, if applicable.
  if zstyle -t ':prezto:module:completion' loaded; then
    init_args+=(zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)
  fi

  mkdir -p "$cache_file:h"
  # Cache init code.
  fasd --init "$init_args[@]" >! "$cache_file" 2> /dev/null
fi

source "$cache_file"

unset cache_file init_args

function fasd_cd {
  local fasd_ret="$(fasd -d "$@")"
  if [[ -d "$fasd_ret" ]]; then
    cd "$fasd_ret"
  else
    print "$fasd_ret"
  fi
}

#
# Aliases
#

if ! zstyle -t ':prezto:module:fasd:alias' skip; then
  # Changes the current working directory interactively.
  alias j='fasd_cd -i'
  # Changes the current working directory interactively.
  alias a='fasd -a'        # any
  alias s='fasd -si'       # show / search / select
  alias d='fasd -d'        # directory
  alias f='fasd -f'        # file
  alias sd='fasd -sid'     # interactive directory selection
  alias sf='fasd -sif'     # interactive file selection
  alias z='fasd_cd -d'     # cd, same functionality as j in autojump
  alias zz='fasd_cd -d -i' # cd with interactive selection

  alias j='fasd_cd -i'
  alias v='f -e vim' # quick opening files with vim
  alias m='f -e mplayer' # quick opening files with mplayer
  alias o='fasd -ae "gio open"' # quick opening files with xdg-open
fi
