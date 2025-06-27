#!/usr/bin/env bash

source "$(echo $0 | xargs realpath | xargs dirname)/globals.sh"


validate-action () {
  if ! is-valid-action "$1"; then
    echo "Given action '$1' is not valid, use one of ['', 'config', 'hooks']."
    exit $LINENO
  fi
}

validate-xsv-installed () {
  if ! command -v xsv &> /dev/null; then
    echo 'You must install "xsv" to use this script.'
    exit 1
  fi
}

process-config () {
  local existing_value
  local config_name="$1"
  local default_value="$2"
  local required="$3"
  local description="$4"

  existing_value="$(cfg-get "$config_name" || echo '')"

  if [ -n "$existing_value" ]; then
    default="$existing_value"
  else
    default="$default_value"
  fi

  local prompt_text="${description}$([ -n "$default" ] && echo " ['$default']"): "

  read -r -p "$prompt_text" user_value

  if [ -n "$default" ] && [ -z "$user_value" ]; then
    user_value="$default"
  fi

  while [ "$required" == "true" ] && [ -z "$user_value" ]; do
    echo "Please provide a value."
    echo ""
    IFS= read -r -p "$prompt_text" user_value
  done
  
  cfg-set "$config_name" "$user_value"

  echo ""
}

process-hook () {
  local hook_name="$1"
  local hooks_src="${src}/hooks"
  local hooks_dst="$(realpath ./.git/hooks)"

  if [ -n "$2" ]; then
    hooks_src="$2"
  fi

  echo "Processing hook: '${hooks_src}/${hook_name}.sh' -> '${hooks_dst}/${hook_name}'"

  if [ -L "${hooks_dst}/${hook_name}" ]; then
    echo "Hook appears to be installed."
    return 0
  fi

  if ! ln -s "${hooks_src}/${hook_name}.sh" "${hooks_dst}/${hook_name}"; then
    echo "Failed to create symlink."
    return 1
  fi

  echo "Installed."
  echo ""

  return 0
}

repo-config-setup () {
  #              category.key                   default    required  help text
  process-config 'user.name'                    ''         true      'Name of the developer'
  process-config 'user.email'                   ''         true      'Email of the developer'
  process-config 'user.signingkey'              ''         false     'GPG key for signing commits'
  process-config 'project.developbranch'        'develop'  true      'Branch of type "develop"'
  process-config 'project.masterbranch'         'master'   true      'Branch of type "master"'
  process-config 'project.commitprefix'         ''         false     'Prefix for commit messages e.g. "[ABC-{ticketid}]"'
  process-config 'project.featurebranchfrom'    'develop'  true      'Branch type from which to create feature branches (master,develop)'
  process-config 'project.featurebranchformat'  ''         true      'Naming format for feature branches e.g. "feature/ABC-{ticketid}"'
  process-config 'project.bugfixbranchformat'   ''         true      'Naming format for bugfix branches e.g. "bugfix/ABC-{ticketid}"'
  process-config 'project.bugfixbranchfrom'     'develop'  true      'Branch type from which to create bugfix branches (master,develop)'
  process-config 'project.hotfixbranchformat'   ''         true      'Naming format for hotfix branches e.g. "hotfix/ABC-{ticketid}"'
  process-config 'project.hotfixbranchfrom'     'master'   true      'Branch type from which to create hotfix branches (master,develop)'
}

repo-hooks-setup () {
  process-hook 'prepare-commit-message'
}

perform=''

if [ -n "$1" ]; then
  perform="$1"
fi

validate-action "$perform"
validate-xsv-installed
[ "$perform" != 'hooks' ]  && repo-config-setup
[ "$perform" != 'config' ] && repo-hooks-setup