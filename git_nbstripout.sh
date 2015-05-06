#!/bin/bash

# strip out ipython notebook output in json
# wget https://raw.githubusercontent.com/cfriedline/ipynb_template/master/nbstripout -P $HOME
echo -e "[filter \"stripoutput\"]\n\tclean = \"$(pwd)/nbstripout\"" >> $HOME/.gitconfig
git config --global core.attributesfile $HOME/.gitattributes