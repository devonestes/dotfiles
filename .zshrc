# Path to your oh-my-zsh installation.
export ZSH=/Users/devoncestes/.oh-my-zsh

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
plugins=(git osx)

# User configuration

export PATH="/Users/devoncestes/.asdf/bin:/Users/devoncestes/.asdf/shims:/usr/local/heroku/bin:/usr/local/sbin:~/bin/Users/devoncestes/.bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/devoncestes/golang/bin:/usr/local/go/bin"
# export MANPATH="/usr/local/man:$MANPATH"

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
# PATH VARIABLES
###########################

# Path for brew
test -d /usr/local/bin && export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"

# Path for asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# Path for Heroku
test -d /usr/local/heroku/ && export PATH="/usr/local/heroku/bin:$PATH"

# Path for NVM
export NVM_DIR="~/.nvm"

# Path for Rust
test -d "$HOME/.cargo/bin" && export PATH="$HOME/.cargo/bin:$PATH"

# This loads NVM
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Go path settings
export GOROOT=/usr/local/go
export GOPATH=$HOME/golang
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

###########################
# ALIASES
###########################

alias sudo='sudo '
alias be='bundle exec'
alias edit_crontab='env EDITOR=nano crontab -e'
alias sandbox="cd ~/sandbox"
alias my_go="cd $GOPATH/src/github.com/devonestes"
alias goto_rbenv="cd ~/.rbenv"
alias esh="cd ~/esh"
alias sdr="cd ~/esh/SDR"
alias irt="cd ~/esh/IRT"
alias ecto="cd ~/esh/ecto"
alias berks="cd ~/esh/berks"
export BERKS="$HOME/esh/berks"
alias mochi="cd ~/esh/mochi"
alias taric="cd ~/esh/taric && be unicorn -p 3001"
alias exercism_go='cd ~/golang/src/exercism/go'
alias exercism_dir='cd ~/exercism'
alias killDS='find . -name *.DS_Store -type f -delete'
alias gpo='git pull origin master'
alias hlog='heroku logs -t -a irt-v3-production'
alias hrc='heroku run rails c -a irt-v3-production'
alias nand='cd ~/sandbox/nand2tetris'
alias hardware_sim='~/sandbox/nand2tetris/tools/HardwareSimulator.sh'
alias assembler='~/sandbox/nand2tetris/tools/Assembler.sh'
alias cpu_emulator='~/sandbox/nand2tetris/tools/CPUEmulator.sh'
alias jack_compiler='~/sandbox/nand2tetris/tools/JackCompiler.sh'
alias text_comparer='~/sandbox/nand2tetris/tools/TextComparer.sh'
alias vm_emulator='~/sandbox/nand2tetris/tools/VMEumulator.sh'
alias psql='pgcli'
alias pharaoh='pgcli pharaoh'
alias gb='git branch -v'
alias gs='git status'
alias vim='mvim -v -w ~/.vimlog "$@"'
alias credo="cd ~/sandbox/credo"
alias benchee="cd ~/sandbox/benchee"
alias rc="be rails console"
alias mc="iex -S mix"

###########################
# CUSTOM SCRIPTS
###########################

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
  git commit --fixup HEAD
  GIT_EDITOR=: git rebase -i --autosquash HEAD~2
}

git_prune() {
  git fetch origin --prune
  git checkout master
  git branch --merged master | grep -v "* master" | xargs -n 1 git branch -d
}

git_prune_branch() {
  git fetch origin --prune
  git checkout "$1"
  git branch --merged "$1" | grep -v "$1" | xargs -n 1 git branch -d
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

loop() {
  while [ true ]; do
    echo "$1" | sh
    read
  done
}
