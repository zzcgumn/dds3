There are two versions of heuristic sorting (move ordering) in the project.
1. Legacy in the moves.cpp file
2. New in library/src/heuristic_sorting

We need a comprehensive set of comparison between the legacy and new version to prove that they are equivalent.

Building with the use_new_heuristic flag set
```
bazel build //... --define=new_heuristic=true
```
enables a function set_use_new_heuristic which can be used to switch between the implementations. 

This means that we can add tests to library/tests/heuristic_sorting that compare output from the two versions.

copilot/heuristic_sorting_design.md describes the algorithm