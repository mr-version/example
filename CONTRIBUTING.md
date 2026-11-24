# Contributing Guidelines

This example repository demonstrates best practices for using Mr. Version. When adapting this for your own projects:

## Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New features (triggers minor version bump)
- `fix:` - Bug fixes (triggers patch version bump)
- `docs:` - Documentation changes (no version bump)
- `style:` - Code style changes (no version bump)
- `refactor:` - Code refactoring (triggers patch version bump)
- `test:` - Test changes (no version bump)
- `chore:` - Build/tooling changes (no version bump)
- `BREAKING CHANGE:` footer or `!` after the type (e.g. `feat!:`) - Breaking changes (triggers major version bump)

These patterns are configured under `commitConventions` in `mr-version.yml`.

## Branch Strategy

- `main` - Production releases (final versions, tagged by CI)
- `develop` - Development branch (`-dev.<height>` prereleases)
- `feature/*` - Feature branches (prereleases named after the branch)
- `release/*` - Release stabilisation (final versions within the branch's major.minor, e.g. `release/1.1`)
- `hotfix/*` - Hot fixes for production (prereleases named after the branch)

## Version Flow Example

Starting from the tag `v1.0.0` (as calculated by Mister.Version 3.0.0 with this repository's `mr-version.yml`):

1. Start feature on `feature/new-calculator-ops` and commit `feat: add power operation`:
   - Version: `1.0.1-new-calculator-ops.1`

2. Merge to `develop`:
   - Version: `1.1.0-dev.2`

3. Create `release/1.1`:
   - Version: `1.1.0`

4. Merge to `main`:
   - Version: `1.1.0`
   - Tags (pushed by `ci.yml`): `v1.1.0` and `examplelibrary/v1.1.0`
   - GitHub Release `v1.1.0` created with the changelog and the NuGet package

Preview the versions on your branch without changing anything with `./test-dry-run.sh`.