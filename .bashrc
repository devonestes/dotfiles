#################################################################
########################## PATH SETUP ###########################
#################################################################

# Rbenv autocomplete and shims
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi
# Path for RBENV
test -d "$HOME/.rbenv/" && PATH="$HOME/.rbenv/bin:$PATH"

# Path for brew
test -d /usr/local/bin && export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"

# Path for Heroku
test -d /usr/local/heroku/ && export PATH="/usr/local/heroku/bin:$PATH"





















##################################################################
############################ ALIASES #############################
##################################################################

# Force ls to show everything (a), use colors (G) and use humanized file sizes (h)
alias ls='ls -aGh'

# I do these so frequently, that it makes sense to not have to type out the
# whole command every time I do it. Also, I really only ever use the verbose
# mode for `git branch`, so I can set that flag automatically.
alias gs='git status'
alias ga='git add'
alias gb='git branch -v'

# I do this a lot and don't want to type it out all the time.
alias hrc='heroku run rails console' 

# This is the directory where I keep all my non-work code, including my open
# source stuff, so I go there frequently. It's also where all the code for this
# workshop lives, so it's a convenient alias to have for me.
alias sandbox='cd ~/sandbox'

# Ok, now it's your turn! Remember that git repo that I had you clone somewhere
# on your filesystem a few minutes ago? Write your own alias for that project!
# The alias should be called `scenic`, since that's the name of the gem that
# we'll be adding a script or two to.
alias scenic='cd ~/sandbox/scenic'





















##################################################################
########################### FUNCTIONS ############################
##################################################################

cls() {
  cd "$1"
  ls
}

mkcd() {
  mkdir "$1"
  cd "$1"
}

catman() {
  man "$1" | cat
}

todo() {
  todo_file=~/.todo_file.txt
  if test ! -f "$todo_file"
  then
    touch "$todo_file"
  fi
  catman test

  case "$1" in
    "list")
      cat -n "$todo_file"
      ;;
    "add")
      echo "$2" >> "$todo_file"
      ;;
    "complete")
      to_write=$(grep -v "$2" "$todo_file")
      echo "$to_write" > "$todo_file"
      ;;
    *)
      echo "OTHER"
      ;;
  esac
}

















































#todo() {
  #file=~/.todo_file.txt
  #if test ! -f "$file"
  #then
    #echo "NOT FOUND"
    #touch "$file"
  #fi

  #case "$1" in
    #"list")
      #cat -n "$file"
      #;;
    #"add")
      #echo "$2" >> "$file"
      #;;
    #"complete")
      #;;
    #*)
      #echo "I don't recognize that command"
      #;;
  #esac
#}
