We can use the command

bazel-bin/library/tests/dtest --file hands/list100.txt

to test the time it takes to solve double dummy problems. There are several list*txt files with a varying number of hands.

Building the with new heuristics enabled is slower. I can see a switch statement on line 81 is in heuristic_sorting.cpp which is a lookup to a pointer to function in Moves.cpp. I don't think this can explain the entire discrepancy.

There is either a difference in the algorithms that we have failed to recover with our tests in library/tests/heuristic_sorting or a substantial overhead in library/src/heuristic_sorting.

Please create a plan for investigating and save it in copilot/plans.

How heuristic sorting is supposed to work is documented in copilot/heuristic_sorting_design.md