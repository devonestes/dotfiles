export ZSH=/home/devon/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cobalt2"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git, gitfast)

# User configuration

export PATH="/home/devon/.cargo/bin:/home/devon/.asdf/bin:/home/devon/.asdf/shims:/usr/local/heroku/bin:/usr/local/sbin:/usr/local/bin:~/bin/home/devon/.bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/devon/golang/bin:/usr/local/go/bin"


source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export VISUAL="vim"
  export EDITOR="$VISUAL"
  export GIT_EDITOR="$VISUAL"
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Make docker-compose happy
export COMPOSE_TLS_VERSION=TLSv1_2
#
# Save iex history
export ERL_AFLAGS="-kernel shell_history enabled"

###########################
# KEYBINDINGS 
###########################

# make CapsLock behave like Ctrl:
setxkbmap -option ctrl:nocaps

# make short-pressed Ctrl behave like Escape:
xcape -e 'Control_L=Escape'

###########################
# PATH VARIABLES
###########################



# Path for Heroku
test -d /usr/local/heroku/ && export PATH="/usr/local/heroku/bin:$PATH"

# Default user for postgres
export PGUSER=devon

###########################
# ALIASES
###########################

alias sudo='sudo '
alias be='bundle exec'
alias edit_crontab='env EDITOR=nano crontab -e'
alias sandbox="cd ~/sandbox"
alias save_stuff="cd ~/sandbox/save_stuff"
alias gpo='if [[ $(git branch -r | grep "origin.main") ]]; then; git pull origin main; else; git pull origin master; fi'
alias psql="PAGER='vim -R -u ~/.vimrcpg -' pgcli -h 0.0.0.0"
alias gb='git branch -v'
alias gl='git log'
alias gs='git status'
alias vim='vim -v -w ~/.vimlog "$@"'
alias mc="iex -S mix"
alias pb="cd ~/sandbox/pitch-backend"
alias pbd="cd ~/sandbox/pitch-backend-2"
alias gc="git commit --no-verify"
alias heroku_deploy='git push heroku master -f && heroku run "POOL_SIZE=2 mix ecto.migrate"'
alias dropbox_upload="rclone sync /home/devon/Dropbox/save_stuff dropbox:save_stuff"
alias pbcopy="tr --delete '\n' | xclip -selection c"
alias 1pass="pass show 1password.com/devon@forzafc.football | tr --delete '\n' | xclip -selection c"

###########################
# CUSTOM SCRIPTS
###########################

headphones() {
<<<"connect 30:35:AD:E4:D6:DD 
    quit" bluetoothctl
}

earbuds() {
<<<"connect 00:23:01:42:C6:6E
    quit" bluetoothctl
}

typeless() {
  history | tail -n 20000 | sed "s/.*  //" | sort | uniq -c | sort -g | tail -n 100
}

upd() {
  pwd=`pwd`
  cd ~/sandbox/pitch-backend
  git checkout master
  git pull origin master
  cd ~/sandbox/pitch-backend-2
  git checkout master
  git pull origin master
  cd $pwd
}

update_repo() {
  if [[ $(git branch -r | grep "origin.main") ]]; then;
    git checkout main
    git pull origin main
  else
    git checkout master
    git pull origin master
  fi
  git_prune
}

gitcf() {
  if [[ `pwd` == "/home/devon/sandbox/pitch-backend" ]]; then
    git add .
    git commit --no-verify -m 'small updates'
  else
    git add .
    git commit --no-verify --amend --no-edit
  fi
}

git_prune() {
  if [[ $(git branch -r | grep "origin.main") ]]; then;
    git_prune_branch "main"
  else
    git_prune_branch "master"
  fi
}

git_prune_branch() {
  git checkout "$1"
  git fetch origin --prune
  git fetch upstream --prune > /dev/null 2>&1
  git branch --merged "$1" | grep -v "* $1" | xargs -n 1 git branch -d
}

gitpu() {
  if [[ $(git branch -r | grep "origin.main") ]]; then
    git checkout main
    git pull upstream main
    git push origin main
  else
    git checkout master
    git pull upstream master
    git push origin master
  fi
  git_prune
}

# Postgres equivalent to heroku db:pull.
# Pulls latest heroku pgbackups dump into local database
#
# Usage:
#
# $ heroku_pg_pull [appname] [local database name]
#
function heroku_pg_pull(){
  echo "!   WARNING: Data in the local database '$2' will be destroyed."
  echo "    Type '$2' to overwrite data in local database '$2'"
  read local_database_name\?"> "
  echo
  if [ "$local_database_name" "==" "$2" ]; then
    heroku pg:backups:capture HEROKU_POSTGRESQL_BLUE_URL -a $1
    curl -o heroku_pg_pull_latest_backup.dump `heroku pg:backups:public-url -a $1`;
    dropdb $2
    createdb $2 -U `whoami` -h localhost -w
    pg_restore --if-exists --verbose --clean --no-acl --no-owner -h localhost -U `whoami` -d $2 heroku_pg_pull_latest_backup.dump;
    rm heroku_pg_pull_latest_backup.dump;
  else
    echo "Aborted"
  fi
}

kill_processes() {
  ps -ef | grep $1 | grep -v grep | awk '{print $2}' | xargs kill
}

psql_largest_relations() {
  \psql $1 -c "SELECT nspname || '.' || relname AS relation, pg_size_pretty(pg_relation_size(C.oid)) AS size FROM pg_class C LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace) WHERE nspname NOT IN ('pg_catalog', 'information_schema') ORDER BY pg_relation_size(C.oid) DESC LIMIT 20;"
}

blog() {
  cd ~/sandbox
  cd personal-website
  vim .
}

update_zeal() {
  cd ~/sandbox/ex_doc_zeal
  for package in bamboo benchee bypass decimal ecto ecto_sql ex_machina phoenix phoenix_html timex wallaby
  do
    ./generate.sh $package
  done
  cd -
}

deploy_production() {
  cd ~/sandbox/pitch-backend-2
  git checkout production
  git pull origin production
  mix deploy.production
}

windows() {
  if [[ $(xwininfo -root | awk '$1=="Width:" {print $2}') -gt "2000" ]]; then
    for visible_window in $(xdotool search --onlyvisible --desktop 0 --class .)
    do
      ~/resize_window.sh left "$visible_window"
    done

    xdotool search --onlyvisible --class spotify | xargs -I{} ~/resize_window.sh other {}
    xdotool search --onlyvisible --class telegram | xargs -I{} ~/resize_window.sh right {}
    xdotool search --onlyvisible --class terminator | xargs -I{} ~/resize_window.sh right {}
  else
    for visible_window in $(xdotool search --onlyvisible --desktop 0 --class .)
    do
      ~/resize_window.sh left "$visible_window"
    done

    xdotool search --onlyvisible --class telegram | xargs -I{} ~/resize_window.sh right {}
    xdotool search --onlyvisible --class terminator | xargs -I{} ~/resize_window.sh right {}
  fi
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/devon/sandbox/google-cloud-sdk/path.zsh.inc' ]; then source '/home/devon/sandbox/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/devon/sandbox/google-cloud-sdk/completion.zsh.inc' ]; then source '/home/devon/sandbox/google-cloud-sdk/completion.zsh.inc'; fi
if [ /home/devon/sandbox/google-cloud-sdk/bin/kubectl ]; then source <(kubectl completion zsh); fi

# Path for asdf
# Path to your oh-my-zsh installation.
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# Magic command to make opening vim with ctrl-click:
#
# filepath, line, column = self.get_filepath(strmatch)
# prefix = "xdotool getactivewindow windowactivate sleep 0.250 type --delay 10 "
# if filepath:
    # if line and column:
        # command = "'vim +\"call cursor(" + line + ", " + column + ')" ' + filepath + "\n'"
    # else:
        # command = "'vim +" + line + " " + filepath + "\n'"
    # command = prefix + command
    # if self.open_url():
        # os.system(command)
        # return '--version'
# return command


