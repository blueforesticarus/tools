function root 
    #!/bin/bash
    cd (hg root) || cd (git root) && cd $argv
end
complete -c root -e
complete -c root -f -a "(cd (hg root) && __fish_complete_directories | cut -d \t -f 1)" -d ""

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
