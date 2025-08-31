# Task Overview: Extract Utility Library

This directory contains 12 sequential tasks to extract global definitions from Init.h and Init.cpp into a dedicated utility library.

## Task Sequence

1. **01_create_utility_directory.md** - Create basic directory structure
2. **02_create_constants_header.md** - Create Constants.h with declarations
3. **03_create_constants_implementation.md** - Create Constants.cpp with definitions
4. **04_create_lookuptables_header.md** - Create LookupTables.h with declarations
5. **05_create_lookuptables_implementation.md** - Create LookupTables.cpp with initialization
6. **06_create_utility_build_file.md** - Create BUILD.bazel for utility library
7. **07_remove_globals_from_init.md** - Remove global definitions from Init.cpp
8. **08_update_init_function_calls.md** - Update function calls in Init.cpp
9. **09_remove_externs_from_dds_header.md** - Remove extern declarations from dds.h
10. **10_update_main_build_dependencies.md** - Update main BUILD.bazel dependencies
11. **11_fix_transtablel_dependencies.md** - Fix specific file dependencies
12. **12_verify_and_test_refactoring.md** - Final verification and testing

## Notes

- Tasks should be completed in order (each task depends on previous ones)
- Each task is designed to be small and manageable
- After each task, verify the changes work before proceeding
- Task 12 provides comprehensive verification of the entire refactoring

## Dependencies

The tasks form a dependency chain:
- Tasks 1-6: Create utility library
- Tasks 7-11: Update existing files to use utility library
- Task 12: Verify everything works together
