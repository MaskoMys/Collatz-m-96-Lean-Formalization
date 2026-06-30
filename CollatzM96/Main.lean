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

Everything below the axiom interface is **kernel-checked**. The theorem's trust
base can be audited with:

```bash
lake env lean audit/AxiomReport.lean
```
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
