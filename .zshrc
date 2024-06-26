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


# --------------------------------------------------------------------

# export PATH="/opt/homebrew/bin:$PATH"
path+=/opt/homebrew/bin       # it is new way, zsh only

source ~/venv/bin/activate

# autoload -U compinit
# zstyle ':completion:*' menu select
# zmodload zsh/complist
# compinit
# _comp_options+=(globdots)		# Include hidden files.


# set nvim as default editor
export EDITOR=nvim
export VISUAL=nvim

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

# add aliases
alias run='python3 -u ~/python/python.py 2>&1 | sed "/Secure coding is not enabled for restorable state!/d"'
alias timer="python3 -u ~/python/timer.py"
alias stopwatch="python3 -u ~/python/stopwatch.py"
alias rom_num="python3 -u ~/python/rom_num.py"
alias randchr="python3 ~/python/randchr.py"

alias quitapps='osascript -e "quit app \"TextEdit\"" -e "quit app \"Preview\"" -e "quit app \"Pages\"" -e "quit app \"Adobe Acrobat Reader\"" -e "quit app \"Terminal\"" -e "quit app \"Activity Monitor\""'
alias randchar="randchr"
alias nvimconf="nvim ~/.config/nvim/"
alias nvimplug="nvim ~/.config/nvim/lua/plugins/"
alias cat="bat -pp"
alias ls="eza  --icons=always -1"
alias vr='$EDITOR "._WRITE.$1" && cat "._WRITE.$1" 2> /dev/null | pbcopy; rm -f "._WRITE.$1"'

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
