# What are we testing for here?

## For Processes

1. Proper `subtyping` of model structs for some processes.
2. Allocations (optional). You can enable allocation checks by running tests with `SINDBADTEM_TEST_ALLOCATIONS=true`.
3. The expected result for packed variables (your variables at the @pack_nt step). Is the math correct?
- More? suggestions welcome.

Note that this done for modelling `one time step`.