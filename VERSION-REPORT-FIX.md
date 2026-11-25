# Version Report Display Issue Fix

## Problem
The version report was showing "Total Projects: 0" in the summary table even though the JSON data contained 4 projects. This was caused by a filtering inconsistency between different parts of the system.

## Root Cause
The summary counts and the displayed projects came from differently filtered project lists:

1. **Calculate Action**: Returns the calculated projects (test projects are excluded unless `include-test-projects: true`)
2. **mr-version report**: Leaves out test projects and non-packable projects unless `--include-test-projects` / `--include-non-packable` are passed
3. **Inconsistent Counting**: The summary counts were calculated from one list but displayed after other filtering was applied

In the example repository (as classified by `mr-version` 3.0.0):
- `ExampleApp`: Non-packable project (left out by default)
- `ExampleLibrary`: Packable project (included)
- `ExampleApp.Tests`: Test project (left out by default)
- `ExampleLibrary.Tests`: Test project (left out by default)

## Fix Applied

### 1. Report Action
The report action (`mr-version/report`) now:
- Declares `include-test-projects` and `include-non-packable` (default `false`) and passes them to `mr-version report` as
  `--include-test-projects` / `--include-non-packable` when they are `true`, for both the data and the graph output
- Counts projects from the list `mr-version report` returns, i.e. after the same include filters as the projects it lists
- Passes boolean options in a form every CLI version understands (an older form, `--changed-only false`, was read
  by `mr-version` 3.0.0 as `--changed-only`)

### 2. Example Workflows
`.github/workflows/dry-run-example.yml` sets `include-test-projects: true` and `include-non-packable: true` on the report
step, so all four projects are shown for demonstration purposes. `changed-only: false` shows every project, not only the
changed ones.

## Result
With both inputs set to `true` the version report shows:
- **Total Projects**: 4
- **Test Projects**: 2
- **Packable Projects**: 1 (ExampleLibrary)
- **Changed Projects**: the projects whose version changed since their last tag

## Configuration Options

Users can control which projects appear in reports using these inputs:

```yaml
- uses: mr-version/report@main
  with:
    include-test-projects: true    # Include *.Tests projects
    include-non-packable: true     # Include non-packable projects (test projects are usually non-packable too)
    changed-only: false            # Show all projects, not just changed ones
```

By default:
- `include-test-projects: false` - Test projects are hidden
- `include-non-packable: false` - Non-packable projects are hidden
- `changed-only: false` - All (included) projects are listed; changed projects are marked 🔄

This allows users to customize reports based on their needs while ensuring the summary counts are always accurate.
