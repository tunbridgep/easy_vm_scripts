#download dotfiles
git clone https://plausiblesarge@bitbucket.org/plausiblesarge/dotfiles.git $1

echo "DOTFILES=$1" >> ~/.profile_vars.local

echo please open the dotfiles folder and run install.sh to get started with a new machine, or run stow.sh to get your dotfiles ready.
echo \$DOTFILES environment variable added to ~/.profile_vars.local, with value $1
