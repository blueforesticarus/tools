complete -c root -e
complete -c root -f -a "(cd (rootdir) && __fish_complete_directories | cut -d \t -f 1)" -d ""

function is_mount
    mountpoint $argv[1] >/dev/null ^/dev/null
    return $status
end
function is_repo
    test -d $argv[1]/.git || test -d $argv[1]/.hg
    return $status
end
function is_make
    test -f $argv[1]/Makefile || test -f $argv[1]/makefile || test -f $argv[1]/wscript
    return $status
end
function is_home
    test (realpath $argv[1]) = $HOME
    return $status
end
function is_mount_not_root
    is_mount $argv[1] && test (realpath $argv[1]) != '/'
end

function has_readme
    count $argv[1]/README*
    return $status
end

function nav
    set -l D $argv[1]
    set -l SUFFIX $argv[2]
    set -l tests $argv[3..-1]

    while ! testnav $D $tests
        if test (realpath $D) = '/' 
            return 1
        end
        set D $D/..
    end

    cd $D/$SUFFIX
end

function testnav
    for foo in $argv[2..-1]
        if $foo $argv[1]
            return 0
        end
    end

    return 1
end

function root
    set -l foo_l
    for A in $argv
        switch $A
            case b -b build
                set -a foo_l is_make
            case r -r repo
                set -a foo_l is_repo
            case h -h home
                set -a foo_l is_home
            case m -m mount
                set -a foo_l is_mount
            case d -d docs
                set -a foo_l has_readme
            case --help help
                echo "usage: root b[uild] r[epo] h[home] m[mount] d[ocs]"
                return
        end
    end
    if test -z "$foo_l"
        set foo_l is_make is_repo is_home is_mount
    end
    nav .. . $foo_l
end
