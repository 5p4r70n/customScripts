function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
    	cowsay "Hey $USER go Ahead"
	echo ""
	echo $(fortune)
end

starship init fish | source
if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
    cat ~/.cache/ags/user/generated/terminal/sequences.txt
end

alias pamcan=pacman

#adding ssh agent details to env
eval (ssh-agent -c) >> /dev/null


export XDG_CURRENT_DESKTOP=sway


#export XDG_CURRENT_DESKTOP=Hyprland
#export GTK_USE_PORTAL=1


export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORM="wayland;xcb"
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_QPA_PLATFORMTHEME=qt5ct


# function fish_prompt
#   set_color cyan; echo (pwd)
#   set_color green; echo '> '
# end
