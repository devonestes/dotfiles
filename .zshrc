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
plugins=(git)

# User configuration

export PATH="/home/devon/.asdf/bin:/home/devon/.asdf/shims:/usr/local/heroku/bin:/usr/local/sbin:/usr/local/bin:~/bin/home/devon/.bin:/usr/bin:/bin:/usr/sbin:/sbin:/home/devon/golang/bin:/usr/local/go/bin"

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

# Path for asdf
# Path to your oh-my-zsh installation.
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

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
alias esh="cd ~/esh"
alias sdr="cd ~/esh/SDR"
alias irt="cd ~/esh/IRT"
alias exercism_go='cd ~/golang/src/exercism/go'
alias exercism_dir='cd ~/exercism'
alias killDS='find . -name *.DS_Store -type f -delete'
alias gpo='git pull origin master'
alias nand='cd ~/sandbox/nand2tetris'
alias hardware_sim='~/sandbox/nand2tetris/tools/HardwareSimulator.sh'
alias assembler='~/sandbox/nand2tetris/tools/Assembler.sh'
alias cpu_emulator='~/sandbox/nand2tetris/tools/CPUEmulator.sh'
alias jack_compiler='~/sandbox/nand2tetris/tools/JackCompiler.sh'
alias text_comparer='~/sandbox/nand2tetris/tools/TextComparer.sh'
alias vm_emulator='~/sandbox/nand2tetris/tools/VMEumulator.sh'
alias psql='pgcli -h 0.0.0.0'
alias gb='git branch -v'
alias gs='git status'
alias vim='vim -v -w ~/.vimlog "$@"'
alias benchee="cd ~/sandbox/benchee"
alias mc="iex -S mix"
alias potion="cd ~/sandbox/potion"
alias pdb="cd ~/sandbox/potion/apps/potion_db"
alias potion_db="cd ~/sandbox/potion/apps/potion_db"
alias pw="cd ~/sandbox/potion/apps/potion_web"
alias potion_web="cd ~/sandbox/potion/apps/potion_web"
alias ppr="cd ~/sandbox/potion_proxy"
alias potion_proxy="cd ~/sandbox/potion_proxy"

###########################
# CUSTOM SCRIPTS
###########################

headphones() {
<<<"connect 30:35:AD:E4:D6:DD 
    quit" bluetoothctl
}

typeless() {
  history | tail -n 20000 | sed "s/.*  //" | sort | uniq -c | sort -g | tail -n 100
}

update_repo() {
  echo "Updating $1"
  cd ~/esh/$1 && git checkout master && git pull origin master && git_prune
}

esh_update() {
  update_repo "ecto"
  update_repo "SDR"
  update_repo "mochi"
  update_repo "IRT"
}

orchard_update() {
  pwd=`pwd`
  cd ~/sandbox/potion
  git checkout master
  git pull upstream master
  git push origin master
  git_prune
  cd ~/sandbox/potion_proxy
  git checkout master
  git pull upstream master
  git push origin master
  git_prune
  cd ~/sandbox/orchard_office_frontend
  git checkout master
  git pull upstream master
  git push origin master
  git_prune
  cd ~/sandbox/qtclient
  git checkout master
  git pull upstream master
  git push origin master
  git_prune
  cd $pwd
}

run_oink() {
  cat log/production.log | cut -f 10- | grep 'rails\[' > log/production-oink.log
  oink log/production-oink.log -t 50
  oink log/production-oink.log -r
}

gitcr() {
  git_branch=$(Git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
  RAILS_ENV=test rake db:drop db:create db:migrate
  git add db/structure.sql
  git commit --fixup HEAD
  git checkout master
  gpo
  git checkout $git_branch
  git rebase -i --autosquash master
}

gitcf() {
  git add .
  git commit --no-verify --amend --no-edit
}

git_prune() {
  git_prune_branch "master"
}

git_prune_branch() {
  git checkout "$1"
  git fetch origin --prune
  git fetch upstream --prune
  git branch --merged "$1" | grep -v "* $1" | xargs -n 1 git branch -d
}

gitpu() {
  git checkout master
  git pull upstream master
  git push origin master
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

fork_db() {
  echo "WARNING! You are about to fork the production database and hook it up"
  echo "to '$1'"
  echo "If you want to continue, enter again the name of the review app"
  read review_app_name\?"> "
  echo
  if [ "$review_app_name" "==" "$1" ]; then
    old_db=$(heroku addons -a $1 | grep -m 1 -o "postgresql-[a-z]*-[0-9]*")
    heroku addons:destroy "$old_db" -a $1 --confirm $1
    new_db=$(heroku addons:create heroku-postgresql:standard-0 --fork `heroku pg:credentials:url HEROKU_POSTGRESQL_BLUE_URL -a esh-irt-v2-production | grep 'postgres[-\.\/\w:@]*'` -a $1 | grep -m 1 -o "postgresql-[a-z]*-[0-9]*")
    sleep 45
    heroku pg:wait -a $1
    echo "Promoting $new_db"
    heroku pg:promote "$new_db" -a $1 
    heroku config:get DATABASE_URL -a $1 | xargs -I % heroku config:set ECTO_DB_URL=% -a $1
    heroku run:detached rake db_ecto:migrate -a $1
    if [ $# -eq 2 ]; then
      heroku run:detached rake "esh:mass_update:run[$2]" -a $1
    fi
    heroku pg:credentials:url DATABASE -a $1
  else
    echo "Aborted"
  fi
}

ecto_migration() {
  file_name=$(bundle exec rails g migration $1 | grep -o "db.*\.rb")
  new_file_name=$(echo $file_name | sed "s/db\/migrate/db_ecto\/migrate/")
  mv $file_name $new_file_name
  mvim -v $new_file_name
}

run_ecto_migration() {
  dropdb pharaoh_test
  createdb pharaoh_test
  RAILS_ENV=test be rake app:db_ecto:structure:load
  RAILS_ENV=test be rake app:db_ecto:migrate
  sed -i "" "s/WITH NO DATA/WITH DATA/" db_ecto/structure.sql
  sed -i "" "/SET row_security = off;/d" db_ecto/structure.sql
  sed -i "" "/SET lock_timeout = 0;/d" db_ecto/structure.sql
}

psql_largest_relations() {
  \psql pharaoh -c "SELECT nspname || '.' || relname AS relation, pg_size_pretty(pg_relation_size(C.oid)) AS size FROM pg_class C LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace) WHERE nspname NOT IN ('pg_catalog', 'information_schema') ORDER BY pg_relation_size(C.oid) DESC LIMIT 20;"
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/devon/sandbox/google-cloud-sdk/path.zsh.inc' ]; then source '/home/devon/sandbox/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/devon/sandbox/google-cloud-sdk/completion.zsh.inc' ]; then source '/home/devon/sandbox/google-cloud-sdk/completion.zsh.inc'; fi
if [ /home/devon/sandbox/google-cloud-sdk/bin/kubectl ]; then source <(kubectl completion zsh); fi
