#this configures $PATH and functions for fish
#AKA fish versions of path.env and shellrc respectively
function appendpath
    set -x PATH $argv (string match -v $argv $PATH)
end

appendpath /usr/var/local/tools/root/bin
appendpath /usr/var/local/tools/root/extern/bin

for f in (find /usr/var/local/tools/root/bin/source -type f -name '*.fish')
    source $f
end
