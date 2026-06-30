import Mathlib
import CollatzM96.Reduction

/-!
# Main theorem (Theorem 11.3)

There is no nontrivial positive Collatz `96`-cycle.

The proof is the paper's two-case dichotomy on the least minimum `n₁`:

* **Finite window** `n₁ ≤ 29·2^71`: excluded by the 75-branch certificate
  (`finite_window_excluded`), together with Barina's floor `n₁ ≥ 2^71`.
* **Above the window** `n₁ > 29·2^71`: the closing denominator lift forces
  `K ≥ Q`, while Simons–de Weger forces `K < Q` — a contradiction.

Everything below the axiom interface is **kernel-checked**.  The final
`#print axioms` line exposes the complete trust base.
-/

namespace CollatzM96

/-- **Theorem 11.3.**  No nontrivial positive Collatz `96`-cycle exists. -/
theorem no_nontrivial_collatz_96_cycle : ¬ ∃ C : MCycle, C.m = 96 := by
  rintro ⟨C, hm96⟩
  have hX : X ≤ C.n 1 := barina C
  rcases le_or_lt (C.n 1) (29 * X) with hle | hgt
  · -- inside the finite window: the search certificate closes it
    exact finite_window_excluded ⟨C, hm96, hX, hle⟩
  · -- above the window: Farey closing lift vs Simons–de Weger
    have hQ : Q ≤ C.K := K_ge_Q C hm96 hgt
    have hK : C.K < Q := K_lt_Q C hm96
    exact absurd hQ (not_le.mpr hK)

end CollatzM96

/-
The trust base of the headline theorem.  Expect exactly the four named axioms
that carry mathematical content —

  CollatzM96.barina
  CollatzM96.enclosure_above_window
  CollatzM96.simons_deWeger
  CollatzM96.finite_window_excluded

— plus Lean/Mathlib's standard logical foundations
(`propext`, `Classical.choice`, `Quot.sound`), which appear in essentially every
Mathlib development and are not problem-specific assumptions.

Note `enclosure_floor` / `K_ge_K0` (the first lift) do NOT appear: the headline
proof needs only the closing lift, because the finite search already absorbs the
`K₀`-derived stages.  See docs/TRUST.md.
-/
#print axioms CollatzM96.no_nontrivial_collatz_96_cycle
