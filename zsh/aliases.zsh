# listing files
alias ls='ls -alG'
alias ltr='ls -ltrG'
alias lth='ls -tG|head'
alias lh='ls -SGhl | less'
alias tf='tail -f -n $1'

# general shortcuts
alias mv='mv -i'
alias md=mkdir
alias ..='cd ..;' # can then do .. .. .. to move up multiple directories.
alias ...='cd .. ; cd ..' #also see up() in functions.sh
alias tree="ls -R | grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias ducks='du -cks * | sort -rn|head -11' # Lists the size of all the folders

alias todo='grep -ni TODO *'
alias rtodo='grep -niR TODO *'

alias drop="cd ~/Dropbox"
alias reload="source ~/.zshrc"

# History
alias tophist="history | awk '{print $4}' | sort | uniq -c | sort -rn | head"
alias 'h?'='history | grep $1'

# Sublime Text 2
alias st='subl'
alias stt='subl .'
alias sp='subl `find . -name "*.sublime-project"`'

# Get OS X Software Updates, update Homebrew itself, and upgrade installed Homebrew packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade'

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

# Full site to PNG
alias pngsite="/usr/local/bin/webkit2png $1"

#rvm
alias rvmdef='rvm use default'
alias r91='rvm use 1.9.1'
alias r9h='rvm use 1.9.2'
alias r93='rvm use 1.9.3'
alias r18='rvm use 1.8.7'
alias rj='rvm use jruby'
alias rsys='rvm use system'
alias rrub='rvm use rubinius'

# ruby & rails shortcuts
alias annotate='annotate --position before --exclude tests,fixtures'
alias rs='rails s'
alias rc='rails c'
alias rct='rails c test'
alias rcp='rails c production'
alias rg='rails generate'

# oldschool RoR shortcuts
alias rs2='script/server'
alias rc2='script/console'
alias rg2='script/generate'

# testing shortcuts
alias rt='rake --trace'
alias rtt='rake -T'
alias rtf='rake test:functionals --trace'
alias rti='rake test:integration --trace'
alias rtl='rake test:lib --trace'
alias rtp='rake test:plugins --trace'
alias rtu='rake test:units --trace'

# rake
alias rake='noglob rake' # Turn off ZSH globbing for rake tasks with arguments
alias rdm='rake db:migrate'
alias rdtp='rake db:test:prepare'
alias rdfl='rake db:fixtures:load'
alias rdr='rake db:rollback'
alias rroutes='rake routes'
alias rgrep='rake routes |grep '
alias mroutes='rroutes | subl'

# mobile
alias titanium='~/Library/Application\ Support/Titanium/mobilesdk/osx/1.8.2/titanium.py'
alias startadb='/Developer/SDKs/android-sdk-macosx/platform-tools/adb start-server'
alias stopadb='/Developer/SDKs/android-sdk-macosx/platform-tools/adb kill-server'
alias logcat='/Developer/SDKs/android-sdk-macosx/platform-tools/adb -d logcat'

# mongo
alias mongostart='mongod run --config /usr/local/etc/mongod.conf'
alias mongostop='kill -2 `ps aux | grep [m]ongo* | awk '{ print $2 }'`'

# ps & other stuff
alias psg="ps ax | grep -v grep | grep $1"
alias topmem='ps -eo pmem,pcpu,rss,vsize,args | sort -k 1 | tail -10'  # top 10 memory processes
alias topcpu='ps -eo pmem,pcpu,rss,vsize,args | sort -k 2 | tail -10'  # top 10 cpu processes

alias huh="whatis" # much shorter

# Recursively remove .svn dirs
alias killsvn="find . -name '.svn' -type d -exec rm -rf {} \;"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# File size
alias fs="stat -f \"%z bytes\""

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias whois="whois -h whois-servers.net"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# show what ports are open locally
alias local_ports='sudo nmap -sT -O localhost'

# Postgres
alias psqlstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias psqlstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'

# GIT
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
compdef _git gl=git-log

alias gpr='git pull --rebase'
compdef _git glr=git-pull

alias gs='git status'
compdef _git gs=git-status

alias gd='git diff'
compdef _git gd=git-diff

alias gp='git pull'
compdef _git gp=git-pull

alias gf='git fetch origin'
compdef __git gf=git-fetch

alias gps='git push'
compdef _git gps=git-push

alias gpm='git push origin master'
compdef _git gpm=git-push

alias gco='git checkout'
compdef _git gco=git-checkout

alias gb='git branch'
compdef _git gb=git-branch

alias gba='git branch -a'
compdef _git gba=git-branch

alias undopush="git push -f origin HEAD^:master" # Undo a `git push`
alias hub="open \`git config -l | grep 'remote.origin.url' | sed -En \ 's/remote.origin.url=git(@|:\/\/)github.com(:|\/)(.+)\/(.+).git/https:\/\/github.com\/\3\/\4/p'\`"
alias gitx='gitx --commit'

### FUN STARTS HERE ###

# Awesome stuff I never really use but keep because of http://xkcd.com/530/
# Grabbed from https://github.com/mathiasbynens/dotfiles
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"
alias hax="growlnotify -a 'Activity Monitor' -m 'WTF R U DOIN'"

# Fun stuff
alias starwars="telnet towel.blinkenlights.nl"

