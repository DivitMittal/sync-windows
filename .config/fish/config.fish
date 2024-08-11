#!/usr/bin/env fish
#################################### Setting variables ########################################
# Delete all previous paths in current fish terminal session
set -e fish_user_paths

## Fish variables
set -g fish_greeting

if status --is-interactive
    set -g fish_vi_force_cursor 1
    set -g fish_cursor_default block
    set -g fish_cursor_insert line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual block
end

## Environment Variables
set -gx EDITOR 'nvim'
set -gx VISUAL 'nvim'
set -gx PAGER 'less'
set -x LESS '--RAW-CONTROL-CHARS --mouse -C --tilde --tabs=2 -W --status-column -i'
set -x LESSHISTFILE '-'

# Adding to PATH env var
fish_add_path /mingw64/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/scoop/shims
fish_add_path $HOME/.cargo/bin
fish_add_path /c/Windows/System32/OpenSSH

################################## Additional Programs ##############################################
if status --is-interactive
    ####################################   Config when fish is interactive ###############################################3
    ## FZF - fuzzy finder
    # fzf
    set -x FZF_DEFAULT_OPTS "--multi --cycle --border --height 50% --bind='space:toggle' --bind='tab:down' --bind='btab:up' --no-scrollbar --marker='*' --preview-window=wrap"
    set -x FZF_DEFAULT_COMMAND 'fd --hidden'

    # PatrickF1/fzf.fish plugin
    set -gx fzf_fd_opts --hidden
    set -gx fzf_preview_dir_cmd eza --all --color=always --icons=always --classify --group-directories-first --group --hyperlink --color-scale --color-scale-mode=gradient
    set -gx fzf_diff_highlighter delta --paging=never --width=20
    set -gx fzf_preview_file_cmd bat --style=numbers
    fzf_configure_bindings --variables=\ev --processes=\ep --git_status=\es --git_log=\el --history=\er --directory=\ef

    # fifc plugin
    set -gx fifc_editor nvim
    set -gx fifc_fd_opts --hidden
    set -gx fifc_eza_opts --all

    ############################################ Aliases #################################################
    alias showpath 'echo $PATH | sed "s/ /\n/g"'
    alias showid "id | sed 's/ /\n/g'"

    # Remapping ls
    # alias ls "ls --almost-all --group-directories-first"
    # alias ll "ls --almost-all --group-directories-first -lH"
    # Mapping "ls" to "eza"
    set -l eza_params "--all" "--classify" "--icons=always" "--group-directories-first" "--color=always" "--color-scale" "--color-scale-mode=gradient" "--hyperlink"
    alias ll "eza -lbhHigUmuSa@ $eza_params"
    alias lt "eza -T --level=2 $eza_params" # tree listing with depth 2
    alias ls "eza $eza_params"

    # Other similar mappings
    alias cat 'bat --paging=never'

    # maintenance aliases
    alias pacman-backup 'pacman -Qe 1> $HOME/backup/msys_pacman.txt'

    # Directory shortcuts
    alias dt "builtin cd $HOME/Desktop/"
    alias dl "builtin cd $HOME/Downloads/"

    # Abbreviations
    abbr --position anywhere --add nv nvim
    abbr --position anywhere --add v vim
    abbr --position anywhere --add .2 'cd ../..'
    abbr --position anywhere --add .3 'cd ../../..'
    abbr --position command --add gs 'git status'
    abbr --position command --add ga 'git add'
    abbr --position command --add gph 'git push'
    abbr --position command --add gpl 'git pull'
    abbr --position command --add gf 'git fetch'
    abbr --position command --add gc 'git commit -m ""'

    ####################################### Initializations ###############################################
    # Starship - custom shell prompt
    type -q starship; and starship init fish | source
    # Zoxide utility - smarter cd
    type -q zoxide; and zoxide init --cmd cd fish | source
    # Atuin - magical shell history
    type -q atuin; and atuin init fish | source
end

