# Task 10: Update Main BUILD.bazel Dependencies

## Objective
Update the main library BUILD.bazel file to include dependencies on the utility libraries.

## Steps
1. Open `library/src/BUILD.bazel`
2. Find the `cc_library` targets (both "dds" and "testable_dds")
3. Add dependencies to both targets:
   - `"//library/src/utility:constants"`
   - `"//library/src/utility:lookup_tables"`
4. Ensure the dependencies are properly formatted in the deps list

## Expected Outcome
- Main library targets depend on utility libraries
- Proper linking of utility code with main library
- Build system understands the dependency relationships

## Files Modified
- `library/src/BUILD.bazel`

## Dependencies
- Task 06 (utility BUILD.bazel created)

## Verification
- `bazel build //library/src:dds` succeeds
- `bazel build //library/src:testable_dds` succeeds
- All symbols are properly linked
