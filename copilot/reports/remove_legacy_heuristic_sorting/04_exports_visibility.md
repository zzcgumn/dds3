Task 04: Exports and visibility check

Summary
- `library/src/heuristic_sorting/BUILD.bazel` defines `cc_library(name = "heuristic_sorting", include_prefix = "heuristic_sorting", hdrs = glob(["*.h"]), visibility = ["//visibility:public"])` and also provides `testable_heuristic_sorting` for internal tests.
- `library/src/moves/BUILD.bazel` already lists `//library/src/heuristic_sorting` in its `deps`.
- `Moves.cpp` includes the header using `#include "heuristic_sorting/heuristic_sorting.h"`, which matches the `include_prefix` in the heuristic_sorting target.

Conclusion
- No BUILD changes are required: the `heuristic_sorting` library is public, headers are exported with the expected include prefix, and `moves` depends on it.
- Safe to proceed with refactoring `Moves.cpp` to call `Moves::CallHeuristic` directly and remove conditional references to `use_new_heuristic()`.

Recommended next steps
1. Update todo status: mark Task 04 completed.
2. Start Task 05: refactor `Moves.cpp` to remove the `#ifdef DDS_USE_NEW_HEURISTIC` block and replace ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)*` calls with `Moves::CallHeuristic(...)`.
3. Keep compatibility shims (optional): provide a simple `set_use_new_heuristic`/`use_new_heuristic` shim to avoid breaking external test harnesses while tests are updated.
