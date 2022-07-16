# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd
setopt correct
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mattfedora/.zshrc'

EDITOR=nano

bindkey '^ ' autosuggest-accept
bindkey  '^[[H'   beginning-of-line
bindkey  '^[[F'   end-of-line
bindkey  '^[[3~'  delete-char

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Load aliases and shortcuts if existent.
[ -f "$HOME/aliasrc" ] && source "$HOME/aliasrc"

# Load ; should be last.
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

eval "$(oh-my-posh init zsh --config ~/.poshthemes/powerlevel10k_rainbow.omp.json)"
