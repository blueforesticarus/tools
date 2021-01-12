function cdroot 
    cd (rootdir $argv[1]) && cd $argv[2]
    pwd
end

function root..
    cdroot .. $argv .
end
function root
    cdroot . $argv .
end

function rootdir
    set -l r $argv .
    set -l roots (env -C $r[1] hg root 2>/dev/null)
    set -a roots (env -C $r[1] git root 2>/dev/null)

    set -l D (realpath $r[1])
    while not samefile $D /
        if contains $D $roots
            echo $D
            return
        end
        set D (realpath $D/../)
    end
    return 1
end

function samefile
    test (realpath $argv[1]) = (realpath $argv[2])
    return $status
end

complete -c root -e
complete -c root -f -a "(cd (rootdir) && __fish_complete_directories | cut -d \t -f 1)" -d ""

function out
    set -l D ./
    while ! mountpoint $D >/dev/null
        set D $D../
    end
    if test (realpath $D) = "/"
        echo "Current Directory is on root filesystem."
    else
        cd $D/../
        pwd
    end
end
