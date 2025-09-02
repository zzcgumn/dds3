## Task 5: Adapter Integration in `Moves.cpp`

- **Goal:** Integrate the new library into `Moves.cpp` using a thin adapter layer.
- **Key Actions:**
    - Create an adapter that translates `Moves` internal state to the `HeuristicContext`.
    - Call the new `score_and_order` function from the adapter.
    - Use a compile flag `DDS_USE_NEW_HEURISTIC` to switch between the old and new implementations.
- **Deliverable:** Modified `library/src/Moves.cpp` with the adapter integration.
