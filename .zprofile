#  -----------------------------------------------------------------------------
#
#  .ZPROFILE of falcon (for zsh)
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
#   Just don't, pure prompt is already amazing (in .zshrc)

#   Load nvm
#   -------------------------------------------
    export NVM_DIR="/Users/aron/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

#   Python 3.5 PATH
#   -------------------------------------------
    export PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"

#   Google Drive Location
#   -------------------------------------------
    export GDRIVE_HOME='/Users/aron/Google Drive'



#   ---------------------------------------
#   | 2. REMAPS AND ADDITIONS TO DEFAULTS |
#   ---------------------------------------

    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    eval "$(thefuck --alias)"                   # Create "fuck" alias for thefuck
    alias ll="ls -lahAFGp"                      # Better ls
    alias l='ll'                                # Short ll because I mistyped too many times
    cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
    alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
    alias gd="cd '${GDRIVE_HOME}'"              # Go to google drive folder
    alias c='clear'                             # Clear terminal display
    alias mk='make'                             # Make short
    alias am='atom'                             # Atom short
    alias subl='open -a Sublime\ Text'	        # Sublime short
    alias prof='open ~/.zprofile'               # Open this file

#   fasttex: to open a template Latex document in the current folder
#   -------------------------------------------
    fasttex () {
      # Get template file
      cp ${GDRIVE_HOME}/TEMPLATES/template.tex .

      # Get filename and rename
      if [ "$#" -eq 1 ] ; then
        filename="$1"
      else
        echo -n "Enter a name for the file: "
        read filename
      fi
      mv template.tex ${filename}.tex

      # Change import of falcon extensions from https://stackoverflow.com/questions/11245144/replace-whole-line-containing-a-string-using-sed
      falconpath="${GDRIVE_HOME}/TEMPLATES/"
      sed -i'.savefile' -- "s~FALCON_PATH~$falconpath~" "${filename}.tex"

      # Compile latex and open file
      pdflatex ${filename} >/dev/null   # only print errors
      open -a TexShop ${filename}.tex

      # Remove save file after sed
      if [ -f "${filename}.tex.savefile" ] ; then
        rm "${filename}.tex.savefile"
      fi
    }

#   readme: to open a template README document in the current folder
#   -------------------------------------------
    readme () {
      # Get template file
      cp ${GDRIVE_HOME}/TEMPLATES/README.txt .

      # Get filename and rename
      if [ "$#" -eq 1 ] ; then
        filename="$1"
      else
        echo -n "Enter a name for the file: "
        read filename
        echo -n "Use txt (1) or md (2)? "
        read ext
        if [ "$ext" -eq 1 ] ; then
          mv README.txt ${filename}.txt
          file=${filename}.txt
        elif [ "$ext" -eq 2 ] ; then
          mv README.txt ${filename}.md
          file=${filename}.md
        fi
      fi

      # open with atom
      am ${file}
    }

#   falcon: open tex commands extension file
#   -------------------------------------------
    alias falcon="open -a TexShop '${GDRIVE_HOME}/TEMPLATES/falcon.tex'"

#   fastc: to open a template C code file in the current folder
#   -------------------------------------------
    # fastc () {
    #   echo fastc ;
    # }

#   fastcc: to open a template C++ code file in the current folder
#   -------------------------------------------
    # fastcc () {
    #   echo fastcc ;
    # }



#   -------------------------
#   | 3. TEMPORARY COMMANDS |
#   -------------------------

#   USI folder
#   -------------------------------------------
    alias usi="cd ~/UROP2017/"

#   mkcgal: compile an own program in CGAL
#   -------------------------------------------
    mkcgal () {
      if [ "$#" -ne 1 ] ; then
        echo -n "What do you want to compile? "
        read executable
      else
        executable=$1
      fi

      echo "Generating CMakeLists ..." &&
      cgal_create_CMakeLists -s ${executable} > /dev/null &&
      echo "Generating Makefile ..." &&
      cmake -DCGAL_DIR=$HOME/CGAL-4.9.1 . > /dev/null &&
      echo "Compiling ${executable} ..." &&
      make > /dev/null &&
      echo "${executable} ready"
    }
    alias makecgal="mkcgal"

    cleancgal () {
      rm cmake_install.cmake CMakeCache.txt CMakeLists.txt Makefile &&
      rm -rf CMakeFiles/ &&
      echo "The trash has been taken care of"
    }


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
    alias vpnusi="scutil --nc start USI_inf_VPN"
    alias npvusi="scutil --nc stop USI_inf_VPN && echo 'disconnected'"

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
