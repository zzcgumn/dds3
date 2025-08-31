# Task 11: Update Build System Integration

## Objective
Ensure the build system (Bazel and Makefiles) properly includes and links the new heuristic sorting library.

## Acceptance Criteria
- [ ] Update main BUILD.bazel to include heuristic sorting library
- [ ] Verify library dependencies are correctly specified
- [ ] Ensure library builds successfully with Bazel
- [ ] Update Makefiles if necessary for non-Bazel builds
- [ ] Test compilation with both `DDS_USE_NEW_HEURISTIC` enabled and disabled
- [ ] Verify no linking errors occur
- [ ] Ensure library is properly installed/packaged

## Implementation Notes
- The heuristic sorting library has its own `BUILD.bazel` file
- Main library target needs to depend on the heuristic sorting target
- Check if any additional dependencies are needed
- Consider visibility rules for internal vs public interfaces
- Test with clean builds to ensure all dependencies are captured

## Dependencies
- Task 10 (moves.cpp integration) should be completed
- All heuristic functions should be implemented

## Output
- Working build system that properly includes the new library
- Both compile flag settings build successfully
- Documentation of any build system changes made
