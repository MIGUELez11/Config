#!/bin/bash

prefix=""
suffix=""
separator="-"
publish=0
deleteLocal=0
deleteRemote=0

print_instructions() {
  echo "--- Create a git tag ---"
  echo
  echo "--- Options"
  echo "-p The prefix you want to add"
  echo "-s The suffix you want to add"
  echo "-S The separator you want to use"
  echo "-P Create the tag and publish"
  echo "-d Delete all previous local tags of the same type"
  echo "-D Delete all previous remote tags of the same type"
  echo "-h Shows this help screen"
  echo
  echo "Example: prefix-1.0.0-suffix"
  echo
  echo "--- Made by MIGUELez11 ---"
  exit 0
}

# To get script execution params run:
# get_opts $@
get_opts() {
  while getopts 'p:s:S:PdDh' flag; do
    case "${flag}" in
    p) prefix="${OPTARG}" ;;
    s) suffix="${OPTARG}" ;;
    S) separator="${OPTARG}" ;;
    P) publish=1 ;;
    d) deleteLocal=1 ;;
    D) deleteRemote=1 ;;
    h) print_instructions ;;
    esac
  done
}
get_tag_pattern() {
  tagPattern=""
  if [ ! -z "$prefix" ]; then
    tagPattern+="$prefix$separator"
  fi

  tagPattern+="*.*.*"

  if [ ! -z "$suffix" ]; then
    tagPattern+="$separator$suffix"
  fi

  echo "$tagPattern"
}

get_latest_tag() {
  git fetch --tags 2>/dev/null
  tagPattern=$(get_tag_pattern)
  git tag --sort=version:refname -l "$tagPattern" | tail -n 1
}

# This function needs a tag to be provided as call params
print_tag_found() {
  if [ -z $@ ]; then
    echo "No tag with the given options were found"
  else
    echo "The latest tag found is $@"
  fi
  echo
}

# This function needs the new tag to be provided as call params
print_continue_message() {
  new_tag="${@:1:1}"
  latest_tag="${@:2:2}"

  if [ -z "$latest_tag" ]; then
    echo "- A new tag set will be created starting with $new_tag."
  else
    echo "- The tag will be upgraded to patch version $new_tag."
  fi

  if [ $deleteLocal == 1 ]; then
    echo "- All local tags matching the pattern will be removed."
  fi
  if [ $deleteRemote == 1 ]; then
    echo "- All remote tags matching the pattern will be removed."
  fi
  if [ $publish == 1 ]; then
    echo "- This tag will be published to github"
  fi

  read -p "Do you want to continue? (Y/n): " answer

  answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

  if [[ ! "$answer" == "y" ]]; then
    echo
    echo "No tag was created"
    exit 1
  fi
}

# This function needs a tag to be provided as call params
get_tag_next_number() {
  tagNumber=$(echo "$@" | sed -e "s/^$prefix$separator//" -e "s/$separator$suffix$//")

  major=$(echo "$tagNumber" | cut -d "." -f 1)
  minor=$(echo "$tagNumber" | cut -d "." -f 2)
  patch=$(($(echo "$tagNumber" | cut -d "." -f 3) + 1))

  echo "$major.$minor.$patch"
}

# This function needs a tag to be provided as call params
get_next_tag() {
  tag=""
  if [ ! -z "$prefix" ]; then
    tag+="$prefix$separator"
  fi

  if [ -z $@ ]; then
    tag+="0.0.1"
  else
    tag+=$(get_tag_next_number $@)
  fi
  if [ ! -z "$suffix" ]; then
    tag+="$separator$suffix"
  fi

  echo "$tag"
}

delete_local_tags() {
  if [ $deleteLocal == 1 ]; then
    tagPattern=$(get_tag_pattern)

    tags=$(git tag -l "$tagPattern")
    git tag -d "$tags"
  fi
}

delete_remote_tags() {
  if [ $deleteRemote == 1 ]; then
    tagPattern=$(get_tag_pattern)

    tags=$(git tag -l "$tagPattern")
    git push origin -d "$tags"
  fi
}

create_tag() {
  git tag "$@"
}

publish_tag() {
  if [ $publish == 1 ]; then
    git push origin $@
  fi
}

get_opts $@

latest_tag=$(get_latest_tag)
print_tag_found "$latest_tag"
new_tag=$(get_next_tag "$latest_tag")
print_continue_message "$new_tag" "$latest_tag"

delete_remote_tags
delete_local_tags

create_tag "$new_tag"
publish_tag "$new_tag"
