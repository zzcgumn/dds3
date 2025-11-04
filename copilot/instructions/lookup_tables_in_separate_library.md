LookupTables.h and LookupTables.cpp are currently defined within the utility sub library. They don't really fit the description of a utility and should be defined in a separate project.

You can look at the trans_table library as an examples but use lookup_tables as the header prefix.

Acceptance criteria:
1. all targets build and all tests pass.
2. LookupTables defined in a separate library target.
3. <lookup_tables/LookupTables.h> is included in *.cpp files only.