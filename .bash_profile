# This just says that if a .bashrc file is available, then we should load that.
# That's where we'll keep most of our settings!
echo "Loading ~/.bash_profile a shell script that runs in every new terminal you open"

if [ -f "$HOME/.bashrc" ] ; then
  echo "Loading ~/.bashrc, since that's where we put all the _real_ stuff"
  source $HOME/.bashrc
fi
