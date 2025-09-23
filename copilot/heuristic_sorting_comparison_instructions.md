There are two versions of heuristic sorting (move ordering) in the project.
1. Legacy in the moves.cpp file
2. New in library/src/heuristic_sorting

We need a comprehensive set of comparison between the legacy and new version to prove that they are equivalent.


The new heuristic implementation in `library/src/heuristic_sorting` is the only implementation used by the codebase.

Historically we supported a build-time flag `--define=new_heuristic=true` which injected a runtime toggle `set_use_new_heuristic(...)` to compare legacy and new implementations. That compile-time flag has been removed from the mainline. A compatibility function `set_use_new_heuristic(...)` remains to preserve link-time symbols for older scripts/tests, but it is a no-op and does not change behavior.

If you need to compare the legacy algorithm against the new one for research purposes, keep an archived branch or run the historical binaries built with the legacy flag. The repository no longer builds two variants from the same sources.

copilot/heuristic_sorting_design.md describes the algorithm