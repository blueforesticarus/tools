set -U fish_greeting
set EDITOR vvim
set VISUAL vvim
#cat ~/.cache/wal/sequences

source /usr/var/local/tools/root/util/setup.fish
bind \e\[23\;2~ backward-kill-word
bind \b backward-kill-bigword
bind \cu 'nav .. . is_make is_mount is_repo is_home; commandline -f repaint'
bind \ch 'nav . .. is_mount_not_root; commandline -f repaint'

# Adapted from /usr/share/fish/functions/fish_prompt.fish @ line 4
function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -l normal (set_color normal)

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l prefix
    set -l suffix '>'
    if contains -- $USER root toor
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY
        set color_host $fish_color_host_remote
    end

    # Write pipestatus
    set -l prompt_status (__fish_print_pipestatus " [" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)

    echo -n -s (fish_term_letter)\|\  (set_color $fish_color_user) "$USER" $normal @ (set_color $color_host) (prompt_hostname) $normal ' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal $prompt_status $suffix " "
end

function fish_term_letter
    set PID %self
    if ! set -q LETTER; or ! test -f /usr/var/local/fishes/$LETTER
        for Le in $alphabet
            if ! test -d /usr/var/local/fishes/$Le
                set LETTER $Le 
                ln -snfT /proc/$PID /usr/var/local/fishes/$LETTER
                break
            else if test (readlink /usr/var/local/fishes/$Le) = /proc/$PID
                set LETTER $Le
                break
            end
        end
    end
    set -U $LETTER $PWD
    echo $LETTER
end

function clear_term_letters
    rm -rf /usr/var/local/fishes/*
    set -e -U LETTER
end

function pwds 
    for Le in $alphabet
        if set -q $Le
            echo "$Le $$Le"
        end
    end | nauniq --skip-chars=2
end

set alphabet (echo -e (printf '\\\x%x ' (seq 65 90)) | fmt -w1)
