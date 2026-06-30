import Mathlib

/-!
# Farey / Stern–Brocot mediant denominator bound

This is the analytic heart of the paper's denominator–lift argument (§11).

If `a/b < c/d` are **Farey neighbours** (i.e. `b*c - a*d = 1`, with `b, d > 0`),
then any fraction `p/q` lying strictly between them has denominator at least
`b + d` — the denominator of their mediant `(a+c)/(b+d)`.

The proof is the classical one-line identity

  `q = b·(c·q - p·d) + d·(p·b - a·q)`              (using `b*c - a*d = 1`)

together with the fact that, for integers, "strictly between" forces both
`p·b - a·q ≥ 1` and `c·q - p·d ≥ 1`.  No primality / lowest-terms hypothesis on
`p/q` is needed.

This lemma is **fully verified in the Lean kernel** (no axioms beyond Lean/Mathlib
foundations).
-/

namespace CollatzM96

/-- **Mediant denominator bound.**
For Farey neighbours `a/b < c/d` (`b*c - a*d = 1`, `b,d > 0`), any `p/q` with
`a/b < p/q < c/d` — encoded by the integer cross-inequalities
`1 ≤ p*b - a*q` and `1 ≤ c*q - p*d` — satisfies `b + d ≤ q`. -/
theorem farey_denominator_bound
    {a b c d p q : ℤ} (hb : 0 < b) (hd : 0 < d)
    (hfar : b * c - a * d = 1)
    (h1 : 1 ≤ p * b - a * q) (h2 : 1 ≤ c * q - p * d) :
    b + d ≤ q := by
  -- The classical mediant identity, valid because `b*c - a*d = 1`.
  have key : q = b * (c * q - p * d) + d * (p * b - a * q) := by
    linear_combination (-q) * hfar
  have hb' : (0 : ℤ) ≤ b := le_of_lt hb
  have hd' : (0 : ℤ) ≤ d := le_of_lt hd
  -- Each summand dominates its denominator since the cross-terms are ≥ 1.
  have t1 : b ≤ b * (c * q - p * d) := by
    calc b = b * 1 := (mul_one b).symm
      _ ≤ b * (c * q - p * d) := mul_le_mul_of_nonneg_left h2 hb'
  have t2 : d ≤ d * (p * b - a * q) := by
    calc d = d * 1 := (mul_one d).symm
      _ ≤ d * (p * b - a * q) := mul_le_mul_of_nonneg_left h1 hd'
  calc b + d
      ≤ b * (c * q - p * d) + d * (p * b - a * q) := add_le_add t1 t2
    _ = q := key.symm

end CollatzM96
