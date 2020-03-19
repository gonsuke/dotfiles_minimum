# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

bindkey -e

function copy-region() {
    zle copy-region-as-kill
    REGION_ACTIVE=0
}
zle -N copy-region
bindkey "^[w" copy-region

function backward-kill-word-or-region() {
    if [ $REGION_ACTIVE -eq 0 ]; then
        zle backward-kill-word
    else
        zle kill-region
    fi
}
zle -N backward-kill-word-or-region
bindkey "^w" backward-kill-word-or-region

ulimit -c 0
ulimit -n 8192

export LANG=ja_JP.UTF-8
export WORDCHARS='*?_[]~=&;!#$%^(){}<>'
export LESS=' -R'
export LESSCHARSET=utf-8
export LESSOPEN='| src-hilite-lesspipe.sh %s'
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 30% --border'

if [ `uname` = "Darwin" ]; then
    export PATH=$HOME/bin:/opt/local/bin:/opt/local/sbin:/opt/local/lib/mysql57/bin:/opt/local/Library/Frameworks/Python.framework/Versions/3.7/bin:$PATH
    export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home`
fi
export PATH=${JAVA_HOME}/bin:${PATH}
export PATH=$PATH:$HOME/go/bin:$HOME/.rvm/bin:$HOME/.nodebrew/current/bin:$HOME/.npm-global/bin:$HOME/.cargo/bin

pscount=`ps aux | grep "ssh-agent" | grep -v grep | wc -l`
if [ $pscount = 0 ]; then
    eval `ssh-agent`
    for key in `ls ~/.ssh/*.pem`; do
        ssh-add "${key}"
    done
fi

# Enable direnv
eval "$(direnv hook zsh)"

# Path to autoload functions
fpath=(~/.zfunc $fpath)
fpath=(~/.git_completion $fpath)
#fpath=(~/.zsh.d/anyframe(N-/) $fpath)

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# Enable zsh completion
autoload -U compinit; compinit -u

# Opptions see zshoptions(1)
setopt correct
setopt correct_all
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt extended_glob
setopt no_beep
setopt no_list_beep
setopt list_packed
setopt auto_name_dirs
setopt auto_remove_slash
setopt sun_keyboard_hack
setopt list_types
setopt always_last_prompt
setopt sh_word_split
setopt extended_history
setopt no_flow_control
setopt share_history
setopt notify

# Menu driven completion
zstyle ':completion:*:default' menu select=1
# Use cache
zstyle ':completion:*' use-cache true
# Ignore patterns
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
# Color
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Ignore pwd and parent for cd
zstyle ':completion:*:cd:*' ignore-parents parent pwd
# Case-insensitive for matching 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Peco select history
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# cdr
autoload -Uz is-at-least
if is-at-least 4.3.11; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*'      recent-dirs-max 1000
    zstyle ':chpwd:*'      recent-dirs-default yes
    zstyle ':completion:*' recent-dirs-insert both
fi

# ls colors
if [ `uname` = "FreeBSD" ]; then
    alias ls='ls -GF'
    alias ll='ls -alGF'
elif [ `uname` = "Darwin" ]; then
    alias ls='ls -GF'
    alias ll='ls -alGF'
else
    alias ls='ls -F --color=auto'
    alias ll='ls -alF --color=auto'
fi

alias lv='less'
alias nv='nvim'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias kx='kubectx'
alias kl='kubectl'

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

# Two regular plugins loaded without tracking.
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

# Plugin history-search-multi-word loaded with tracking.
zinit load zdharma/history-search-multi-word

# Load the pure theme, with zsh-async library that's bundled with it.
#zinit ice pick"async.zsh" src"pure.zsh"
#zinit light sindresorhus/pure

# A glance at the new for-syntax – load all of the above
# plugins with a single command. For more information see:
# https://zdharma.org/zinit/wiki/For-Syntax/
#zinit for \
#    light-mode  zsh-users/zsh-autosuggestions \
#    light-mode  zdharma/fast-syntax-highlighting \
#                zdharma/history-search-multi-word \
#    pick"async.zsh" src"pure.zsh" \
#                sindresorhus/pure

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin

# One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
# This is done by ice-mod `mv'{from} -> {to}'. There are multiple packages per
# single version, for OS X, Linux and Windows – so ice-mod `bpick' is used to
# select Linux package – in this case this is actually not needed, Zinit will
# grep operating system name and architecture automatically when there's no `bpick'.
zinit ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"
zinit load docker/compose

# Vim repository on GitHub – a typical source code that needs compilation – Zinit
# can manage it for you if you like, run `./configure` and other `make`, etc. stuff.
# Ice-mod `pick` selects a binary program to add to $PATH. You could also install the
# package under the path $ZPFX, see: http://zdharma.org/zinit/wiki/Compiling-programs
zinit ice as"program" atclone"rm -f src/auto/config.cache; ./configure" \
    atpull"%atclone" make pick"src/vim"
zinit light vim/vim

# Scripts that are built at install (there's single default make target, "install",
# and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only, default target.
zinit ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zinit light tj/git-extras

# Handle completions without loading any plugin, see "clist" command.
# This one is to be ran just once, in interactive session.
zinit creinstall %HOME/my_completions

zplugin ice depth=1; zplugin light romkatv/powerlevel10k

if [ -f /opt/local/bin/virtualenvwrapper.sh-3.6 ]; then
    export VIRTUALENVWRAPPER_PYTHON='/opt/local/bin/python3.6'
    export VIRTUALENVWRAPPER_VIRTUALENV='/opt/local/bin/virtualenv-3.6'
    export VIRTUALENVWRAPPER_VIRTUALENV_CLONE='/opt/local/bin/virtualenv-clone-3.6'
    export WORKON_HOME=$HOME/.virtualenvs
    source /opt/local/bin/virtualenvwrapper.sh-3.6
elif [ -f /bin/virtualenvwrapper.sh ]; then
    export VIRTUALENVWRAPPER_PYTHON='/bin/python'
    export VIRTUALENVWRAPPER_VIRTUALENV='/bin/virtualenv'
    export VIRTUALENVWRAPPER_VIRTUALENV_CLONE='/bin/virtualenv-clone'
    export WORKON_HOME=$HOME/.virtualenvs
    source /bin/virtualenvwrapper.sh
fi

# RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

# For gcloud cli with apt packages
if [ -f /usr/share/google-cloud-sdk/completion.zsh.inc ]; then
    export PATH=$PATH:/usr/lib/google-cloud-sdk/bin
    . /usr/share/google-cloud-sdk/completion.zsh.inc
fi

# tabtab source for packages
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

# Flutter
[[ -d ~/Downloads/flutter ]] && export PATH=$PATH:~/Downloads/flutter/bin

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

