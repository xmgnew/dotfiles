# ==========================================
# Interactive shell
# ==========================================
if status is-interactive

    if type -q starship
        starship init fish | source
    end

    # Disable default fish greeting
    set fish_greeting ""

    # Fastfetch rainbow greeting
    if type -q fastfetch; and type -q lolcat
        fastfetch | lolcat
    end

end

# ==========================================
# PATH
# ==========================================

# User-installed binaries, e.g. lolcat, fd
fish_add_path $HOME/.local/bin

# Manually installed latest Neovim
fish_add_path /opt/nvim/bin

# ==========================================
# Basic aliases / abbreviations
# ==========================================

alias grep 'grep --color=auto'

# Fastfetch
function f
    fastfetch | lolcat
end

# Git
# abbr gs 'git status'
# abbr ga 'git add'
# abbr gc 'git commit'
# abbr gp 'git push'
# abbr gl 'git pull'

# Clear terminal
abbr cls clear

# ==========================================
# Yazi wrapper
# ==========================================

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"

    if read -z cwd <"$tmp"; and test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end

    rm -f -- "$tmp"
end

# ==========================================
# Zoxide
# ==========================================

if type -q zoxide
    zoxide init fish --cmd cd | source
    # zoxide init fish | source
end

# ==========================================
# FZF
# ==========================================

if type -q fzf
    set -gx FZF_DEFAULT_OPTS '--height=40% --layout=reverse --border'
end

# ==========================================
# Editor
# ==========================================

set -gx EDITOR nvim
set -gx VISUAL nvim
