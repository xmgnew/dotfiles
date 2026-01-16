#/Library/Frameworks/Python.framework/Versions/3.12/bin/python3

eval "$(starship init zsh)"

# Syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Disable underline
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Activate autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Created by `userpath` on 2026-01-09 15:31:54
export PATH="$PATH:/Users/expldfsh/.local/bin"

# Created by `pipx` on 2026-01-09 15:39:50
export PATH="$PATH:/Users/expldfsh/Library/Python/3.11/bin"

# fastfetch rainbow greeting (local + ssh)
if [[ -o interactive ]] \
    && command -v fastfetch >/dev/null \
    && command -v lolcat >/dev/null; then
    fastfetch | lolcat
fi

alias f='fastfetch | lolcat'
