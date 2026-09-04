#!/bin/bash
set -euxo pipefail

SOLUTION_DIR="dotnet-tests"

# Run from inside the solution directory rather than passing it as an argument.
#
# `dotnet` resolves global.json from the working directory upwards, not from
# the path it is given, so `dotnet test dotnet-tests` from the repository root
# never reads dotnet-tests/global.json. That file is what selects
# Microsoft.Testing.Platform as the test runner; without it the run falls back
# to VSTest, which .NET 10 no longer supports for MTP projects, and the
# failure reads as a broken test project rather than a missing setting.
cd "$SOLUTION_DIR"
dotnet test
