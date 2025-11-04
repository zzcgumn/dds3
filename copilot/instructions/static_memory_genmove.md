
Remove Arena TLS solution, step one.

ThreadData should be allocated as a member of the SolverContext. A SolverContext is created at the top of the call stack meaning that ThreadData can be passed downwards without any need for a per thread look up.

Memory should no longer store an array of ThreadData instances and the GetPtr method should be removed.
