if status is-interactive
# Commands to run in interactive sessions can go here
end

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
abbr -a grb git rebase
abbr -a gfo git fetch origin
abbr -a gprm git pull --rebase origin main
abbr -a gcma git commit --amend

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

#Lunarvim
abbr -a vim lvim
abbr -a vi lvim


#Mix 
abbr -a mt mix test 
abbr -a mc mix compile 
abbr -a md mix dializer 
abbr -a mcr mix credo 
abbr -a mps mix phx.server

#Navigation 
abbr -a hell cd /Users/diede/starfish/Hellgate/

#tmuxinator 
abbr -a mux tmuxinator
abbr -a muxs tmuxinator start

#fish stuff 
abbr -a change_config lvim ~/.config/fish/config.fish
abbr -a reload_config source ~/.config/fish/config.fish

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
