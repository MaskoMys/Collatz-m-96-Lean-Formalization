/-
CollatzM96 — a Lean 4 formalization of the mathematical core and logical
skeleton of

  N. Mghirbi, "Prefix Rigidity, Surplus Frontiers, and an Exact Certificate
  Excluding Collatz 96-Cycles" (2026), Theorem 11.3.

Importing this module builds the whole development:

  • Farey.lean          — Stern–Brocot mediant denominator bound      (proved)
  • AffineIdentity.lean — affine prefix identity, Lemma 2.2           (proved)
  • Constants.lean      — exact constants + arithmetic certificate    (proved)
  • Reduction.lean      — m-cycle object + axiom interface + lifts    (mixed)
  • Main.lean           — Theorem 11.3 + #print axioms                (proved)

See README.md for scope, trust, build, and citation guidance.
-/
import CollatzM96.Farey
import CollatzM96.AffineIdentity
import CollatzM96.Constants
import CollatzM96.Reduction
import CollatzM96.Main
