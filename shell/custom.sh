#!/bin/bash /bin/zsh

##########################################################
# conventions
##########################################################

# uppercase for global variables
# lowercase for local variables

##########################################################
# basic settings
##########################################################

# default editor, can be changed by function `ched()`
export EDITOR='code'
# terminal editor
export EDITOR_T='vi'

##########################################################
# select ox-plugins
##########################################################

# oxpg: ox-git
# oxpc: ox-conda
# oxpcn: ox-conan
# oxphx: ox-helix
# oxpjl: ox-julia
# oxpnj: ox-nodejs
# oxprs: ox-rust
# oxpzj: ox-zellij
# oxpbw: ox-bitwarden
# oxpct: ox-container
# oxpes: ox-espanso
# oxpjn: ox-jupyter
# oxptl: ox-texlive
# oxpvs: ox-vscode
# oxpfm: ox-format
# oxpwr: ox-weather
# oxpwr: ox-notes

OX_PLUGINS=(
    oxpc
    oxpes
    oxpfm
    oxpg
    oxpjn
    oxprs
    oxpvs
    oxpwr
)

##########################################################
# select software configuration objects
##########################################################

# options: brew, conda, vscode, julia, texlive, node
declare -a OX_UPDATE_PROG
export OX_UPDATE_PROG=(brew)

declare -a OX_BACKUP_PROG
export OX_BACKUP_PROG=(brew)

# backup file path
export OX_BACKUP=${HOME}/Documents/backup

# shell backups
OX_OXIDE[bkox]=${OX_BACKUP}/shell/custom.sh
# OX_OXIDE[bkvi]=${OX_BACKUP}/shell/.vimrc
# OX_OXIDE[bkpx]=${OX_BACKUP}/verge.yaml

# system file
OX_ELEMENT[wz]=${HOME}/.config/wezterm/wezterm.lua
# OX_ELEMENT[al]=${HOME}/.config/alacritty/alacritty.yml

# terminal
OX_OXIDE[bkwz]=${OX_BACKUP}/terminal/wezterm.lua
# OX_OXIDE[bkal]=${OX_BACKUP}/terminal/alacritty.yml

##########################################################
# register proxy ports
##########################################################

# c: clash, v: v2ray
declare -A OX_PROXY=(
    [c]=7890
    [v]=1080
)

OX_ELEMENT[cv]="${HOME}/.config/clash-verge/verge.yaml"
OX_OXIDE[bkcv]="${OX_BACKUP}/app/verge.yaml"

##########################################################
# select export and import settings
##########################################################

# files to be exported to backup folder
# ox: custom.sh of Oxidizer
# rs: cargo's env
# pu: pueue's config.yml
# pua: pueue's aliases.yml
# jl: julia's startup.jl
# vs: vscode's settings.json
# vsk: vscode's keybindings.json
# vss_: vscode's snippets folder
declare -a OX_EXPORT_FILE
export OX_EXPORT_FILE=(ox)

# files to be import from backup folder
declare -a OX_IMPORT_FILE
export OX_IMPORT_FILE=(ox)

##########################################################
# git settings
##########################################################

# backup files
OX_OXIDE[bkg]=${OX_BACKUP}/.gitconfig
# OX_OXIDE[bkgi]=${OX_BACKUP}/git/.gitignore

##########################################################
# brew settings
##########################################################

export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_CLEANUP_MAX_AGE_DAYS="7"

# brew mirrors for faster download, use `bmr` to use
# declare -A HOMEBREW_MIRROR=(
#     [ts]="mirrors.tuna.tsinghua.edu.cn/git/homebrew"
#     [zk]="mirrors.ustc.edu.cn/git/homebrew"
# )

# predefined brew services
# set the length of key <= 3
declare -A HOMEBREW_SERVICE=(
    [pu]="pueue"
    [pg]="postgresql@15"
    [pd]="podman"
)

##########################################################
# pueue settings
##########################################################

# pueue demo
upp() {
    pueue group add up_all
    pueue parallel 3 -g up_all
    pueue add -g up_all 'brew update && brew upgrade'
    pueue add -g up_all 'conda update --all --yes'
    # or use predefined items in pueue_aliase
    # pueue add -g up_all 'cup'
}

##########################################################
# conda settings
##########################################################

# # predefined conda environments
# # set the length of key <= 3
declare -A OX_CONDA_ENV=(
    [b]="base"
    [m]="music"
)

# # conda env stats with bkce, and should be consistent with OX_CONDA_ENV
OX_OXIDE[bkceb]=${OX_BACKUP}/conda/conda-base.txt
OX_OXIDE[bkcem]=${OX_BACKUP}/conda/conda-music.txt

alias b="ceq && ceat b; clear"
alias m="ceq && ceat m; clear"
alias q="ceq"

##########################################################
# others settings
##########################################################

OX_OXIDE[bkesb]=${OX_BACKUP}/espanso/match/base.yml
OX_OXIDE[bkvs]=${OX_BACKUP}/vscode/settings.jsonc

##########################################################
# common aliases
##########################################################

# shortcuts
alias cat="bat"
alias ls="lsd"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias e="echo"
alias rr="rm -rf"
alias c="clear"
alias own="sudo chown -R $(whoami)"
alias shell="echo ${SHELL}"
alias shells="cat ${SHELLS}"

# tools
alias man="tldr"
alias hf="hyperfine"
alias zz="z -"

# personal
alias bb="btm -b"
alias -g wl="| wc -l"

##########################################################
# shell
##########################################################

# test profile loading time
tt() {
    case ${SHELL} in
    *zsh)
        hyperfine --warmup 3 --shell zsh "source ${OX_ELEMENT[zs]}"
        ;;
    *bash)
        hyperfine --warmup 3 --shell bash "source ${OX_ELEMENT[bs]}"
        ;;
    esac
}

# clean history
ccc() {
    case ${SHELL} in
    *zsh)
        local HISTSIZE=0 && history -p && reset && echo >${OX_ELEMENT[zshst]}
        ;;
    *bash)
        local HISTSIZE=0 && history -c && reset && echo >${OX_ELEMENT[bshst]}
        ;;
    esac
}

# configuration
case ${SHELL} in
*zsh)
    # turn case sensitivity off
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    # pasting with tabs doesn't perform completion
    zstyle ':completion:' insert-tab pending
    ;;
*bash)
    # turn case sensitivity off
    if [ ! -e ${HOME}/.inputrc ]; then
        echo '$include /etc/inputrc' >${HOME}/.inputrc
    fi
    echo 'set completion-ignore-case On' >>${HOME}/.inputrc
    ;;
esac

##########################################################
# startup commands
##########################################################

# installer donwloaded path: works for function `brp()`
# use `which brp` to chech `brp()` in details
export OX_DOWNLOAD=${HOME}/Documents
export OX_STARTUP=1

startup() {
    # start directory
    cd ${HOME}/Documents || exit
}

alias yy="yt-dlp -N 50"

##########################################################
# notes apps
##########################################################

# OX_OXIDIAN=""
