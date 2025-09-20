# Task 04: Ensure exports and visibility in `heuristic_sorting`

## Objective
Make sure the new module exposes the required headers/symbols and is easy to depend on.

## Steps
- Review `library/src/heuristic_sorting/*` headers and BUILD targets.
- Ensure a `cc_library` exists with the needed sources/headers and proper `visibility`.
- Add or adjust `hdrs`, `deps`, and `includes` so callers can include the new headers without path hacks.
- If using adapters, ensure they can include the new headers cleanly.

## Verification
- `bazel build //library/...` succeeds with targets depending on `heuristic_sorting`.
- Headers are reachable from intended include paths.

## Expected outputs
- Updated BUILD rules as needed.
