#!/usr/bin/env fish
#################################### Setting variables ########################################
# Delete all previous paths in current fish terminal session
set --erase fish_user_paths

## Fish variables
set -g fish_greeting ''

if status --is-interactive
    # Emulates vim's cursor shape behavior
    set -g fish_vi_force_cursor 1
    # Set the normal and visual mode cursors to a block
    set -g fish_cursor_default block
    # Set the insert mode cursor to a line
    set -g fish_cursor_insert line
    # Set the replace mode cursor to an underscore
    set -g fish_cursor_replace_one underscore
    # The following variable can be used to configure cursor shape in
    # visual mode, but due to fish_cursor_default, is redundant here
    set -g fish_cursor_visual block
end

## Environment Variables
set -gx EDITOR 'nvim'
set -gx VISUAL 'nvim'
# Adding to PATH env var
fish_add_path $HOME/.local/bin


################################## Additional Programs ##############################################
if status --is-interactive
    ####################################   Config when fish is interactive ###############################################3
    # fifc plugin environment variables
    set -gx fifc_editor nvim
    set -gx fifc_fd_opts --hidden
    set -gx fifc_bat_opts --style=numbers
    set -gx fifc_exa_opts --all --classify --icons --oneline --group-directories-first --group

    # PatrickF1/fzf.fish plugin environment variables
    set -gx fzf_fd_opts --hidden
    set -gx fzf_preview_dir_cmd eza --all --color=always --icons=always --classify --group-directories-first --group --hyperlink --color-scale --color-scale-mode=gradient
    # GNU Screen config env var
    set -gx SCREENRC $HOME/.config/screen/screenrc

    ############################################ Aliases #################################################
    alias showpath 'echo $PATH | sed "s/ /\n/g"'
    alias showid "id | sed 's/ /\n/g' | sed 's/,/\n/g'"

    # Mapping "ls" to "eza"
    # set -l eza_params "--all" "--classify" "--icons=always" "--group-directories-first" "--color=always" "--color-scale" "--color-scale-mode=gradient" "--hyperlink"
    # alias ll "eza -lbhHigUmuSa@ $eza_params"
    # alias lt "eza -T --level=2 $eza_params" # tree listing with depth 2
    # alias ls "eza $eza_params"

    # Other similar mappings
    # alias man 'batman'
    # alias cat 'bat'
    # alias ff 'fastfetch --logo-type iterm --logo $HOME/Sync-macOS/assets/a-12.png --pipe false --structure Title:OS:Kernel:Uptime:Display:Terminal:CPU:CPUUsage:GPU:Memory:Swap:LocalIP --gpu-temp true --cpu-temp true --title-color-user magenta --title-color-at blue --cpu-format "{1} @ {#4;35}{8}°C{#}" --gpu-format "{2} @ {#4;35}{4}°C{#}"'

    # Directory shortcuts for macOS
    alias dt "cd $HOME/Desktop/"
    alias dl "cd $HOME/Downloads/"

    # Abbreviations
    abbr --position anywhere --add nv nvim
    abbr --position anywhere --add v vim
    abbr --position anywhere --add .2 'cd ../..'
    abbr --position anywhere --add .3 'cd ../../..'
    abbr --position command --add gits 'git status'
    abbr --position command --add gitph 'git push'
    abbr --position command --add gitpl 'git pull'
    abbr --position command --add gitf 'git fetch'
    abbr --position command --add gitc 'git commit'


    ####################################### Initializations ###############################################
    # Run Fastfetch - fetch system info
    if type -q fastfetch
        fastfetch
    end

    # Starship - custom shell prompt
    if type -q starship
        starship init fish | source
    end
end

