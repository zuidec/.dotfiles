# Sample .bashrc for SUSE Linux
# Copyright (c) SUSE Software Solutions Germany GmbH

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.
###############################################################################

test -s ~/.alias && . ~/.alias || true

# Set bash to vim mode
set -o vi

# Source ble.sh for bash autocomplete
# Config settings can be changed in ~/.blerc
#[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh

# Source script to have fancy ls colors
source ~/.dotfiles/bash/lscolors.sh

# Source script with convenience color defintions
source ~/.dotfiles/bash/bash_colors.sh

# Change ls command to color and group directories together
alias ls='ls --color=auto --group-directories-first'

###############################################################################
# The following block loads up ssh keys and adds then to the ssh-agent
###############################################################################
if [ $(id -u) -ne 0 ]; then
{
    #
    # Set up ssh-agent and ssh-add whenever bash runs
    #
    env=~/.ssh/agent.env

    agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

    agent_start () {
        (umask 077; ssh-agent >| "$env")
        . "$env" >| /dev/null ; }

    agent_load_env

    # Read the list of ssh keys to add to ssh-agent. 
    # Should be stored in ~/.ssh/ssh_key_list
    readarray -t ssh_keys < ~/.ssh/ssh_key_list

    # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
    agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

    if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
        agent_start
        for item in "${ssh_keys[@]}" 
                do ssh-add $item 
        done
    elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
        for item in "${ssh_keys[@]}" 
                do ssh-add $item 
        done
    fi

    unset env
}
fi

###############################################################################
# PS1 configuration
###############################################################################

# Get current git branch to add to PS1
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Set PWD to only go up two levels
PROMPT_DIRTRIM=2

# Set color of prompt when connected by SSH
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    PS1="\[$BBlue\][\u@\h]:\[$Cyan\]\w \[$ICyan\]\$(git_branch)\[$Cyan\]> \[$IWhite\]" 
     
# Set color of root shell
elif [ $(id -u) -eq 0 ]; then
	PS1="\[$BIRed\][\u@\h]:\w \[$IPurple\]\$(git_branch)\[$BIRed\]\$ \[$IWhite\]"
    
# Otherwise use this prompt
else
    PS1="\[$BYellow\][\u@\h]:\[$Cyan\]\w \[$ICyan\]\$(git_branch)\[$Cyan\]> \[$IWhite\]" 
fi


###############################################################################
# Extra add-on configuration
###############################################################################
# FZF configuration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Needed for ble.sh, should be at EOF
[[ ${BLE_VERSION-} ]] && ble-attach

export STM32_PRG_PATH=/home/zuidec/Programs/st/STM32CubeProgrammer/bin