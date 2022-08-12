# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# for nvim
export XDG_CONFIG_HOME="~/.config"

# for peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# for AUTO_CO
setopt AUTO_CD

# for cdpath
setopt AUTO_CD
cdpath=(.. ~ ~/workspace/)

#--------------alias---------------
alias g='git'
alias gb='git branch'
alias gcm='git commit -m'
alias gcam='git commit --amend -m'
alias gco='git checkout'
alias gob='git checkout -b'
alias gpl='git pull'
alias gps='git push'
alias gg='git grep'
alias gst='git status'
alias glg='git log'

alias rs='rails s'
alias rc='rails c'

alias bi='bundle install'
alias be='bundle exec'
alias ber='bundle exec rspec'
alias bu='bundle update'

alias t='tig'
alias ts='tig status'

alias v='nvim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH=$HOME/.nodebrew/current/bin:$PATH
c
