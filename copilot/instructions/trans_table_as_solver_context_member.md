### Make trans table a member variable in SolverContext.

Currently there is a map between ThreadData and TransTable instances in SolverContext.cpp. We want to retire this solution and instead make TransTable a member variable in the SearchContext.

SolverContext should also expose a method to reset the SearchContext. The aim is that client code can create and retain a SolverContext which it can reuse for several calls to SolveBoard. It will be the responsibility of the client code to reset the search if the transposition table is no longer valid. The idea is to make it cheaper to call SolveBoard several times for the same deal at different points during the play. This is to make it feasible to train machine learnings models efficiently working on several episodes in paralell.

It is expected that we can retired Arena and ScratchAllocTLS after this refactoring.