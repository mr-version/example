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
│   └── manual-release.yml  # Manual release workflow
└── mr-version.yml     # Version configuration
```

## Features Demonstrated

### 1. Semantic Versioning

The repository follows semantic versioning with automatic version calculation based on:
- Commit message patterns (feat:, fix:, BREAKING CHANGE:)
- Branch naming conventions
- Manual version overrides

### 2. GitHub Actions Integration

#### CI/CD Pipeline (`ci.yml`)
- **Setup**: Installs Mr. Version CLI
- **Calculate**: Determines next version
- **Build**: Builds projects with calculated version
- **Test**: Runs all unit tests
- **Report**: Generates version report
- **Tag**: Creates git tags on main branch
- **Release**: Creates GitHub releases with artifacts

#### Version Check (`version-check.yml`)
- Runs on pull requests
- Compares version changes between branches
- Comments on PR with version comparison report

#### Manual Release (`manual-release.yml`)
- Allows manual version releases
- Supports custom version numbers
- Publishes to NuGet (when configured)

### 3. Version Configuration

The `mr-version.yml` file demonstrates:
- Branch-specific versioning rules
- Commit pattern matching
- Project configuration
- Tag formatting
- Metadata inclusion

### 4. Dry-Run Support

All mr-version components support dry-run mode to preview changes without making them:

#### CLI Commands
```bash
# Preview version calculation and tag creation
mr-version version --project path/to/project.csproj --create-tag --dry-run

# Preview report generation
mr-version report --dry-run
```

#### MSBuild Integration
```bash
# Build with dry-run to see what tags would be created
dotnet build /p:CreateTag=true /p:DryRun=true /p:MonoRepoVersionDebug=true
```

#### GitHub Actions
```yaml
# All actions support dry-run mode
- uses: mr-version/calculate@main
  with:
    dry-run: true

- uses: mr-version/tag@main
  with:
    dry-run: true

- uses: mr-version/release@main
  with:
    dry-run: true
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

4. Calculate version locally:
   ```bash
   mr-version report
   ```

5. Test dry-run functionality:
   ```bash
   # Run the test script
   ./test-dry-run.sh
   
   # Or manually test dry-run commands:
   mr-version version --project src/ExampleLibrary/ExampleLibrary.csproj --create-tag --dry-run
   mr-version report --dry-run
   dotnet build /p:CreateTag=true /p:DryRun=true
   ```

### Creating a Release

1. **Automatic Release** (on push to main):
   - Make changes and commit with conventional commits
   - Push to main branch
   - CI/CD pipeline automatically versions, tags, and releases

2. **Manual Release**:
   - Go to Actions tab
   - Select "Manual Release" workflow
   - Choose version increment type
   - Run workflow

### Version Patterns

| Commit Pattern | Version Change | Example |
|----------------|----------------|---------|
| `BREAKING CHANGE:` | Major | 1.0.0 → 2.0.0 |
| `feat:` | Minor | 1.0.0 → 1.1.0 |
| `fix:` | Patch | 1.0.0 → 1.0.1 |
| `docs:`, `style:`, `test:`, `chore:` | None | 1.0.0 → 1.0.0 |

### Branch Strategies

| Branch | Versioning | Tag | Prerelease |
|--------|------------|-----|------------|
| main | Minor | ✓ | - |
| develop | Patch | ✗ | alpha |
| feature/* | Patch | ✗ | beta |
| release/* | Patch | ✓ | rc |
| hotfix/* | Patch | ✓ | - |

## Running the Example App

```bash
cd src/ExampleApp
dotnet run -- 10 + 5
```

Output:
```
ExampleApp v1.0.0
----------------------------------------
10 + 5 = 15

Library Version: ExampleLibrary v1.0.0
```

## Contributing

This is an example repository. Feel free to fork and modify for your own use cases.

## License

This example is provided as-is for demonstration purposes.

---

Created by discrete-sharp <discrete.sharp@proton.me>