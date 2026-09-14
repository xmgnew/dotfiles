# MacTeX / TeX Live (macOS)
if test (uname) = Darwin
    if test -d /Library/TeX/texbin
        fish_add_path -g /Library/TeX/texbin
    end
end
