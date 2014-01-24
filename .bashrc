[[ $- != *i* ]] && return

PROMPT_COMMAND='\
  if [ $? = 0 ]; then\
    DOLLAR_COLOR="\033[0m";\
  else\
    DOLLAR_COLOR="\033[0;31m";\
  fi;\
  timer_stop;\
'
PS1='[\u@\h ${timer_show}s \W]\[$(echo -ne $DOLLAR_COLOR)\]$\[\033[m\] '

# fn = file path/name
# ln = line number
# se = separator
# sl = matched line
# mt = matched chuck

#COLORS (Format: [flag;][flag;]...[flag;]foreground[;background])

#Foreground Normal=3x | Bright=9x
#Background Normal=4x | Bright=10x

#Value  0       1       4               5       6               7               8      9
#Flag   default bold    underlined      blink   no change       reverse field   black  striked

#Value  0       1       2       3       4       5       6       7
#Color  Black   Red     Green   Yellow  Blue    Magenta Cyan    White

export GREP_OPTIONS='--color=auto --binary-files=without-match --exclude-dir=.svn --exclude-dir=.hg --exclude-dir=.bzr --exclude-dir=.git --exclude=*.pyc'
export GREP_COLORS='fn=96:ln=93:se=31:mt=92:sl=37'
export LS_COLORS='no=0:rs=0:di=1;92:fi=0:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=4;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=1;91:mi=0'

export EDITOR=nano #Shut up, vim/emacs nazis! I don't fucking want to hear a single word!
export HISTCONTROL=ignoredups

shopt -s autocd
shopt -s cdspell
shopt -s cmdhist
shopt -s dirspell
shopt -s histappend

#Oops...
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias rm='rm -I --preserve-root'

#Typlexia and lazyness
alias ..='cd ..'
alias ake='make'
alias maek='make'
alias mkae='make'
alias makeç='make'
alias df='df -h'
alias wget='wget -c'

#Tools
alias diff='colordiff --side-by-side --width=`tput cols` --ignore-trailing-space --ignore-blank-lines'
alias dirsize='du -sh'
alias ls='ls --color=auto --almost-all --escape --indicator-style=classify --human-readable --literal --full-time --time-style=long-iso -o -v'
alias ports='netstat -tulanp'
alias reload='source ~/.bashrc'
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"
alias wpa='sudo wpa_supplicant -Dwext -B -i wlan0 -c/etc/wpa_supplicant.conf && sudo dhcpcd wlan0'
alias sync_progress='watch grep -e Dirty: -e Writeback: /proc/meminfo'
alias update='sudo yaourt -Syua'
alias update_pacman_mirrors='sudo reflector --sort rate --threads 20 --fastest 10 --latest 40 --save /etc/pacman.d/mirrorlist'
alias edit_pacman_mirrors='sudo nano /etc/pacman.d/mirrorlist'

#Oh git...
alias gia='git add'
alias giap='git app -p'
alias gibs='git bisect start'
alias gibb='git bisect bad'
alias gibg='git bisect good'
alias gibr='git bisect reset'
alias gid='git diff'
alias gis='git status'
alias gic='git commit -m'
alias gica='git commit -am'
alias gich='git checkout'
alias giri='git rebase -i'
alias gip='git push'
alias gipf='git push --force'
alias gipl='git pull'
alias giplr='git pull --rebase'

#Compile ASM to shellcode
alias asm2bin_x86='as -o /dev/null -32 -al -msyntax=intel -mnaked-reg'
alias asm2bin_x64='as -o /dev/null -64 -al -msyntax=intel -mnaked-reg'

#Dissasemble shellcode to ASM
alias bin2asm_x86='sed -E "s/\s//g" | sed -E "s/.{2}/& /g" | udcli -32 -x -intel'
alias bin2asm_x64='sed -E "s/\s//g" | sed -E "s/.{2}/& /g" | udcli -64 -x -intel'

#Dump binary files
alias bindump_x86='objdump -d -M intel-mnemonic,i386'
alias bindump_x64='objdump -d -M intel-mnemonic,x86-64'

#Debug
alias debug_here='sudo sh -c "ulimit -c unlimited && sysctl kernel.core_pattern=core"'
alias vgdb='valgrind --leak-check=full --db-attach=yes --db-command="cgdb -- -nw %f %p" --track-origins=yes'

#Compile ASM
asm86() { nasm -f elf32 "${1}" -O0 -o "${1}".o && ld -s -o "${1}".bin "${1}".o; }
asm64() { nasm -f elf64 "${1}" -O0 -o "${1}".o && ld -s -o "${1}".bin "${1}".o; }

#Compile C
c86() { gcc -m32 -o "${1}".bin "${1}"; }
c64() { gcc -m64 -o "${1}".bin "${1}"; }

#Un/compress files
alias untar='tar -zxvf'
mktar() { tar cvf  "${1}.tar"     "${1}"; }
mkgz() { tar cvzf "${1}.tar.gz"  "${1}"; }
mkbz2() { tar cvjf "${1}.tar.bz2" "${1}"; }

#Multimedia
list_tracks_ffmpeg() { ffmpeg -i "${1}" 2>&1 | grep -i stream; }
list_tracks_mkvmerge() { mkvmerge -i "${1}" | grep -i track; }

#extract_track_ffmpeg "Movie.avi" 0:1 "Sound.mp3"
extract_track_ffmpeg() { ffmpeg -i "${1}" -map "${2}" -acodec copy -vcodec copy "${3}"; }

#extract_track_mkvextract "Movie.mkv" 1 "Sound.mp3"
extract_track_mkvextract() { mkvextract tracks "${1}" ${2}:"${3}"; }

convert_with_sameq() { ffmpeg -i "${1}" -q:a 0 -q:v 0 "${2}"; } #same quality
#More audio options:
#-ab 128kb
#-ar 44100

function test_colors(){
  eval $(echo "no:global default; rs:reset; di:directory; fi:normal file; ln:symbolic link; mh:multihardlink; pi:named pipe; so:socket; do:door; bd:block device; cd:character device; or:orphan symlink; su:set uid; sg:set gid; ca:capability; tw:sticky other writable; ow:other writable; st:sticky; ex:executable; mi:missing file;" | sed -e 's/:/="/g; s/\;/"\n/g')
  {
    echo -e "LS_COLORS\n\n"
    IFS=:
    for i in $LS_COLORS ; do
      echo -e "\e[${i#*=}m$( x=${i%=*}; [ "${!x}" ] && echo "${!x}" || echo "$x" )\e[m"
    done
  }
  
  echo -e "\n\n"
  
  eval $(echo "fn:file path/name; ln:line number; se:separator; sl:matched line; mt:matched chunk;" | sed -e 's/:/="/g; s/\;/"\n/g')
  {
    echo -e "GREP_COLORS\n\n"
    IFS=:
    for i in $GREP_COLORS ; do
      echo -e "\e[${i#*=}m$( x=${i%=*}; [ "${!x}" ] && echo "${!x}" || echo "$x" )\e[m"
    done
  }  
}

#How much time did a command took to complete
timer_start() { timer=${timer:-$SECONDS} ; }
timer_stop() { timer_show=$(($SECONDS - $timer)) ; unset timer; }
trap 'timer_start' DEBUG

#Autocomplete
complete -cf sudo
complete -o dirnames -d cd
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi