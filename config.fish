function multicd
echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end

abbr --add dotdot --regex '^\.\.+$' --function multicd

#Git
abbr -a ga git add 
abbr -a gs git status
abbr -a gaa git add . 
abbr -a gcm git commit -m 
abbr -a gco git checkout
abbr -a p git pull 
abbr -a P git push 
abbr -a Pf git push --force-with-lease
abbr -a grb git rebase
abbr -a gfo git fetch origin
abbr -a gprm git pull --rebase origin main
abbr -a gcma git commit --amend
abbr -a pfl git push --force-with-lease

function ggfl 
set -l git_branch (git branch 2>/dev/null | sed -n '/\* /s///p')
git push --force-with-lease origin $git_branch
end

alias glo 'git log --pretty=format:"%Cred%h%Creset \
-%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" \
--abbrev-commit'

abbr -a lg lazygit

function delete_local_branches_that_are_gone
git pull --prune;
git --no-pager branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -d
end 

abbr -a git_purge -f delete_local_branches_that_are_gone 

#GIthub 
abbr -a pr gh pr create 
abbr -a web gh pr view --web 
abbr -a markus gh pr edit --add-reviewer mkuhnt
abbr -a alexey gh pr edit --add-reviewer tank-bohr
abbr -a kai gh pr edit --add-reviewer kaikae

#Nvim bindings
abbr -a vim nvim
abbr -a vi nvim


#Mix 
abbr -a mt mix test 
abbr -a mc mix compile 
abbr -a md mix dialyzer 
abbr -a mcr mix credo 
abbr -a mps mix phx.server
alias mf='mix format'
#Navigation 
abbr -a hell cd /Users/diede/starfish/Hellgate/

#tmuxinator 
abbr -a mux tmuxinator
abbr -a muxs tmuxinator start

#fish stuff 
abbr -a change_config nvim ~/.config/fish/config.fish
abbr -a reload_config source ~/.config/fish/config.fish

#Nvim 
function nv_conf 
cd ~/.config/nvim/
nvim init.lua
end

#sponge stuff - https://github.com/meaningful-ooo/sponge
set -g sponge_purge_only_on_exit true

#pure theme 
abbr pure_config open https://pure-fish.github.io/pure/#configuration
set -g pure_threshold_command_duration 1
set -g pure_check_for_new_release false


#Set some env vars 
#this overrides any variable set as EDITOR befor fish starts
set -gx EDITOR lvim
set -gx VISUAL lvim


fish_add_path /opt/homebrew/bin

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd
    builtin pwd -L
end

# A copy of fish's internal cd function. This makes it possible to use
# `alias cd=z` without causing an infinite loop.
if ! builtin functions -q __zoxide_cd_internal
    if builtin functions -q cd
        builtin functions -c cd __zoxide_cd_internal
    else
        alias __zoxide_cd_internal='builtin cd'
    end
end

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd
    __zoxide_cd_internal $argv
end

# =============================================================================
#
# Hook configuration for zoxide.
#

# Initialize hook to add new entries to the database.
function __zoxide_hook --on-variable PWD
    test -z "$fish_private_mode"
    and command zoxide add -- (__zoxide_pwd)
end

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

set __zoxide_z_prefix 'z!'

# Jump to a directory using only keywords.
function __zoxide_z
    set -l argc (count $argv)
    set -l completion_regex '^'(string escape --style=regex $__zoxide_z_prefix)'(.*)$'

    if test $argc -eq 0
        __zoxide_cd $HOME
    else if test "$argv" = -
        __zoxide_cd -
    else if test $argc -eq 1 -a -d $argv[1]
        __zoxide_cd $argv[1]
    else if set -l result (string match --groups-only --regex $completion_regex $argv[-1])
        __zoxide_cd $result
    else
        set -l result (command zoxide query --exclude (__zoxide_pwd) -- $argv)
        and __zoxide_cd $result
    end
end

# Completions for `z`.
function __zoxide_z_complete
    set -l tokens (commandline --current-process --tokenize)
    set -l curr_tokens (commandline --cut-at-cursor --current-process --tokenize)

    if test (count $tokens) -le 2 -a (count $curr_tokens) -eq 1
        # If there are < 2 arguments, use `cd` completions.
        __fish_complete_directories "$tokens[2]" ''
    else if test (count $tokens) -eq (count $curr_tokens)
        # If the last argument is empty, use interactive selection.
        set -l query $tokens[2..-1]brew install coreutils curl git
        set -l result (zoxide query --exclude (__zoxide_pwd) -i -- $query)
        and echo $__zoxide_z_prefix$result
        commandline --function repaint
    end
end

# Jump to a directory using interactive search.
function __zoxide_zi
    set -l result (command zoxide query -i -- $argv)
    and __zoxide_cd $result
end

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

abbr --erase z &>/dev/null
complete --command z --erase
function z
    __zoxide_z $argv
end
complete --command z --no-files --arguments '(__zoxide_z_complete)'

abbr --erase zi &>/dev/null
complete --command zi --erase
function zi
    __zoxide_zi $argv
end

#Sleep mac 
function mac_sleep 
command sudo shutdown -s now
end

# gen uuid and save to clipboard 
function gen_uuid
  uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" | pbcopy
end

#ssh to lily 
alias lily 'ssh diede@10.83.29.10'
alias pihole 'ssh root@10.83.29.20'

set -x ASDF_DIR '/Users/diede/.asdf'
source ~/.asdf/asdf.fish

export GPG_TTY=$(tty) 
