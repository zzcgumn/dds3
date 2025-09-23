## Task 2: API Design and Implementation

- **Goal:** Design the public API for the heuristic sorting component and implement the refactored logic.
- **Key Actions:**
    - In `heuristic_sorting.h`, define a public `SortMoves()` function that takes the required game state in a struct.
    - Move the ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)...` functions from `Moves.cpp` into `heuristic_sorting.cpp`, refactoring them into standalone functions.
    - Place the declarations for the internal ``\0` (migrated into library/src/heuristic_sorting; canonical API: CallHeuristic)...` functions into `internal.h`.
    - Implement the public `SortMoves()` function to call the appropriate internal functions.
- **Deliverable:** A complete, self-contained `heuristic_sorting` component with a clear public API and internal implementation.