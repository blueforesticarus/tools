function ihop
    if ! test -z "$argv[1]"
        set dir (i $argv[1])
        if test -z "$dir"
            echo "ERR: \"$arv[1]\" not in index."
        else
            cd "$dir"
            pwd
        end
    else
        set target (choosefrom (i|psub)  | cut -f 1)
        ihop "$target"
    end
end
