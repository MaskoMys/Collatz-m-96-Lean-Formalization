import Mathlib

/-!
# Exact constants and the arithmetic certificate

Every numeral below was cross-checked with an independent exact-integer
computation (see `docs/THEOREM_MAP.md`).  Each `theorem` here is closed by
`norm_num`, i.e. **verified by the Lean kernel** with no problem-specific axioms.

These are the load-bearing arithmetic facts of §11:

* the two pairs of **Farey neighbours** for the first and closing denominator
  lifts, each with cross-determinant exactly `1` and mediant denominator `K₀`
  resp. `Q`;
* the **Simons–de Weger** comparison in exact integer form
  (`1.4784·96·(317/200)^96 < Q`);
* soundness of the **valuation caps** used by the finite search;
* monotonicity of the descent **lower-bound stages** `extra₆ < extra₇ < extra₈`.
-/

namespace CollatzM96

/-- Barina's verification floor: every cycle element is `≥ 2^71`. -/
abbrev X : ℤ := 2 ^ 71

/-! ## First denominator lift — Farey neighbours `a₁/b₁ < (K+L)/K < c₁/d₁` -/

abbrev a1 : ℤ := 202780263237295321099
abbrev b1 : ℤ := 127940101513462006853
abbrev c1 : ℤ := 123139092617126647266
abbrev d1 : ℤ := 77692117359936589403

/-- Lower bound forced by the first lift. -/
abbrev K0 : ℤ := 205632218873398596256

/-- The first-lift neighbours are Farey neighbours (cross-determinant `= 1`). -/
theorem farey1_det : b1 * c1 - a1 * d1 = 1 := by norm_num

/-- Their mediant denominator is exactly `K₀`. -/
theorem farey1_mediant : b1 + d1 = K0 := by norm_num

/-! ## Closing denominator lift — Farey neighbours `a₂/b₂ < (K+L)/K < c₂/d₂`

`c₂` is the closing upper numerator; it is reconstructed from the Farey
determinant as `c₂ = (a₂·d₂ + 1)/b₂` and equals `325919355854421968365`. -/

abbrev a2 : ℤ := 12261796429850908150604
abbrev b2 : ℤ := 7736332199829210068325
abbrev c2 : ℤ := 325919355854421968365
abbrev d2 : ℤ := 205632218873398596256   -- = K0

/-- Lower bound forced by the closing lift (above the finite window). -/
abbrev Q : ℤ := 7941964418702608664581

/-- The closing neighbours are Farey neighbours (cross-determinant `= 1`). -/
theorem farey2_det : b2 * c2 - a2 * d2 = 1 := by norm_num

/-- Their mediant denominator is exactly `Q`. -/
theorem farey2_mediant : b2 + d2 = Q := by norm_num

/-- The closing lower denominator equals `K₀` (the closing lift reuses `K* = K₀`). -/
theorem d2_eq_K0 : d2 = K0 := by norm_num

/-! ## Simons–de Weger upper bound vs the closing lift -/

/-- Exact integer form of `1.4784·96·(317/200)^96 < Q`, i.e.
`14784·96·317^96 < 10000·200^96·Q`.  Combined with the Simons–de Weger axiom
`K < 1.4784·96·(317/200)^96` this yields `K < Q`, contradicting `K ≥ Q`. -/
theorem sdW_surrogate_lt_Q :
    14784 * 96 * (317 : ℤ) ^ 96 < 10000 * 200 ^ 96 * Q := by norm_num

/-! ## Window bound and the coarse `δ` witness -/

/-- The finite window `n₁ ∈ [2^71, 29·2^71]` lies below `2^76`, so `k₁ ≤ 75`. -/
theorem window_lt_2pow76 : 29 * X < 2 ^ 76 := by norm_num

/-- Coarse rational witness for `δ = log₂ 3`: `3^200 < 2^317` (i.e. `δ < 317/200`). -/
theorem alpha_witness : (3 : ℤ) ^ 200 < 2 ^ 317 := by norm_num

/-! ## Valuation-cap soundness

For block `i` the prefix word length satisfies `k < (317/200)^(i-1)·76`; the
search caps `kᵢ` are sound iff `76·317^(i-1) ≤ (capᵢ + 1)·200^(i-1)`. -/

theorem cap1 : 76 * (317 : ℤ) ^ 0 ≤ (75 + 1) * 200 ^ 0 := by norm_num
theorem cap2 : 76 * (317 : ℤ) ^ 1 ≤ (120 + 1) * 200 ^ 1 := by norm_num
theorem cap3 : 76 * (317 : ℤ) ^ 2 ≤ (191 + 1) * 200 ^ 2 := by norm_num
theorem cap4 : 76 * (317 : ℤ) ^ 3 ≤ (303 + 1) * 200 ^ 3 := by norm_num
theorem cap5 : 76 * (317 : ℤ) ^ 4 ≤ (481 + 1) * 200 ^ 4 := by norm_num
theorem cap6 : 76 * (317 : ℤ) ^ 5 ≤ (763 + 1) * 200 ^ 5 := by norm_num
theorem cap7 : 76 * (317 : ℤ) ^ 6 ≤ (1210 + 1) * 200 ^ 6 := by norm_num

/-! ## Descent lower-bound stage monotonicity

`extra₈ = ⌈93·2^189 / 50⌉ = 1459426153477403277591821040895782441743797640837888024249`. -/

abbrev extra6 : ℤ := 3 * 2 ^ 74
abbrev extra7 : ℤ := 7 * 2 ^ 117
abbrev extra8 : ℤ := 1459426153477403277591821040895782441743797640837888024249

theorem stage_mono_67 : extra6 < extra7 := by norm_num
theorem stage_mono_78 : extra7 < extra8 := by norm_num
theorem stage6_gt_X : X < extra6 := by norm_num

end CollatzM96
