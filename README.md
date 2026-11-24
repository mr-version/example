# Mr. Version Example Repository

This repository demonstrates the complete integration of Mr. Version tooling and GitHub Actions for automated semantic versioning in .NET projects.

## Overview

This example showcases:
- 🏗️ Multi-project .NET solution with proper versioning
- 🔧 Complete Mr. Version configuration
- 🚀 GitHub Actions workflows using all mr-version actions
- 📦 Automated NuGet package creation and publishing
- 🏷️ Automatic version tagging and GitHub releases

## Project Structure

```
├── src/
│   ├── ExampleApp/          # Console application
│   └── ExampleLibrary/      # Class library (NuGet package)
├── tests/
│   ├── ExampleApp.Tests/    # App unit tests
│   └── ExampleLibrary.Tests/# Library unit tests
├── .github/workflows/       # GitHub Actions workflows
│   ├── ci.yml              # Main CI/CD pipeline
│   ├── version-check.yml   # PR version checking
│   ├── manual-release.yml  # Manual release workflow
│   └── dry-run-example.yml # Dry-run / read-only examples
├── Directory.Build.targets  # Adds the Mister.Version MSBuild package to every project
├── mr-version.yml           # Version configuration
└── test-dry-run.sh          # Local script: shows versions and would-be tags without changing anything
```

## Prerequisites

- .NET 8 SDK
- The `mr-version` CLI for the local commands below, the same version as the `Mister.Version` package in
  `Directory.Build.targets` (currently 3.0.0):
  ```bash
  dotnet tool install --global Mister.Version.CLI --version 3.0.0
  ```
- A clone with full history and tags (CI checkouts use `fetch-depth: 0`); versions are calculated from git.

## Features Demonstrated

### 1. Semantic Versioning

The repository follows semantic versioning with automatic version calculation based on:
- Conventional Commits (feat:, fix:, BREAKING CHANGE:, ...)
- The branch type (main, develop, release/*, feature/*, hotfix/*)
- Manual overrides (prerelease type or forced version, see the manual release)

The `Mister.Version` package versions every project during `dotnet build`; the `mr-version` CLI and the
GitHub Actions use the same calculation.

### 2. GitHub Actions Integration

The workflows use `mr-version/setup`, `calculate`, `tag`, `report`, `changelog` and `release` at `@main`:
the `v1` tags of setup, calculate, tag, report and release still point at their initial check-ins, and
`changelog` has no tags yet.

#### CI/CD Pipeline (`ci.yml`)
- **Setup**: Installs the Mr. Version CLI (`mr-version/setup`)
- **Calculate**: Calculates the version of every project (`mr-version/calculate`)
- **Report**: Adds a version report to the job summary (`mr-version/report`)
- **Build**: Builds and tests the solution; the Mister.Version package sets each project's version
- **Pack**: Packs `ExampleLibrary` and checks that the package version matches the calculated one
- **Tag**: On pushes to main, tags exactly the calculated versions and pushes the new tags (`mr-version/tag`)
- **Release**: Creates a GitHub release with changelog notes (`mr-version/changelog`) and the package
  (`softprops/action-gh-release`)

#### Version Check (`version-check.yml`)
- Runs on pull requests
- Calculates versions for the pull request and for the base branch (checked out as a worktree)
- Comments on the PR with a comparison table and the report of changed projects

#### Manual Release (`manual-release.yml`)
- Releases from any branch on demand
- Optional prerelease type (`alpha`, `beta`, `rc`) or forced version for the run
- Tags, creates the GitHub release with `gh release create`, and publishes to NuGet when
  `NUGET_API_KEY` is configured (final versions only)

### 3. Version Configuration

The `mr-version.yml` file (camelCase keys, see the
[Mister.Version README](https://github.com/mr-version/mister.version#yaml-configuration)) demonstrates:
- A base version for repositories without tags (`baseVersion`)
- Conventional Commits patterns (`commitConventions`)
- The tag prefix (`tagPrefix`)
- Skipping test projects (`skipTestProjects`)
- Branch names in build metadata (`gitIntegration.includeBranchInMetadata`)

Check that the file is understood (no configuration warnings in the output):

```bash
mr-version version --project src/ExampleLibrary/ExampleLibrary.csproj --debug
```

### 4. Previewing Without Changes

#### CLI Commands
The CLI never changes the repository: `version`, `report` and `changelog` only read the history and print
results, so there is no `--dry-run` flag (and the CLI does not create tags).

```bash
# Detailed version calculation for one project
mr-version version --project src/ExampleLibrary/ExampleLibrary.csproj --detailed

# Versions of all projects
mr-version report --output text --include-test-projects --include-non-packable

# Changelog since the last version tag
mr-version changelog
```

#### MSBuild Integration
Builds never create tags. `MonoRepoDebug` shows how each version was calculated, and
`MonoRepoVersioningEnabled=false` turns versioning off:

```bash
dotnet build -p:MonoRepoDebug=true -v:n
```

#### GitHub Actions
`calculate`, `tag` and `release` accept `dry-run` (calculate then leaves project files alone, tag and release
only report the tags they would create):

```yaml
- uses: mr-version/calculate@main
  id: calc
  with:
    dry-run: 'true'

- uses: mr-version/tag@main
  with:
    projects-json: ${{ steps.calc.outputs.projects }}
    dry-run: 'true'

- uses: mr-version/release@main
  with:
    dry-run: 'true'
```

## Usage

### Local Development

1. Clone the repository:
   ```bash
   git clone https://github.com/your-org/mr-version-example.git
   cd mr-version-example
   ```

2. Build the solution:
   ```bash
   dotnet build
   ```

3. Run tests:
   ```bash
   dotnet test
   ```

4. Calculate versions locally:
   ```bash
   mr-version report
   ```

5. Preview versions and the tags a release would create, without changing anything:
   ```bash
   ./test-dry-run.sh
   ```

### Creating a Release

1. **Automatic Release** (on push to main):
   - Make changes and commit with conventional commits
   - Push to main branch
   - CI/CD pipeline automatically versions, tags, and releases

2. **Manual Release**:
   - Go to Actions tab
   - Select "Manual Release" workflow
   - Optionally choose a prerelease type or a version to force (the increment itself comes from the commits)
   - Run workflow

### Version Patterns

| Commit Pattern | Version Change | Example |
|----------------|----------------|---------|
| `BREAKING CHANGE:` footer or `feat!:` | Major | 1.0.0 → 2.0.0 |
| `feat:` | Minor | 1.0.0 → 1.1.0 |
| `fix:`, `refactor:` | Patch | 1.0.0 → 1.0.1 |
| `docs:`, `style:`, `test:`, `chore:` | None | 1.0.0 → 1.0.0 |

### Branch Strategies

Branch behaviour is built into Mister.Version (it is not configured in `mr-version.yml`). Example versions
after `v1.0.0`:

| Branch | Version | Tagged by CI |
|--------|---------|--------------|
| main | Final version from the commits, e.g. `1.1.0` | ✓ (`ci.yml` on push) |
| develop | Prerelease with the commit height, e.g. `1.1.0-dev.2` | ✗ |
| feature/new-ops | Prerelease named after the branch, e.g. `1.0.1-new-ops.1` | ✗ |
| release/1.1 | Final versions within 1.1, e.g. `1.1.0` | ✗ (use the manual release) |
| hotfix/x | Prerelease named after the branch, e.g. `1.0.1-x.1` | ✗ |

## Running the Example App

```bash
cd src/ExampleApp
dotnet run -- 10 + 5
```

Output (the assembly version, which follows the calculated version):
```
ExampleApp v1.0.0.0
----------------------------------------
10 + 5 = 15

Library Version: ExampleLibrary v1.0.0.0
```

## Contributing

This is an example repository. Feel free to fork and modify for your own use cases.

## License

This example is provided as-is for demonstration purposes.

---

Created by discrete-sharp <discrete.sharp@proton.me>