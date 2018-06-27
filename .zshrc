# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/aron/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# Setup for pure prompt
autoload -U promptinit; promptinit
prompt pure
# End of pure prompt setup

# Setup for syntax highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# End of syntax highlighting setup

# Setup paths and variables
export PATH="/usr/local/opt/qt/bin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
# End of paths and variables setup