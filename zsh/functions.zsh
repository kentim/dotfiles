# Gets password from OS X Keychain.
# $ get-pass github
function get-pass() {
  keychain="$HOME/Library/Keychains/login.keychain"
  security -q find-generic-password -g -l $@ $keychain 2>&1 |\
    awk -F\" '/password:/ {print $2}';
}

# Show how much RAM application uses.
# $ ram safari
# # => safari uses 154.69 MBs of RAM.
function ram() {
  local sum
  local items
  local app="$1"
  if [ -z "$app" ]; then
    echo "First argument - pattern to grep from processes"
  else
    sum=0
    for i in `ps aux | grep -i "$app" | grep -v "grep" | awk '{print $6}'`; do
      sum=$(($i + $sum))
    done
    sum=$(echo "scale=2; $sum / 1024.0" | bc)
    if [[ $sum != "0" ]]; then
      echo "${fg[blue]}${app}${reset_color} uses ${fg[green]}${sum}${reset_color} MBs of RAM."
    else
      echo "There are no processes with pattern '${fg[blue]}${app}${reset_color}' are running."
    fi
  fi
}

# Count code lines in some directory.
# $ loc py js css
# # => Lines of code for .py: 3781
# # => Lines of code for .js: 3354
# # => Lines of code for .css: 2970
# # => Total lines of code: 10105
function loc() {
  local total
  local firstletter
  local ext
  local lines
  total=0
  for ext in $@; do
    firstletter=$(echo $ext | cut -c1-1)
    if [[ firstletter != "." ]]; then
      ext=".$ext"
    fi
    lines=`find-exec "*$ext" cat | wc -l`
    lines=${lines// /}
    total=$(($total + $lines))
    echo "Lines of code for ${fg[blue]}$ext${reset_color}: ${fg[green]}$lines${reset_color}"
  done
  echo "${fg[blue]}Total${reset_color} lines of code: ${fg[green]}$total${reset_color}"
}


function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2\a" # plain xterm title ($3 for pwd)
    ;;
  esac
}

# Create a dir and cd into it
function mkd() {
  mkdir -p "$@" && cd "$@"
}

# Create a data-url for the specified file
function dataurl() {
  local mimeType=$(file -b --mime-type "$1")
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8"
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}"
  sleep 1 && open "http://localhost:${port}/" &
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

# create a sublime project in the current dir based on template $1
function project() {
  if test "$1" = ""; then
    echo "Please specify a project template. Available templates:"
    echo ""
    ls -1 -p "$HOME/.templates/projects/" | grep -v /
  else
    cp -f "$HOME/.templates/projects/$1.sublime-project" "./${PWD##*/}.sublime-project" && sp
  fi
}


# tail a log
function tlog() {
  if test "$1" = ""; then
    tail -f log/development.log
  else
    tail -f "log/$1.log"
  fi
}

# dump the table names to $OUT
function schema() {
  if test "$1" = ""; then
    grep 'create_table' db/schema.rb | cut -d \" -f2
  else
    sed -n "/create_table \"$1/,/^ *end *$/p" db/schema.rb
  fi
}

# track a git branch
function track_git_branch() {
  if test "`current_branch`" = ""; then
    echo 'Not in git repo.';
  else
    echo "running: git branch --set-upstream `current_branch` origin/`current_branch`";
    git branch --set-upstream `current_branch` origin/`current_branch`;
  fi
}

function rvm_unicode_symbol() {
  sym=`$HOME/.rvm/bin/rvm-prompt u`

  if [[ -n $sym ]]; then
    echo "${sym} ";
  else
    echo "";
  fi
}

# Auto feature branch script from abuijs
function feature() {
  if test "-n" = "$1"; then
    if test "" = "$2"; then
      echo "usage: feature -n feature_branch"; return 0
    elif git branch | grep -qE "^[\*[:space:]]{2}$2\s*$"; then
      echo "The branch '$2' already exists locally, choose a new name."; return 0
    fi
    git fetch && git checkout master && git pull origin master && git checkout -b "$2"
  elif test "-c" = "$1"; then
    if test "" != "$3"; then
      if ! git branch | grep -qE "^[\*[:space:]]{2}$3\s*$"; then
        git checkout -b "$3"
      else
        git checkout "$3"
      fi
    fi
    if test "" != "$2"; then
      git add --all && git commit -m "$2" && git fetch && git rebase origin/master
    else
      echo -e "Supply a commit message!\nusage: feature -c commit_message [feature_branch]"; return 0
    fi
  elif test "-p" = "$1"; then
    deploy_branch="deploy-tst"
    feature=""
    if test "$2" = "prd"; then
      deploy_branch="master"
      if test "" != "$3"; then
        feature="$3"
      fi
    elif test "" != "$2"; then
      feature="$2"
    fi
    if test "" != "$feature" && ! git branch | grep -qE "^[\*[:space:]]{2}$feature\s*$"; then
      echo -e "Branch not found!\nusage: feature -p [prd] [feature_branch]"; return 0
    elif test "" = "$feature"; then
      feature=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    fi
    echo "We're publishing the feature '$feature' to the $deploy_branch branch."
    if git fetch && git rebase -i origin/master $feature && git checkout $deploy_branch &&
       git pull origin $deploy_branch && git merge $feature && git push origin $deploy_branch && git checkout $feature; then
      echo "Succesfully published the feature '$feature'. Run 'cap deploy' to deploy this feature to the tst environment or contact SAS to deploy this feature to the acc environment."
      if test "master" = "$deploy_branch"; then
        git branch -m $feature "$feature-master"
      fi
    fi
  elif test "-d" = "$1"; then
    if test "" != "$2" && ! git branch | grep -qE "^[\*[:space:]]{2}$2\s*$"; then
      echo -e "Branch not found!\nusage: feature -d [feature_branch]"; return 0
    elif test "" != "$2"; then
      branch=$2
    else
      branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    fi
    echo -en "We're deleting both the local AND remote branch '$branch'. Are you sure?\n[yes|no] > "
    read name
    if test "yes" = "$name"; then
      git fetch && git checkout master && git branch -D "$branch"
      if git branch -a | grep -qE "^  remotes/origin/$branch\s*$"; then
        git push origin :"$branch"
      else
        echo "A remote branch '$branch' was not found, so it was not deleted."
      fi
    fi
  else
    echo -e "usage: feature -ncpd [commit_message] [tst|prd] [feature_branch]\noptions:
 -n(ew)    : create a new feature_branch based on master.
             usage: feature -n feature_branch
 -c(ommit) : commit current changes to the feature_branch, create it if it doesn't exist yet.
             usage: feature -c commit_message [feature_branch]
 -p(ublish): rebase and publish the feature_branch to the target_branch (deploy-tst if nothing is specified or master if prd is specified).
             usage: feature -p [prd] [feature_branch]
 -d(elete) : delete the feature branch both locally AND remote. Do this AFTER this feature is deployed to production.
             usage: feature -d [feature_branch]"
  fi
}
