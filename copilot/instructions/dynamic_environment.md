The solver uses static memory in several places, which means that we cannot parallelize solving several hands at the same time. To be able to do so is highly desirable for simulations or training models.

Your task is to create a plan for making all memory usage dynamic and contained by a solver instance - call to one of the high level solver functions.

Please create a plan for this work and store it under copilot/plans
