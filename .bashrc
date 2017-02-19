#################################################################
########################## PATH SETUP ###########################
#################################################################

# Rbenv autocomplete and shims
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
# Path for RBENV
test -d "$HOME/.rbenv/" && PATH="$HOME/.rbenv/bin:$PATH"

# Path for brew
test -d /usr/local/bin && export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
# Path for Heroku
test -d /usr/local/heroku/ && export PATH="/usr/local/heroku/bin:$PATH"

# Load git completions
git_completion_script=/usr/local/etc/bash_completion.d/git-completion.bash
test -s $git_completion_script && source $git_completion_script


#################################################################
############################ COLORS #############################
#################################################################

# A more colorful prompt.
# \[\e[0m\] resets the color to default color
ColorReset='\[\e[0m\]'
#  \e[0;31m\ sets the color to red
ColorRed='\[\e[0;31m\]'
# \e[0;32m\ sets the color to green
ColorGreen='\[\e[0;32m\]'

# PS1 is the variable for the prompt you see everytime you hit enter.
git_prompt_script=/usr/local/etc/bash_completion.d/git-prompt.sh
if [ -s $git_prompt_script ]; then
  # if git-prompt is installed, use it (ie. to install it use:
  # `brew install git`)
  source $git_prompt_script
  export GIT_PS1_SHOWDIRTYSTATE=1
  # set the prompt to display current working directory in red along with git branch
  export PS1="\n$ColorRed\W$ColorReset\$(__git_ps1) :> "
else
  # otherwise omit git from the prompt
  export PS1="\n$ColorRed\W$ColorReset :> "
fi

# Colors ls should use for folders, files, symlinks etc, see `man ls` and
# search for LSCOLORS
export LSCOLORS=ExGxFxdxCxDxDxaccxaeex

# Force grep to always use the color option and show line numbers
export GREP_OPTIONS='--color=always'

##################################################################
############################ ALIASES #############################
##################################################################

# Force ls to use colors (G) and use humanized file sizes (h)
alias ls='ls -Gh'
alias git='hub'
alias gs='git status'
alias ga='git add'
alias gb='git branch -v'
alias sandbox='cd ~/sandbox'

##################################################################
########################### FUNCTIONS ############################
##################################################################

git_prune() {
  git fetch origin --prune
  git checkout master
  git branch --merged master | grep -v "* master" | xargs -n 1 git branch -d
}

update_repo() {
  echo "Updating $1"
  cd ~/esh/$1 && git checkout master && git pull origin master && git_prune
}

esh_update() {
  update_repo "ecto"
  update_repo "SDR"
  update_repo "IRT"
}
