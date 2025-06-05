#!/bin/bash
set -e

echo "🧪 Testing Mister.Version Dry-Run Functionality"
echo "=============================================="
echo

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: CLI dry-run for version calculation with tag creation
echo -e "${BLUE}Test 1: CLI version command with dry-run and tag creation${NC}"
echo "Command: mr-version version --project src/ExampleLibrary/ExampleLibrary.csproj --create-tag --dry-run"
mr-version version --project src/ExampleLibrary/ExampleLibrary.csproj --create-tag --dry-run
echo

# Test 2: CLI dry-run for report generation
echo -e "${BLUE}Test 2: CLI report command with dry-run${NC}"
echo "Command: mr-version report --dry-run"
mr-version report --dry-run
echo

# Test 3: MSBuild with dry-run
echo -e "${BLUE}Test 3: MSBuild with DryRun property${NC}"
echo "Command: dotnet build src/ExampleLibrary/ExampleLibrary.csproj /p:CreateTag=true /p:DryRun=true"
dotnet build src/ExampleLibrary/ExampleLibrary.csproj /p:CreateTag=true /p:DryRun=true -v:n | grep -E "(DRY RUN|Version:|Tag)"
echo

# Test 4: Show what tags would be created for multiple projects
echo -e "${BLUE}Test 4: Check what tags would be created for all projects${NC}"
echo "Running dry-run version calculation for all projects..."
for project in src/**/*.csproj tests/**/*.csproj; do
    if [[ -f "$project" ]]; then
        echo -e "${YELLOW}Project: $project${NC}"
        mr-version version --project "$project" --create-tag --dry-run --detailed | grep -E "(Version:|DRY RUN|Would create)"
        echo
    fi
done

echo -e "${GREEN}✅ Dry-run tests completed!${NC}"
echo
echo "Summary:"
echo "- CLI supports --dry-run flag for both 'version' and 'report' commands"
echo "- MSBuild task supports /p:DryRun=true property"
echo "- GitHub Actions support dry-run: 'true' input"
echo "- All operations show what would happen without making actual changes"