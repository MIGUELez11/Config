#!/bin/bash

remoteDB="leemons-ecs"
hostname="leemons-db"
leemonsPath="$HOME/Desktop/projects/Leemons/leemons"
serverPath="/leemons"

dbHost="localhost"
dbPort="3306"
dbUser="leemons"
dbPassword="leemons"

mode="remote"

print_instructions() {
  echo "--- Leemons Restore DB ---"
  echo
  echo "--- Database options"
  echo "-r Specify the database to use (Same for local and remote, also file name)"
  echo "-h Specify the database host (Should be saved at .ssh/config as a tunnel bridge will be opened)"
  echo
  echo "--- Mode selector"
  echo "Default mode is download and load database from remote (requires -r)"
  echo "-l Load database from local file (requires -r)"
  echo "-b Do a backup of local database (required -r to get database), saved on localBackup.sql"
  echo "-d Downloads remote database (requires -r)"
  echo
  echo "--- Made by MIGUELez11 insipired on johan-fx script ---"
  exit 0
}

# To get script execution params run:
# get_opts $@
get_opts() {
  while getopts 'r:H:p:P:lbdh' flag; do
    case "${flag}" in
    r) remoteDB="${OPTARG}" ;;
    H) hostname="${OPTARG}" ;;
    p) serverPath="${OPTARG}" ;;
    P) leemonsPath="${OPTARG}" ;;
    l) mode="local" ;;
    b) mode="backup" ;;
    d) mode="download" ;;
    h) print_instructions ;;
    esac
  done
}

get_remote_dump_file() {
  dbUser="leemons"
  dbPass="leemons"

  ssh $hostname "mysqldump -u ${dbUser} --password='${dbPass}' $remoteDB" >./$remoteDB.sql

  installation_replacer="
UPDATE \`models::plugins\` SET path = REPLACE(path, '$serverPath/', '$leemonsPath/') WHERE path LIKE '$serverPath/%%';
UPDATE \`models::providers\` SET path = REPLACE(path, '$serverPath/', '$leemonsPath/') WHERE path LIKE '$serverPath/%%';
  "

  echo $installation_replacer >>./$remoteDB.sql

  printf "✅ Remote database '$remoteDB' downloaded to ./$remoteDB.sql\n"
}

get_local_dump_file() {
  dbUser="leemons"
  dbPass="leemons"

  eval mysqldump --host=127.0.0.1 -u ${dbUser} --password='${dbPass}' ${remoteDB} >./localBackup.sql

  printf "✅ Local database '$remoteDB' downloaded to ./localBackup.sql\n"

}

save_database() {
  query="
    DROP DATABASE IF EXISTS \`$remoteDB\`;
    CREATE DATABASE \`$remoteDB\`  DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    USE \`$remoteDB\`;
    source $remoteDB.sql;
  "

  mysql -h $dbHost -P $dbPort -u $dbUser --password="$dbPassword" -e "$query"

  printf "✅ Database imported to $dbHost:$dbPort as $remoteDB\n"
}

remove_dump_file() {
  rm -f ./$remoteDB.sql
}

local_mode() {
  save_database
}

remove_mode() {
  remove_dump_file
  get_remote_dump_file
  save_database
}

backup_mode() {
  get_local_dump_file
}

download_mode() {
  remove_dump_file
  get_remote_dump_file
}

get_opts $@

if [ $mode == "remote" ]; then
  echo
  remove_mode
elif [ $mode == "local" ]; then
  echo
  local_mode
elif [ $mode == "backup" ]; then
  echo
  backup_mode
elif [ $mode == "download" ]; then
  echo
  download_mode
fi
