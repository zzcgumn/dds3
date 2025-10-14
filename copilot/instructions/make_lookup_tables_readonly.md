
LookupTables.h contain some extern int declarations which give full access to some, constant readonly data. We want to refactor this to be readonly access.

There is also InitLookupTables which only needs to be called once per session. We want to use a standard C++ call_once construction for the initialisation.

Goals:
  - clean, read-only interface for accessing data
  - once per session initialisation

Tools:
You can use the serena mcp to help with design choices and the cpp mcp for C++ queries.
