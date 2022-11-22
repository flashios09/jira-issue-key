#!/bin/bash

set -e

function get_script_file() {
    local script_file
    script_file="$(basename "$0")"
    if [ -z "$(which "$script_file")" ]; then
        script_file="./$script_file"
    fi
    echo "$script_file"
}

# Constants:
SCRIPT_FILE="$(get_script_file)"
SCRIPT_VERSION="0.1.3-alpha.1"
SCRIPT_DESCRIPTION="Extract the Jira Issue Key(e.g. \`GWT-1\`) from current git branch name(e.g. \`GWT-1-ci-cd-tests\`), jik v$SCRIPT_VERSION"

# options
sed_regex='s/[a-z_]*\/*([A-Z]+-[0-9]+).*/\1/p'

function cat_help_message() {
    cat <<EOF
$SCRIPT_DESCRIPTION

Usage:
  $SCRIPT_FILE [OPTIONS]         execute the script with the specified options
  $SCRIPT_FILE -h|--help         display this output
  $SCRIPT_FILE -v|--version      display the script version

Options:
  --sed-regex|-E <regex>        the sed regex expression used to extract the jira issue key from branch name
                                (default sed regex '$sed_regex')
                                e.g. $SCRIPT_FILE -E '$sed_regex'

Examples of git branch names(captured with default sed regex expression):
- \`GWT-1-ci-cd\`
- \`feature/GWT-1-ci-cd\`
- \`hotfix/GWT-1-ci-cd\`
- \`bugfix/GWT-1-ci-cd\`
- \`any_branch_prefix/GWT-1-ci-cd\`

--> jik will always return \`GWT-1\`.
EOF
}

# Display the help or version message and exit with 0;
if [ $# -eq 1 ]; then
    case $1 in
    --version | -v)
        echo "$SCRIPT_DESCRIPTION"
        exit
        ;;
    --help | -h)
        cat_help_message
        exit
        ;;
    esac
fi

# Parse the passed arguments and intialiaze/mutate some variables
# Will display an error for invalid option(s)
while [[ $# -gt 0 ]]; do
    case $1 in
    --sed-regex | -E)
        shift # remove `--sed-regex` or `-E` from `$#`
        sed_regex_option="$1"
        if [ -z "$sed_regex_option" ]; then
            echo " ✘ Missing the sed regex expression, e.g. $sed_regex !"
            exit 1
        fi
        sed_regex="$sed_regex_option"
        shift # remove `sed_regex_option` from `$#`
        ;;
    -*)
        echo " ✘ Invalid option \`$1\` !"
        exit 1
        ;;
    esac
done

git rev-parse --abbrev-ref HEAD | sed -nE "$sed_regex"
