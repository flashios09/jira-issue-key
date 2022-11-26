# Jira Issue Key

<p align="center">
    <a href="https://github.com/flashios09/jira-issue-key/actions/workflows/ci.yml" target="_blank">
        <img src="https://github.com/flashios09/jira-issue-key/actions/workflows/ci.yml/badge.svg" alt="CI Status">
    </a>
    <a href="https://github.com/flashios09/jira-issue-key/releases/latest" target="_blank">
        <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/flashios09/jira-issue-key">
    </a>
</p>

Extract the [Jira Issue Key](https://support.atlassian.com/jira-software-cloud/docs/what-is-an-issue/)(e.g. `GWT-1`) from current git branch name(e.g. `GWT-1-ci-cd-tests`).

## Installation
```bash
# Clone the repo
git clone https://github.com/flashios09/jira-issue-key.git
# CD to `jira-issue-key` folder
cd jira-issue-key
# Make `script.sh` executable
chmod +x ./script.sh
# Create a symlink inside a bin dir, e.g. `/usr/local/bin`(must be in your path)
ln -s "$PWD/script.sh" /usr/local/bin/jik
# Check jik is installed, must output `/usr/local/bin/jik` !
which jik
```

## Usage
```bash
jik [OPTIONS]               execute the script with the specified options
jik -h|--help               display this output
jik -v|--version            display the script version
```
## Options:
```bash
--sed-regex|-E <regex>      the sed regex expression used to extract the jira issue key from branch name
                            (default sed regex 's/[a-z_]*\/*([A-Z]+-[0-9]+).*/\1/p')
                            e.g. jik -E 's/[a-z_]*\/*([A-Z]+-[0-9]+).*/\1/p'
```

## Examples of git branch names*
- `GWT-1-ci-cd`
- `feature/GWT-1-ci-cd`
- `hotfix/GWT-1-ci-cd`
- `bugfix/GWT-1-ci-cd`
- `any_branch_prefix/GWT-1-ci-cd`

-> **jik** will always return `GWT-1`.

Check the [ci.yml github action](.github/workflows/ci.yml) for more examples and tests.

*captured with default sed regex expression

## Using with git commit
```bash
# bash, zsh
git commit -m "$(jik) The commit message here ..."
# fish
JIRA_ISSUE_KEY=(jik) git commit -m "$JIRA_ISSUE_KEY The commit message here ..."
```
### Abbr for fish:
Just add a `gcm` **abbr** to your `~/.config/fish/config.fish` file:
```bash
if status is-interactive
    # your abbr(s)
    # ...
    abbr --add gcm 'JIRA_ISSUE_KEY=(jik) git commit -m "$JIRA_ISSUE_KEY'
end
```
**Source** your `~/.config/fish/config.fish` file after adding the `gcm` **abbr**:
```bash
source ~/.config/fish/config.fish
```
Now just type `gcm ` and it will be expanded to `JIRA_ISSUE_KEY=(jik) git commit -m "$JIRA_ISSUE_KEY `.

## Contributing
Just clone or fork the repository :)

We are using [shellcheck](https://github.com/koalaman/shellcheck) as script analysis tool and [shfmt](https://github.com/patrickvane/shfmt) for script formatting.

### Linting:
```bash
# used on `ci.yml` github action
shellcheck ./script.sh
shfmt -i 4 -d ./script.sh
```

## License
 This project is licensed under the [MIT License](LICENSE.md).
