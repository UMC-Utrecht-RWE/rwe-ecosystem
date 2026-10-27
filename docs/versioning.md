# Versioning in rwe-ecosystem

This repository contains two elements that are released separately, so they have two version numbers.

## 1. The two version numbers
There is a version system for `rwe-ecosystem` and one for the internal package `rwedev`.
|                 | Ecosystem version                                          | rwedev version                                                                                  |
| --------------- | ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **Covers**      | shared workflows, `templates/`, `docs/`: the RWE standards | the `rwedev` R package in `rwedev/`                                                             |
| **Example**     | `v2.0.1` (fixed tag), `v2` (moving major tag)              | `0.0.0.9000`                                                                                    |
| **Recorded in** | git tags, [`CHANGELOG.md`](../CHANGELOG.md)                | [`rwedev/DESCRIPTION`](../rwedev/DESCRIPTION) `Version:`, [`rwedev/NEWS.md`](../rwedev/NEWS.md) |
| **Rules**       | [semantic versioning](https://semver.org)                  | R package conventions (`.9000` = development version)                                           |

They are independent: an ecosystem release does not require an `rwedev` release, and `rwedev` can be released without a new ecosystem version.

The one link between them: the **major** ecosystem version is also the **standards version** (`v2`). A package that calls the workflows `@v2` follows standards `v2`, and `rwedev` records which standards version it implements.

## 2. Where the major version is written by hand

The major version (`v2`) is typed into these files. **Nothing checks that they agree**, so on a **major** release every one of them must be updated together.

| File                                                                                                                | What it says                             | Why it matters                                                                             |
| ------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------ |
| [`.github/workflows/code_quality.yaml`](../.github/workflows/code_quality.yaml)                                     | `ECOSYSTEM_REF: v2`                      | the tag CI downloads the managed `air.toml` from. Packages' copies are compared against it |
| [`templates/r-package/starter/.github/workflows/ci.yaml`](../templates/r-package/starter/.github/workflows/ci.yaml) | `@v2` (four lines)                       | the version new packages start on                                                          |
| [`rwedev/DESCRIPTION`](../rwedev/DESCRIPTION)                                                                       | `Config/rwe/standards: v2`               | the standards rwedev itself follows                                                        |
| [`rwedev/R/rwedev-package.R`](../rwedev/R/rwedev-package.R)                                                         | `rwe_standards_version()` returns `"v2"` | the standards this rwedev release implements                                               |
| [`rwedev/README.md`](../rwedev/README.md)                                                                           | example output `"v2"`                    | generated from `README.Rmd`: re-render it after changing the function                      |
| [`rwedev/air.toml`](../rwedev/air.toml)                                                                             | copy of the managed `air.toml`           | must equal the managed file at the new tag, or rwedev's CI fails                           |

Find every occurrence before a major release with:

```bash
git grep -nw 'v2' -- .github templates rwedev ':!rwedev/man' | grep -v 'r-lib/actions'
```

(`r-lib/actions/...@v2` is the version of an external action, not ours.)

## 3. Why `ECOSYSTEM_REF` is pinned to a tag

`code_quality.yaml` checks each package's `air.toml` against the managed copy at `ECOSYSTEM_REF`. It points at the moving major tag, not at `main`, so:

- **packages change only when they choose to.** A package on `@v2` has the   `v2` `air.toml`. Editing the managed file on `main` does not break it.
- **unreleased work stays unreleased.** A merged change reaches packages only when it is tagged.
- **a re-run gives the same result.** A commit that passed CI keeps passing.

Two consequences:

- `ECOSYSTEM_REF` is not taken from the `@v2` the package calls. It is fixed in  the workflow file and must be bumped by hand with the major version.
- It reads from a tag, so it must not name a tag that does not exist yet (the download fails with a 404, as happened before `v2.0.1`). Set it to `v3` in the same commit that is tagged `v3.0.0` and `v3`.

## 4. Major release checklist (example: v2 → v3)

1. **Decide what goes in.** Commits already on `main` but not yet tagged are released with the major version. If packages on `@v2` should get them, first release them as a minor or patch version (`v2.1.0`) and move `v2`.
2. **Make the breaking change** in a pull request, e.g. the new settings in  `templates/r-package/managed/air.toml`.
3. **In the same pull request, update every file in section 2:**
   - `ECOSYSTEM_REF: v3` in `code_quality.yaml`
   - `@v3` in the starter `ci.yaml`
   - `rwedev/air.toml` replaced by the new managed `air.toml`
   - `Config/rwe/standards: v3` in `rwedev/DESCRIPTION`
   - `"v3"` in `rwe_standards_version()` and its `@return` example; run
     `devtools::document()` and re-render `rwedev/README.Rmd` into `README.md`
4. **Changelogs.**
   - `CHANGELOG.md`: a `[3.0.0]` section with the change under **Breaking**,
     and what packages must do to migrate (e.g. "replace `air.toml`, then run
     `air format .`").
   - `rwedev/NEWS.md`: a bullet saying rwedev now follows standards `v3`. Bump
     rwedev's own version only if you are also releasing rwedev.
5. **Merge, then tag** the merge commit (`shared-workflows.md` section 6.3):
   ```bash
   git switch main && git pull
   git tag v3.0.0
   git tag v3
   git push origin v3.0.0 v3
   ```
   Do **not** move `v2`. Packages still on `@v2` keep working.
6. **Check rwedev's CI** on `main` passes: it now downloads `air.toml` at `v3`.
7. **Migrate each package** in its own pull request: `@v2` → `@v3` in `ci.yaml`, `Config/rwe/standards: v3` in DESCRIPTION, the new `air.toml`, and whatever reformatting `air format .` produces.

Between merging (step 4) and pushing the tags, `main` refers to a `v3` tag that does not exist yet, so rwedev's code-quality check fails. Push the tags straight after merging.

## 5. Releasing rwedev

Independent of the above: bump `Version:` in `rwedev/DESCRIPTION` and add a
section to `rwedev/NEWS.md`. rwedev releases do not get `vX` tags, since
those belong to the workflows (prefixed tags such as `rwedev-v0.1.0` are an
open idea in [`rwedev.md`](rwedev.md)).
