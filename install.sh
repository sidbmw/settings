#clone my repo
output "=============== Cloning Siddharth's repo ================="
git clone https://github.com/sidbmw/settings.git ~/.settings
cd ~/.settings

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


#open vim once to install Plug
vim +qall
#open vim now to install all plugins
vim "+PlugInstall --sync" +qall

output "=============== Setup successful =================="
