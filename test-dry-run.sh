#!/bin/bash
# Shows the versions and tags Mister.Version would produce, without changing anything.
#
# The mr-version CLI is read-only: `version`, `report` and `changelog` only read the git history and print
# results, so they have no --dry-run flag. Building never creates tags either. Tags are created by the
# mr-version/tag GitHub Action, which has a `dry-run` input (see .github/workflows/dry-run-example.yml).
set -euo pipefail

echo "🧪 Testing Mister.Version without side effects"
echo "=============================================="
echo

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: detailed version calculation for one project
echo -e "${BLUE}Test 1: CLI version command with details${NC}"
echo "Command: mr-version version --project src/ExampleLibrary/ExampleLibrary.csproj --detailed"
mr-version version --project src/ExampleLibrary/ExampleLibrary.csproj --detailed
echo

# Test 2: report for all projects
echo -e "${BLUE}Test 2: CLI report command${NC}"
echo "Command: mr-version report --output text --include-test-projects --include-non-packable"
mr-version report --output text --include-test-projects --include-non-packable
echo

# Test 3: MSBuild with versioning diagnostics
echo -e "${BLUE}Test 3: MSBuild with MonoRepoDebug${NC}"
echo "Command: dotnet build src/ExampleLibrary/ExampleLibrary.csproj -p:MonoRepoDebug=true"
dotnet build src/ExampleLibrary/ExampleLibrary.csproj -p:MonoRepoDebug=true -v:n | grep -E "MonoRepo Versioning: Set version|^ *Version changed" | sort -u || true
echo

# Test 4: the tags a release would create (project tags are <name>/<prefix><version>, lower-case name)
echo -e "${BLUE}Test 4: Tags a release would create for changed projects${NC}"
shopt -s nullglob
for project in src/*/*.csproj tests/*/*.csproj; do
    echo -e "${YELLOW}Project: $project${NC}"
    output=$(mr-version version --project "$project" --json)
    echo "$output"
    if command -v jq >/dev/null 2>&1; then
        name=$(basename "$project" .csproj)
        version=$(jq -r '.version' <<<"$output")
        changed=$(jq -r '.versionChanged' <<<"$output")
        if [[ "$changed" == "true" ]]; then
            echo "Would create tag: ${name,,}/v${version}"
        else
            echo "No tag: version unchanged"
        fi
    fi
    echo
done

echo -e "${GREEN}✅ Done - nothing was changed.${NC}"
echo
echo "Summary:"
echo "- mr-version version/report/changelog only read the repository (no --dry-run flag needed)"
echo "- dotnet build -p:MonoRepoDebug=true shows how each version was calculated; builds never create tags"
echo "- The mr-version/calculate, tag and release actions accept dry-run: 'true'"
