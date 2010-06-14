=============================
MTBindingSim Revision History
=============================

Version 0.5
===========

1. Supports the following binding models:

   * First-order binding of microtubule binding protein to microtubues
   * "Classical" cooperativity
   * A model where a protein binds the microtubule at the seam and the lattice
     with different affinities
   * A model where a microtubule binding protein can bind either the microtubule
     or a microtubule bound protein, allowing two total layers of microtubule
     bound proteins.
   * A model where a microtubule binding protein can bind either the microtubule
     or a microtubule bound protein, allowing up to three layers of microtubule
     binding proteins on the microtubule.

2. Three different modes of collecting binding data:

   * Holding the protein of interest constant and varying the microtubule
     concentration
   * Holding the microtubule concentration constant and varying the concentration
     of the protein of interest
   * An experiment with two different microtubule binding proteins, where one
     microtubule binding protein and microtubule concentration are held constant
     and the concentration of the other microtubule binding protein is varied.  In
     this mode, both microtubule binding proteins are assumed to follow first-order
     binding.

