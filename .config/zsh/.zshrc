# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
}



# Add IBus support
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

export CALIBRE_USE_SYSTEM_THEME=1
export QT_QPA_PLATFORM=wayland

# Actions to take if we're in WSL
if [ -f /bin/wslpath ]; then
    export BROWSER=wslview
fi


# Path to your oh-my-zsh installation.
export ZSH="${ZDOTDIR:-$HOME}/.oh-my-zsh"
export ZSH_CUSTOM="${ZDOTDIR:-$HOME}/.omz-custom"
ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="false"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"
ZVM_VI_HIGHLIGHT_BACKGROUND=#3B3F4C

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(python zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)

# bindkey -v

# Bind keys for zsh-history-substring-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey ^R history-incremental-search-backward 
bindkey ^S history-incremental-search-forward

bindkey '^[l' autosuggest-accept

source $ZSH/oh-my-zsh.sh

mkdir -p "$XDG_STATE_HOME"/zsh && export HISTFILE="$XDG_STATE_HOME"/zsh/history

# Replace some more things with better alternatives
alias ls='eza --icons=auto --group-directories-first --hyperlink=auto --git-repos --header --git --group --binary'
alias la='ls -a' # all files and dirs
alias ll='ls -l' # long format
alias lla='ls -la' # long format with hidden files
alias l.="ls -a | egrep '^\.'" # show only dotfiles

alias cd='z'

alias cat='bat --style header --style snip --style changes --style header'

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ip='ip -c'
alias addr='ip -br -c a'

alias fd="fd -H"

function hyfetch() {
    cmd=$(whence -p hyfetch)
    distro=$(cat /etc/os-release | grep '^ID=' | cut -d= -f2 | tr -d '"')
    if [ "$distro" = "bluefin" ]; then
        $cmd --distro fedora
    else
        $cmd
    fi
}

function run-arch() {
    # check if it's in distrobox
    if [ -z "${DISTROBOX_ENTER_PATH}" ]; then
        /usr/bin/distrobox-enter -n arch -- "$@"
    else
        "$@"
    fi
}

function export-bin() {
    distrobox-export --bin `whence -p $1` --export-path $HOME/.local/bin
}


# Adding support for external programs
printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "zsh" }}\x9c'

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [ -d /home/linuxbrew ]; then
    init_linuxbrew
fi

eval "$(zoxide init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Code/iDoc/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Code/iDoc/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Code/iDoc/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Code/iDoc/google-cloud-sdk/completion.zsh.inc"; fi

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# iDoc environment switcher (idoc-dev / idoc-prod / idoc-unset)
[[ -f "$HOME/Code/iDoc/idoc-env.zsh" ]] && source "$HOME/Code/iDoc/idoc-env.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "$XDG_CONFIG_HOME"/zsh/.p10k.zsh ]] || source "$XDG_CONFIG_HOME"/zsh/.p10k.zsh
