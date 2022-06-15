# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.3.4] - 2022-06-14
### Added 
- `EXTRA_ARGS` flag to support custom arguments (props [@dinhtungdu](https://github.com/dinhtungdu) via [#12](https://github.com/10up/wpcs-action/pull/12)).

## [1.3.3] - 2022-04-12
### Fixed
- Wrong branch used in examples.
- Docs: Update supported standards.

## [1.3.2] - 2021-07-13
### Fixed
- VIPCS detection issue.

## [1.3.1] - 2021-06-29
### Added
- Detect local phpcs config. This is disabled by default. Enable it by setting `use_local_config` to 'true'.
- `phpcs_bin_path` option to use local PHPCS.

### Removed
- `is_vipcs` option. From this version, `wpcs-action` checks against VIPCS automatically if the `standard` option set to `WordPress-VIP-Go` or `WordPressVIPMinimum`.

## [1.3.0] - 2021-06-29
### Added
- Support WordPress Coding Standard exclusively.
- Support Custom Standards.
- Support VIPCS. Enable VIPCS check by using `is_vipcs` options.

### Removed
- `phpcs_bin_path` and `installed_paths` options.

[Unreleased]: https://github.com/10up/wpcs-action/compare/stable...develop
[1.3.4]: https://github.com/10up/wpcs-action/compare/v1.3.3...v1.3.4
[1.3.3]: https://github.com/10up/wpcs-action/compare/v1.3.2...v1.3.3
[1.3.2]: https://github.com/10up/wpcs-action/compare/v1.3.1...v1.3.2
[1.3.1]: https://github.com/10up/wpcs-action/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/10up/wpcs-action/compare/v1.2.0...v1.3.0
