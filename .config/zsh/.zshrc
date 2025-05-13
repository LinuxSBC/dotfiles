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

init_perl() {
    PATH="/var/home/bensimmons/perl5/bin${PATH:+:${PATH}}"; export PATH;
    PERL5LIB="/var/home/bensimmons/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
    PERL_LOCAL_LIB_ROOT="/var/home/bensimmons/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
    PERL_MB_OPT="--install_base \"/var/home/bensimmons/perl5\""; export PERL_MB_OPT;
    PERL_MM_OPT="INSTALL_BASE=/var/home/bensimmons/perl5"; export PERL_MM_OPT;
}







zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# PATH setting
typeset -U path
path=($path
    $HOME/.local/bin
    /opt/android-sdk/platform-tools /var/opt/android-sdk/platform-tools
    /var/lib/snapd/snap/bin
    $HOME/.cargo/bin
    $HOME/.local/share/JetBrains/Toolbox/scripts
)
export PATH

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

init_perl

[ -f /opt/miniforge/etc/profile.d/conda.sh ] && source /opt/miniforge/etc/profile.d/conda.sh

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

if [ -d /home/linuxbrew ]; then
    init_linuxbrew
fi

eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
