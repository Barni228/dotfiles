# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
# bindkey -e

# Prompt for spelling correction of commands.
setopt CORRECT

# Customize spelling correction prompt.
SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [%F{red}n%F{green}y%fa%F{blue}e%f]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

# ZDOTDIR=~/.config

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install


####################################################################
# --------------------------------------------------------------------

# export PATH="/opt/homebrew/bin:$PATH"
path+=/opt/homebrew/bin       # it is new way, zsh only
path+=/opt/X11/bin
export DISPLAY=:0

source ~/venv/bin/activate

# autoload -U compinit
# zstyle ':completion:*' menu select
# zmodload zsh/complist
# compinit
# _comp_options+=(globdots)		# Include hidden files.


# set nvim as default editor
export EDITOR=nvim
export VISUAL=nvim

export XDG_CONFIG_HOME="$HOME/.config"

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# # pin prompt to the bottom
# pin_prompt_to_bottom() {
#     # Move cursor to the bottom of the screen
#     echo -ne "\e[${LINES};0H"
# }
# # Bind the function to the pre-prompt
# autoload -Uz add-zsh-hook
# add-zsh-hook precmd pin_prompt_to_bottom

# aliases
alias run='python3 -u ~/python/python.py 2>&1 | sed "/Secure coding is not enabled for restorable state!/d"'
alias timer="python3 -u ~/python/timer.py"
alias stopwatch="python3 -u ~/python/stopwatch.py"
alias romnum="python3 -u ~/python/rom_num.py"
alias randchr="python3 ~/python/randchr.py"
alias morse="python3 -u ~/python/morse.py"

alias quitapps="~/Desktop/quitapps"
alias randchar="randchr"
alias nvimconf="nvim ~/.config/nvim/"
alias nvimplug="nvim ~/.config/nvim/lua/plugins/"
alias cat="bat -pp"
alias ls="eza  --icons=always -1"
alias tree="command tre"
alias c="clear"

# alias nvim='nvim --listen /tmp/nvim-server.pipe'

tre() { command tre "$@" -e && source "/tmp/tre_aliases_$USER" 2>/dev/null; }

y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

nv() {
    if [ "$#" -eq 0 ]; then
        {fd -HE .git -t f | fzf --preview "bat -pp --color=always {}" -m} | xargs nvim
    else
        nvim $@
    fi
}

# nv () {
#     nvim --listen /tmp/nvim-server.pipe $@
# }

vr () {
    $EDITOR "__WRITE_.$1"; rm -f __WRITE_*
}

vrc () {
    $EDITOR __WRITE_.$1 && cat __WRITE_.$1 2> /dev/null | pbcopy; rm -f __WRITE_*
}

# compile file
# TODO: make it work with other files but python
comp () {
    if [[ -f "$1" ]] then
        if [[ "$1" =~ .+\.pyx? ]] then
            cython --embed -o "${1%.*}.c" "$1"
            clang -o "${1%.*}" "${1%.*}.c" $(python3-config --cflags) $(python3-config --ldflags) -lpython3.12
            rm -r "${1%.*}.dSYM"
        fi
    fi
}

nvimswap () {
    mv ~/.local/state/nvim ~/.local/state/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
    mv ~/.cache/nvim ~/.cache/nvim.bak
    mv ~/.config/nvim ~/.config/nvim.bak

    mv ~/.local/state/nvim2 ~/.local/state/nvim
    mv ~/.local/share/nvim2 ~/.local/share/nvim
    mv ~/.cache/nvim2 ~/.cache/nvim
    mv ~/.config/nvim2 ~/.config/nvim

    mv ~/.local/state/nvim.bak ~/.local/state/nvim2
    mv ~/.local/share/nvim.bak ~/.local/share/nvim2
    mv ~/.cache/nvim.bak ~/.cache/nvim2
    mv ~/.config/nvim.bak ~/.config/nvim2
}

nvimswap2 () {
    mv ~/.local/state/nvim ~/.local/state/nvim2
    mv ~/.local/share/nvim ~/.local/share/nvim2
    mv ~/.cache/nvim ~/.cache/nvim2
    mv ~/.config/nvim ~/.config/nvim2
}

# Define the custom completion function for comp
_comp_comp() {
    # Local variables to hold completion state
    local -a files
    local expl

    # Use _files to generate the completion list for .py and .pyx files
    _files -g '*.py' -g '*.pyx'
}
# Register the custom completion function for comp
compdef _comp_comp comp

wr () {
    while read; do done
}

error () {
    return 1
}

solve () {
    source ~/venv/bin/activate
    python3 -u ~/python/solve.py "$@"
    deactivate
}

rep () {python3 -u ~/python/rep.py "$@"}

sub () {
    source ~/venv/bin/activate            # Activate the venv
    python3 ~/python/sub.py "$@"          # Run your Python script
    deactivate                            # Deactivate the venv
}

mcd () {
    mkdir -p "$1" && cd "$1"
}

# tell tab completion that mcd expects directories
_mcd_completion() {
    _files -/
}
compdef _mcd_completion mcd

# Set up fzf
eval "$(fzf --zsh)"

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# autopairs
source $(brew --prefix)/share/zsh-autopair/autopair.zsh

# atuin
. "$HOME/.atuin/bin/env" # . is same as source
eval "$(atuin init zsh --disable-up-arrow)"
bindkey -M vicmd '/' atuin-up-search-vicmd
source ~/.atuin/_atuin

# tell wezterm to start in fullscreen
# no longer needed because fullscreen doesnt work nicely with aerospace
# printf "\033]1337;SetUserVar=fullscreen=%s\007" $(echo -n bar | base64)

# Redirect stderr to a function that colorizes it
# exec 2> >(while read -r line; do echo -e "\033[38;5;202m$line\033[0m" >&2; done)

# function custom_keybindings() {
#   echo hi
#   bindkey -M menuselect 'h' vi-backward-char
#   bindkey -M menuselect 'k' vi-up-line-or-history
#   bindkey -M menuselect 'l' vi-forward-char
#   bindkey -M menuselect 'j' vi-down-line-or-history
#   bindkey -v '^?' backward-delete-char
#   # add-zsh-hook -d precmd custom_keybindings
# }
#
# # autoload -Uz add-zsh-hook
# # add-zsh-hook precmd custom_keybindings

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
