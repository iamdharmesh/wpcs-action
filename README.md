# WPCS GitHub Action

>  GitHub Action to help you lint your PHP without additional dependencies within your codebase 

[![Support Level](https://img.shields.io/badge/support-active-green.svg)](#support-level) [![Release Version](https://img.shields.io/github/release/10up/wpcs-action.svg)](https://github.com/10up/wpcs-action/releases/latest) [![MIT License](https://img.shields.io/github/license/10up/wpcs-action.svg)](https://github.com/10up/wpcs-action/blob/develop/LICENSE)

This action will help you to run phpcs (PHP_CodeSniffer) against [WordPress Coding Standards](https://github.com/WordPress/WordPress-Coding-Standards) with [GitHub Actions](https://github.com/features/actions) platform.

To make it as simple as possible, this action supports WordPress Coding Standards exclusively and only checks for PHP files. This action doesn't require any change or addition to your source code. It means that you don't need to add composer/phpcs to your plugin or create PHP CodeSniffer config to use this action.

This is a fork of [chekalsky/phpcs-action](https://github.com/chekalsky/phpcs-action), so this action supports GitHub Action annotations too. All credit goes to 
[Ilya Chekalsky](https://github.com/chekalsky).

From v1.3.1, this action can detect the PHPCS custom config and use that config to check the source code. When using the local config, `paths`, `excludes`, and `standard` are ignored.

### ☞ Check out our [collection of WordPress-focused GitHub Actions](https://github.com/10up/actions-wordpress)

## Known Caveats/Issues

### Annotations limit

GitHub allows only 10 warning annotations and 10 error annotations per step. So any warning/error exceeds this threshold won't show on the GitHub Pull Request page.

## Usage

Add the following code to `.github/workflows/wpcs.yml` file.

```yaml
name: WPCS check

on: pull_request

jobs:
  phpcs:
      name: WPCS
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v2
        - name: WPCS check
          uses: 10up/wpcs-action@stable
```

Available options (with default value):

```yaml
        ...
        - name: WPCS check
          uses: 10up/wpcs-action@stable
          with:
            enable_warnings: false # Enable checking for warnings (-w)
            paths: '.' # Paths to check, space separated
            excludes: '' # Paths to excludes, space separated
            standard: 'WordPress' # Standard to use. Accepts WordPress|WordPress-Core|WordPress-Docs|WordPress-Extra|WordPress-VIP-Go|WordPressVIPMinimum.
            standard_repo: '' # Public (git) repository URL of the coding standard
            repo_branch: 'master' # Branch of Standard repository
            phpcs_bin_path: 'phpcs' # Custom PHPCS bin path
            use_local_config: 'false' # Use local config if available
            extra_args: '' # Extra arguments passing to the command
```

## Examples

### VIP Coding Standards

```yaml
name: WPCS check

on: pull_request

jobs:
  phpcs:
      name: VIPCS
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v2
        - name: VIPCS check
          uses: 10up/wpcs-action@stable
          with:
            standard: 'WordPress-VIP-Go'
```
### Display the linting result in the GitHub Actions summary

```yaml
name: WPCS check

on: pull_request

jobs:
  phpcs:
      name: VIPCS
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v2
        - name: VIPCS check
          uses: 10up/wpcs-action@stable
          with:
            standard: 'WordPress-VIP-Go'
            extra_args: '--report-json=./phpcs.json'
        - name: Update summary
          run: |
            npx --yes github:10up/phpcs-json-to-md --path ./phpcs.json --output ./phpcs.md
            cat phpcs.md >> $GITHUB_STEP_SUMMARY
          if: always()
```

## Support Level

**Active:** 10up is actively working on this, and we expect to continue work for the foreseeable future including keeping tested up to the most recent version of WordPress.  Bug reports, feature requests, questions, and pull requests are welcome.

## Like what you see?

<p align="center">
<a href="http://10up.com/contact/"><img src="https://10up.com/uploads/2016/10/10up-Github-Banner.png" width="850"></a>
</p>
