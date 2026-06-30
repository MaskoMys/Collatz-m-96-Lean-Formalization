import CollatzM96.Main

/-
Run from the project root with:

  lake env lean audit/AxiomReport.lean

This keeps ordinary `lake build` output quiet while preserving a single-command
audit of the headline theorem's trust base.

Expect exactly the four named axioms that carry mathematical content:

  CollatzM96.barina
  CollatzM96.enclosure_above_window
  CollatzM96.simons_deWeger
  CollatzM96.finite_window_excluded

Lean/Mathlib's standard logical foundations (`propext`, `Classical.choice`,
`Quot.sound`) may also appear; they are not problem-specific assumptions.

Note `enclosure_floor` / `K_ge_K0` (the first lift) do NOT appear: the headline
proof needs only the closing lift, because the finite search already absorbs the
`K0`-derived stages. See docs/TRUST.md.
-/
#print axioms CollatzM96.no_nontrivial_collatz_96_cycle
