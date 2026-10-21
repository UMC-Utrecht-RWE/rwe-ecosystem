# Changelog

All notable changes to the shared workflows and templates are documented here.
Versions follow semantic versioning; see docs/shared-workflows.md.

## [Unreleased]
### Added
- Starter `.Rbuildignore` excluding the files the ecosystem adds to a package
  (`.github`, `.lintr`, `air.toml`, `.covrignore`, `.pre-commit-config.yaml`,
  `.git-blame-ignore-revs`, `CHANGELOG.md`) plus common editor and pkgdown
  files. Merge it into a package's existing `.Rbuildignore`; keep the
  package-specific entries.
- Starter `.gitignore`: R session files, secrets (`.Renviron`), build/check
  output, pkgdown `docs/`, built vignettes, logs and `.DS_Store`. Ignores
  `.vscode/` except the shared `settings.json` and `extensions.json`.
- Starter `.vscode/settings.json` (Air as R formatter, format on save) and
  `.vscode/extensions.json` (recommends the Air and R extensions).
- Starter `.github/pull_request_template.md` with a checklist: NEWS entry,
  Air, `devtools::document()`, tests, check.
- Starter `_pkgdown.yml` (site URL, Bootstrap 5).
- Starter `NEWS.md`. Packages record changes in `NEWS.md`, which pkgdown
  turns into the site's Changelog page.

### Fixed
- `docs/shared-workflows.md` pointed to a non-existent `NEWS.md`; it now
  points to this `CHANGELOG.md`.

## [2.0.1] - 2026-10-21
### Fixed
- `templates/` and `docs/` were missing from the `v2.0.0` tag, so the
  `air.toml` check in `code_quality.yaml` failed with a 404 when downloading
  `templates/r-package/managed/air.toml`.

## [2.0.0] - 2026-10-21
### Added
- This `CHANGELOG`.
- Managed `air.toml` (Air formatter settings) in `templates/r-package/managed/`,
  and a starter `.lintr` template.
- `code_quality.yaml` fails if the package's `air.toml` is missing or differs
  from `templates/r-package/managed/air.toml` at `v2`. Changing the managed
  `air.toml` is therefore a breaking change (major release).

### Changed
- **Breaking:** `code_quality.yaml` checks formatting with
  [Air](https://posit-dev.github.io/air/) (`air format . --check`) instead of
  `styler::style_pkg()`. styler could produce lines longer than lintr allows
  (e.g. R6 `initialize` signatures), so the two checks contradicted each other.
  Air owns layout and respects the line width; lintr now only checks non-layout
  rules.
- The starter `.pre-commit-config.yaml` uses the Air hook instead of styler's
  `style-files`.

### Migrating a package from `@v1` to `@v2`
1. Install Air: <https://posit-dev.github.io/air/cli.html>, or the extension
   for VS Code / Positron / RStudio.
2. Copy `air.toml` from `templates/r-package/managed/` into the package root,
   unchanged (CI checks it), and add `^air\.toml$` to `.Rbuildignore`.
3. Update `.lintr` to match the starter template (drops `indentation_linter`,
   allows long lines in `tests/testthat`). Keep any package-specific settings.
4. Remove `# styler: off` / `# styler: on` markers.
5. Move trailing `# nolint` comments that follow an opening `(` or `{` to the
   line above as `# nolint next` (Air moves them, and they then stop working).
   Delete `# nolint: line_length_linter.` on `test_that()` lines.
6. Run `air format .` until `air format . --check` passes (occasionally it
   takes two passes), then run `lintr::lint_package()`.
7. Commit the reformat on its own and add its SHA to `.git-blame-ignore-revs`,
   so `git blame` skips it.
8. Change `@v1` to `@v2` in `.github/workflows/ci.yaml` and, if used, replace
   `.pre-commit-config.yaml` with the starter version.

## [1.0.0] - 2026-10-20
### Added
- Reusable workflows: r_cmd_check, code_quality, test_coverage, pkgdown.
- Starter ci.yaml template for packages.
