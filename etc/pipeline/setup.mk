################################################################################
# Setup - etc/pipeline/setup.mk                                              #
################################################################################

# Setup MacOS environment

update-macos:
softwareupdate --all --install --force
sudo chown -R $(whoami) /usr/local/bin
chmod u+w /usr/local/bin

install-xcode:
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install

install-homebrew:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

repair-homebrew:
brew doctor

update-homebrew:
brew update
brew upgrade

list-homebrew:
brew list

uninstall-homebrew:
brew uninstall <package>

install-homebrew: 
brew install coreutils zlib tree sqlite aspell graphviz imagemagick makefile2graph xmlto git datamash pandoc xsv

# Setup Python environment
brew install pyenv pandoc

# identify the current python version: https://www.python.org/downloads/ (e.g. 3.10.1 on 2021-12-15)
pyenv install 3.9.0
pyenv global 3.9.0
pyenv version
#echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n eval "$(pyenv init -)"\nfi' >> ~/.zshrc
which python
pip -V
python3 -m pip install --upgrade pip
python3 -m pip install makefile2dot pygraphviz eralchemy csvkit sqlite-utils datasette datasette-vega

pip install --upgrade makefile2dot pygraphviz eralchemy csvkit \
sqlite-utils datasette datasette-vega datasette-cluster-map datasette-copyable datasette-pretty-json \
datasette-yaml

pip list


# Setup deployment tools