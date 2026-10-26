# rwedev: ideas and roadmap

`rwedev` (in [`rwedev/`](../rwedev)) is the R package that creates, checks and updates packages against the RWE ecosystem standards. This page collects the ideas worth pursuing for it, including those already (partly) implemented, so the scope is agreed before the code grows.

Status: **done**, **partial** (exists but needs work), **parked** (written, then set aside for now; not in the package) or **idea** (not started).

## 1. Principles

| Principle                                                                                                   | Why                                                                                                                                                                                                          |
| ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Development use only.** Never in the `Imports` of a domain package, like devtools.                        | Otherwise every package pulls in tools it doesn't need (the picard problem). Runtime helpers (logging setup, `assert_has_columns()`, the SQL runner) belong in a core package instead.                       |
| **One source of truth for templates:** [`templates/r-package/`](../templates/r-package) in this repository. | rwedev does not ship its own copy. It fetches the templates from GitHub at the standards tag (e.g. `v2`), as `code_quality.yaml` already does for `air.toml`. Copies drift.                                  |
| **Standards version = workflow major tag.**                                                                 | A package declares `Config/rwe/standards: v2` and calls the workflows `@v2`; both mean the same rules. rwedev has its own version (`0.0.0.9000`, then `0.1.0`, ...) and records changes in `rwedev/NEWS.md`. |
| **Checking never writes; installing says what it did.**                                                     | Safe to run the check in CI and on someone else's package.                                                                                                                                                   |
| **Light dependencies.** `cli`, `usethis`, `gh` are fine; nothing heavier.                                   | It is installed on every developer's machine.                                                                                                                                                                |

## 2. Core: create, check, install

| Function                    | What it does                                                        | Writes?         | Status     |
| --------------------------- | ------------------------------------------------------------------- | --------------- | ---------- |
| `check_rwe_standards(path)` | Report of pass / warn / fail / skip per check; `fail = TRUE` for CI | never           | **parked** |
| `use_rwe_standards(path)`   | Install the RWE configuration files into an existing package        | yes             | **idea**   |
| `create_rwe_package(path)`  | `usethis::create_package()` followed by `use_rwe_standards()`       | yes, new folder | **idea**   |

### 2.1 `check_rwe_standards()`

Parked. The first version checked DESCRIPTION, required files, managed files, tests, hygiene, code rules and release tags. To bring it to standards `v2`:

- **Managed:** `air.toml` identical to `templates/r-package/managed/` at the tag.
- **Starter:** `.lintr`, `.gitignore`, `.Rbuildignore` exist and contain the required lines (e.g. `^air\.toml$`), instead of being identical.
- **CI:** `ci.yaml` calls the four shared workflows at `@v2`, instead of being identical to a template (packages are meant to change its `with:` inputs).
- Read templates from the shared fetcher (section 2.4), not `inst/templates/`.

### 2.2 `use_rwe_standards()`

To be defined.

### 2.3 `create_rwe_package()`

Thin wrapper, so new and existing packages get their files the same way. Fills `PACKAGE` in the starter files and sets `Authors@R` with one `cre`.

### 2.4 Template fetcher (internal)

One function used by all of the above: downloads a template from `UMC-Utrecht-RWE/rwe-ecosystem` at the standards tag, caches it for the session, and fails with a clear message when offline.

## 3. Keeping packages up to date

| Idea                          | What it does                                                                                                                        | Status   |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | -------- |
| `update_rwe_managed()`        | Refresh `air.toml` (and future managed files) from the tag                                                                          | **idea** |
| `migrate_rwe_standards("v3")` | Automate the migration steps listed in [`CHANGELOG.md`](../CHANGELOG.md) for a major release, then print what is left to do by hand | **idea** |

## 4.The ecosystem as a whole

These read [`catalogue/packages.yml`](../catalogue/packages.yml) and
[`catalogue/maintainers.yml`](../catalogue/maintainers.yml), so they wait until
the catalogue is filled in.

| Idea                | What it does                                                            | Status   |
| ------------------- | ----------------------------------------------------------------------- | -------- |
| CODEOWNERS          | Generate each package's CODEOWNERS from the catalogue                   | **idea** |
| Ecosystem status    | Which standards version each package follows, and its last check result | **idea** |
| Dependency map      | Which ecosystem packages depend on which                                | **idea** |
| rwedev not imported | Flag any package with rwedev in `Imports`                               | **idea** |

## 5. rwedev itself

| Item                                                                                                                                  | Status                                                                                                                                 |
| ------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| Follows the standards (`Config/rwe/standards: v2`, managed `air.toml`)                                                                | **done**                                                                                                                               |
| CI: [`rwedev.yaml`](../.github/workflows/rwedev.yaml) runs the shared workflows from the same commit with `working-directory: rwedev` | **done**                                                                                                                               |
| Release tags with a prefix, e.g. `rwedev-v0.1.0`, because `v1`/`v2` in this repository are the workflow tags                          | **idea**                                                                                                                               |
| pkgdown site                                                                                                                          | **idea** (would need a `working-directory` input on `pkgdown.yaml` and somewhere to publish that isn't this repository's GitHub Pages) |
| Install instructions: `pak::pak("UMC-Utrecht-RWE/rwe-ecosystem/rwedev")` in the README                                                | **done**                                                                                                                               |
