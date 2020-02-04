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

#   Python 3.5 PATH
#   -------------------------------------------
    export PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"

#   Google Drive Location
#   -------------------------------------------
    export GDRIVE_HOME="/Users/${USER}/Google Drive"

#   Java home
#   -------------------------------------------
    export JAVA_HOME="$(/usr/libexec/java_home)"

#   Scala Build Tool
#   -------------------------------------------
    export PATH="/usr/local/opt/sbt@0.13/bin:$PATH"

#   Rust build tool
#   -------------------------------------------
    export PATH="$HOME/.cargo/bin:$PATH"


#   ---------------------------------------
#   | 2. REMAPS AND ADDITIONS TO DEFAULTS |
#   ---------------------------------------

    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
    alias l="ls -lahAFGp"                            # Better ls
    cd() { builtin cd "$@"; l; }                      # Always list directory contents upon 'cd'
    alias cd..='cd ../'                               # Go back 1 directory level (for fast typers)
    alias drive="cd '${GDRIVE_HOME}'"                 # Go to google drive folder
    alias c='clear'                                   # Clear terminal display
    alias profile='code ~/.zprofile'                  # Open this file
    alias templates="code '${GDRIVE_HOME}/TEMPLATES'" # Open templates folder

#   port: to check which process is using a port
#   -------------------------------------------
    port() { lsof -n -i :$1 }

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

    letter () {
      # Get template file
      cp ${GDRIVE_HOME}/TEMPLATES/letter.tex .

      # Get filename and rename
      if [ "$#" -eq 1 ] ; then
        filename="$1"
      else
        echo -n "Enter a name for the file: "
        read filename
      fi
      mv letter.tex ${filename}.tex

      # Compile latex and open file
      pdflatex ${filename} >/dev/null   # only print errors
      open -a TexShop ${filename}.tex
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

      # open with visual studio code
      code ${file}
    }

#   falcon: open tex commands extension file
#   -------------------------------------------
    alias falcon="open -a TexShop '${GDRIVE_HOME}/TEMPLATES/falcon.tex'"

#   loc: count lines of code in a directory
#   -------------------------------------------
    loc () {
      # get arguments
      if [ "$#" -eq 2 ] ; then
        dir="$1"
        name="$2"
      else
        echo "Usage: loc <dir> <name> (both can be patterns)"
        return 1;
      fi

      find $dir -type f -name $name | xargs cat | sed '/^\s*#/d;/^\s*$/d;/^\s*\/\//d' | wc -l
    }

#   loc: count lines of code in a directory
#   -------------------------------------------
    gitloc () {
      # get argument
      if [ "$#" -eq 1 ] ; then
        author="$1"
      else
        echo "Usage: gitloc <author>"
        return 1;
      fi

      git log --author="${author}" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
    }

#   md2pdf: script to convert a MD file to PDF with Pandoc
#   -------------------------------------------
    md2pdf () {
      echo "NOT YET IMPLEMENTED"
      return 1;
      OUTPUT_NAME=hegias_dev_guide.pdf
      MARGIN=2cm

      # get arguments
      if [ "$#" -eq 2 ] ; then
          input="$1"
          output="$1"
      else
          echo "Usage: md2pdf <author>"
          return 1;
      fi

      pandoc \
        --toc \
        --from markdown+smart \
        --number-sections \
        --top-level-division=chapter \
        --variable documentclass=report \
        --variable geometry:margin=$MARGIN \
        --variable mainfont='Fira Sans' \
        --pdf-engine=`which xelatex` \
        -o $OUTPUT_NAME
    }


#   -------------------------
#   | 3. TEMPORARY COMMANDS |
#   -------------------------

#   USI folder
#   -------------------------------------------
    alias usi="cd '${GDRIVE_HOME}/SCHOOL/USI/M3'"

#   HEGIAS folder
#   -------------------------------------------
    alias heg="cd ~/GIT/hegiasGo"

#   kibana
#   -------------------------------------------
    kib () {
        # get optional arg
        if [ "$#" -eq 1 ] ; then
            ~/elastic/kibana-7.0.0-darwin-x86_64/bin/kibana -e $1
        else
            ~/elastic/kibana-7.0.0-darwin-x86_64/bin/kibana
        fi
    }

#   elastic
#   -------------------------------------------
    alias elastic="cd ~/elastic && ./elasticsearch-7.0.0/bin/elasticsearch -d"

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
        echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }
