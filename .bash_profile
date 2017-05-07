#  -----------------------------------------------------------------------------
#
#  .BASH_PROFILE of falcon
#
#  Parts:
#  1.  Environment configuration
#  2.  Remaps and additions to defaults
#  3.  Temporary commands (school, work)
#  4.  File and folder management
#  5.  Process management
#  6.  Networking
#
#  -----------------------------------------------------------------------------

#   --------------------------------
#   | 1. ENVIRONMENT CONFIGURATION |
#   --------------------------------

#   Change prompt
#   -------------------------------------------
    export PS1=" \u @\h : \w\n>$ "
    export PS2=">$ "
    export PROMPT_COMMAND="echo -n [$(date +%Y-%m-%d\ %H:%M:%S)]"

#   Load nvm
#   -------------------------------------------
    export NVM_DIR="/Users/aron/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

#   Python 3.5 PATH
#   -------------------------------------------
    export PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"



#   ---------------------------------------
#   | 2. REMAPS AND ADDITIONS TO DEFAULTS |
#   ---------------------------------------

    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    eval "$(thefuck --alias)"           # Create "fuck" alias for thefuck
    alias ll="ls -lahAFGp"              # Better ls
    cd() { builtin cd "$@"; ll; }       # Always list directory contents upon 'cd'
    alias cd..='cd ../'                 # Go back 1 directory level (for fast typers)
    alias c='clear'                     # Clear terminal display



#   -------------------------
#   | 3. TEMPORARY COMMANDS |
#   -------------------------

#   USI folder
#   -------------------------------------------
    alias usi="cd ~/Google\ Drive/SCHOOL/USI/B4 && ll"

#   pintOS command
#   -------------------------------------------
    alias pintOS='cd ~/pintOS/pintos0/ && vagrant up && vagrant ssh'



#   ---------------------------------
#   | 4. FILE AND FOLDER MANAGEMENT |
#   ---------------------------------

#   zipf: to ZIP a folder
#   -------------------------------------------
    zipf () { zip -r "$1".zip "$1" ; }

#   extract:  Extract most know archives with one command
#   -------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }



#   -------------------------
#   | 5. PROCESS MANAGEMENT |
#   -------------------------

#   my_ps: List processes owned by my user:
#   -------------------------------------------
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }



#   -----------------
#   | 6. NETWORKING |
#   -----------------

    alias ip="ifconfig en0 | grep -E 'status|inet|inet6' | sort -br"

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;ip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }
