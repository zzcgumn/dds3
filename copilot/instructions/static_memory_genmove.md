
Remove Arena TLS solution, step one.

There is an arena which serves dynamic thread local storage efficiently. Longterm goal is to remove this and replace loops over thread indexes with C++ concurrency.

There are a number legacy log statements which use the arena thread local storage. They were used for debugging and should now be removed. 

Dynamic thread local storage is also used by GenMove and GenMove123 when calculating valid cards. They should be replaced by replaced by a statically allocated buffer of size 13 owned by the SolverContext
