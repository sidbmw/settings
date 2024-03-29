#!/bin/bash

#check what distro we are on

#if [ "$OS" = "arch" ]; then
#    PKGMGR="sudo pacman -S --noconfirm"
#else
#    PKGMGR="sudo apt install -y"
#fi

PKGMGR="brew install"


pwd=`pwd`
git_prog=`command -v git`
zsh_prog=`command -v zsh`
curl_prog=`command -v curl`

# Use colors, but only if connected to a terminal, and that terminal supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

output()
{
	echo ""
	printf "${GREEN}"
	echo $1
	printf "${NORMAL}"
}

if [ -z "${curl_prog}" ]; then
    output "============== Installing Curl =========================="
	$PKGMGR curl
fi

if [ -z "${git_prog}" ]; then
    output "============== Installing Git =========================="
	$PKGMGR git
    # show git date with ISO standard and local time
    git config --global log.date iso-local
fi

output "============== Installing VIM =========================="
$PKGMGR vim

output "============== Installing Ag =========================="
if [ "$OS" = "arch" ]; then
    $PKGMGR the_silver_searcher
else
    $PKGMGR silversearcher-ag
fi

#clone my repo
output "=============== Cloning Siddharth's repo ================="
git clone https://github.com/sidbmw/settings.git ~/.settings
cd ~/.settings

#install zsh if not installed
if [ -z "${zsh_prog}" ]; then
	output "=============== Installing ZSH ================="
	$PKGMGR zsh
fi

#Install Oh my Zsh
output "=============== Installing OH MY ZSH ================="
curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh > oh.sh
chmod +x oh.sh
./oh.sh --unattended
rm -f ./oh.sh

#Add additional plugins for ZSH not found in oh-my-zsh
git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/marzocchi/zsh-notify.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/notify
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

#setup softlinks
output "=============== Setting up Soft Links ================="
ln -s ~/.settings/vimrc ~/.vimrc
echo "\"Add your custom vim settings to this file" > ~/.myvimrc
echo "#Add your custom zsh settings to this file" > ~/.myzshrc
mv ~/.zshrc ~/.zshrc.orig.ohmyzsh
ln -s ~/.settings/zshrc ~/.zshrc

output "=============== Setting up cscope maps ====================="
if [ ! -d ~/.vim ]; then
	mkdir ~/.vim #if ~/.vim dir doesn't exist, create it
fi
if [ ! -d ~/.vim/plugin ]; then
	mkdir ~/.vim/plugin #if plugin dir doesn't exist, create it
fi
cd ~/.vim/plugin
curl -O http://cscope.sourceforge.net/cscope_maps.vim
cd - # go back to the previous directory

output "=============== Downloading badwolf theme ====================="
if [ ! -d ${HOME}/.vim/colors ]; then
    mkdir ${HOME}/.vim/colors
fi
cd ${HOME}/.vim/colors
curl -O https://raw.githubusercontent.com/sjl/badwolf/master/colors/badwolf.vim
cd -

output "=============== Setting up Makefile ftplugin ==============="
if [ ! -d ~/.vim/ftplugin ]; then
	mkdir ~/.vim/ftplugin
fi
cd ~/.vim/ftplugin
#do not expand tabs in a makefile
echo "setlocal noexpandtab" > make.vim
cd -

output "=============== Installing vim-gtk to get global clipboard support ==============="
if [ "$OS" = "ubuntu" ]; then
    $PKGMGR vim-gtk
fi

output "=============== Setup Go directories ==============="
if [ ! -d ~/.go-dirs ]; then
    mkdir ~/.go-dirs
fi

#open vim once to install Plug
vim +qall
#open vim now to install all plugins
vim "+PlugInstall --sync" +qall

output "=============== Install custom font ==============="
mkdir /tmp/powerline
cd /tmp/powerline
git clone https://github.com/powerline/fonts.git
cd fonts
#install all fonts
./install.sh

wget -P ${HOME}/.local/share/fonts https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Regular.ttf
fc-cache -f ${Home}/.local/share/fonts


output "=============== Setting up Terminator ==============="
~/.settings/terminator/terminator.sh

output "=============== Install custom zsh theme ==============="
git clone https://github.com/denysdovhan/spaceship-prompt.git "${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt"
ln -s "${HOME}/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme" "${HOME}/.oh-my-zsh/themes/spaceship.zsh-theme"  
ln -s ~/.settings/zsh/p10k.zsh ~/.p10k.zsh

output "=============== vimrc and zshrc files are now in your home folder ================="
output "=============== Add custom vim settings to .myvimrc and zsh settings to .myzshrc files ============"
output "=============== Setup successful =================="
