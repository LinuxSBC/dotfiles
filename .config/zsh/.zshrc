# functions

init_linuxbrew() {
    export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
    export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
    export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
    fpath[1,0]="/home/linuxbrew/.linuxbrew/share/zsh/site-functions";
    export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
    [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}";
    [ -z "${XDG_DATA_DIRS-}" ] || export XDG_DATA_DIRS="/home/linuxbrew/.linuxbrew/share:${XDG_DATA_DIRS-}";
    . /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh
}







# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# move things to XDG dirs instead of ~
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
export WINEPREFIX="$XDG_DATA_HOME"/wine
mkdir -p "$XDG_STATE_HOME"/zsh && export HISTFILE="$XDG_STATE_HOME"/zsh/history
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
alias adb='HOME="$XDG_DATA_HOME"/android adb'
alias fastboot='HOME="$XDG_DATA_HOME"/android fastboot'
export ANDROID_HOME="$XDG_DATA_HOME"/android/sdk
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias svn="svn --config-dir $XDG_CONFIG_HOME/subversion"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
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
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/config

# PATH setting
typeset -U path
path=($path
    $HOME/.local/bin
    /opt/android-sdk/platform-tools /var/opt/android-sdk/platform-tools
    /var/lib/snapd/snap/bin
    ${CARGO_HOME:-$HOME/.cargo}/bin
    $HOME/.local/share/JetBrains/Toolbox/scripts
)
export PATH

# default is /usr/local/share:/usr/share, but we want to add a few others
export XDG_DATA_DIRS="/usr/local/share:/var/usrlocal/share:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$HOME/.nix-profile/share:$HOME/.share"

# other environment variables
export QT_STYLE_OVERRIDE=kvantum

# Add IBus support
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

export CALIBRE_USE_SYSTEM_THEME=1
export QT_QPA_PLATFORM=wayland

# Enable native Wayland on Firefox
export MOZ_ENABLE_WAYLAND=1

export EDITOR='nvim'


# Path to your oh-my-zsh installation.
export ZSH="${ZDOTDIR:-$HOME}/.oh-my-zsh"
export ZSH_CUSTOM="${ZDOTDIR:-$HOME}/.omz-custom"
ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="true"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"
ZVM_VI_HIGHLIGHT_BACKGROUND=#3B3F4C

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(python zsh-vi-mode zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)

bindkey -v

# Bind keys for zsh-history-substring-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey ^R history-incremental-search-backward 
bindkey ^S history-incremental-search-forward

bindkey '^[l' autosuggest-accept

source $ZSH/oh-my-zsh.sh

# Replace some more things with better alternatives
alias ls='eza --icons --group-directories-first --hyperlink --git-repos --header --git --group --binary'
alias la='ls -a' # all files and dirs
alias ll='ls -l' # long format
alias l.="ls -a | egrep '^\.'" # show only dotfiles

alias cat='bat --style header --style snip --style changes --style header'
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'
#alias paru='paru --bottomup --sudoloop --skipreview --needed'
#alias yay=paru

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ip='ip -c'
alias addr='ip -br -c a'

alias fd="fd -H"

alias phasmophobia='cd ~/.phasmophobia && /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.*/jre/bin/java -jar purpur-1.16.5-1171.jar'
alias modded='~/.modded-with-friends/start.sh'
#alias modded='cd ~/.modded-with-seams && java -Xmx4G -jar fabric-server-mc.1.18.2-loader.0.14.10-launcher.0.11.1.jar nogui'

function export-bin () {
    distrobox-export --bin `whence -p $1` --export-path $HOME/.local/bin
}


# Adding support for external programs
printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [ -d /home/linuxbrew ]; then
    init_linuxbrew
fi

eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$XDG_CONFIG_HOME"/zsh/.p10k.zsh ]] || source "$XDG_CONFIG_HOME"/zsh/.p10k.zsh
