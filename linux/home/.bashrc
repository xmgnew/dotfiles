#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# fastfetch rainbow greeting (local + ssh)
if [[ $- == *i* ]] \
   && command -v fastfetch >/dev/null \
   && command -v lolcat >/dev/null; then
  fastfetch | lolcat
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
