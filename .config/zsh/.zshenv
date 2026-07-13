if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi
if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi
if [ -z "$XDG_STATE_HOME" ]; then
    export XDG_STATE_HOME="$HOME/.local/state"
fi

# default is /usr/local/share:/usr/share, but we want to add a few others
export XDG_DATA_DIRS="/usr/local/share:/var/usrlocal/share:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$HOME/.nix-profile/share:$HOME/.share"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

# move things to XDG dirs instead of ~
export WINEPREFIX="$XDG_DATA_HOME"/wine
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
alias adb='HOME="$XDG_DATA_HOME"/android adb'
alias fastboot='HOME="$XDG_DATA_HOME"/android fastboot'
export ANDROID_HOME="$XDG_DATA_HOME"/android/sdk
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias svn="svn --config-dir $XDG_CONFIG_HOME/subversion"
export KERAS_HOME="${XDG_STATE_HOME}/keras"
mkdir -p "$XDG_CONFIG_HOME"/python && touch "$XDG_STATE_HOME"/python_history
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc.py
cat <<EOF > $XDG_CONFIG_HOME/python/pythonrc.py
def is_vanilla() -> bool:
    import sys
    return not hasattr(__builtins__, '__IPYTHON__') and 'bpython' not in sys. 
argv[0]


def setup_history():
    import os
    import atexit
    import readline
    from pathlib import Path

    if state_home := os.environ.get('XDG_STATE_HOME'):
state_home = Path(state_home)
    else:
state_home = Path.home() / '.local' / 'state'

    history: Path = state_home / 'python_history'

    readline.read_history_file(str(history))
    atexit.register(readline.write_history_file, str(history))


if is_vanilla():
    setup_history()
EOF
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME"/platformio
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export CCACHE_DIR="$XDG_CACHE_HOME"/ccache
# export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/config


# PATH setting
typeset -U path
path=($path
    $HOME/.local/bin
    /opt/android-sdk/platform-tools /var/opt/android-sdk/platform-tools
    /var/lib/snapd/snap/bin /snap/bin
    ${CARGO_HOME:-$HOME/.cargo}/bin
    $HOME/.local/share/JetBrains/Toolbox/scripts
)
export PATH

for e in nvim vim vi nano; do
    if command -v "$e" >/dev/null 2>&1; then
        export EDITOR="$(command -v "$e")"
        break
    fi
done
