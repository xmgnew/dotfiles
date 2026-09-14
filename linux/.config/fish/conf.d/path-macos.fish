if test (uname) = Darwin
    if test -d /opt/homebrew/bin
        fish_add_path -g /opt/homebrew/bin
    end
    if test -d /usr/local/bin
        fish_add_path -g /usr/local/bin
    end
end
