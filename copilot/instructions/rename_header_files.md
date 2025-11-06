Header files that are part of the C API should have a .h suffix.
All header files are C++ only and should have a .hpp suffix.

The external C API is the library/src/dds.h file. Files included from there are part of C API. They are library/src/utility/Constants.h, library/src/dds.h, library/src/dll.h, library/src/PBN.h and library/src/portab.h
