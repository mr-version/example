# Version Report Display Issue Fix

## Problem
The version report was showing "Total Projects: 0" in the summary table even though the JSON data contained 4 projects. This was caused by a filtering inconsistency between different parts of the system.

## Root Cause
The issue was in the report generation logic:

1. **Calculate Action**: Returns unfiltered project data (4 projects)
2. **Report Action**: By default, filters out test projects (`include-test-projects: false`) and non-packable projects (`include-non-packable: false`)
3. **Inconsistent Counting**: The summary counts were calculated from unfiltered data but displayed after filtering was applied

In the example repository:
- `ExampleApp`: Non-packable project (filtered out by default)
- `ExampleLibrary`: Packable project (included)
- `ExampleApp.Tests`: Test project (filtered out by default)
- `ExampleLibrary.Tests`: Test project (filtered out by default)

Result: Only 1 project (`ExampleLibrary`) should have been shown, but due to the bug, 0 were displayed.

## Fix Applied

### 1. Updated Report Action TypeScript Logic
Fixed `/report/src/index.ts` to:
- Apply filtering consistently to both project arrays and summary calculations
- Ensure summary counts reflect only the projects that will be displayed
- Apply the same filtering logic in both primary and fallback code paths

### 2. Updated Example Workflows
Updated `.github/workflows/dry-run-example.yml` to:
- Set `include-test-projects: true`
- Set `include-non-packable: true` 
- Set `include-all-projects: true`

This ensures all projects are displayed in the report for demonstration purposes.

### 3. Rebuilt Actions
Rebuilt the report action with `npm run build` to update the bundled JavaScript.

## Result
The version report now correctly shows:
- **Total Projects**: 4 (when including all project types)
- **Changed Projects**: 1 (ExampleLibrary)
- **Test Projects**: 2 (when including test projects)
- **Packable Projects**: 1 (ExampleLibrary)

## Configuration Options

Users can control which projects appear in reports using these inputs:

```yaml
- uses: mr-version/report@main
  with:
    include-test-projects: true    # Include *.Tests projects
    include-non-packable: true     # Include non-packable projects  
    include-all-projects: true     # Show all projects, not just changed ones
```

By default:
- `include-test-projects: false` - Test projects are hidden
- `include-non-packable: false` - Non-packable projects are hidden
- `include-all-projects: false` - Only changed projects are shown in detail

This allows users to customize reports based on their needs while ensuring the summary counts are always accurate.