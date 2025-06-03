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
- `BREAKING CHANGE:` - Breaking changes (triggers major version bump)

## Branch Strategy

- `main` - Production releases
- `develop` - Development branch (alpha versions)
- `feature/*` - Feature branches (beta versions)
- `release/*` - Release candidates
- `hotfix/*` - Hot fixes for production

## Version Flow Example

1. Start feature on `feature/new-calculator-ops`:
   - Version: `1.0.0-beta.1`

2. Merge to `develop`:
   - Version: `1.1.0-alpha.1`

3. Create `release/1.1.0`:
   - Version: `1.1.0-rc.1`

4. Merge to `main`:
   - Version: `1.1.0`
   - Tag: `v1.1.0`
   - GitHub Release created