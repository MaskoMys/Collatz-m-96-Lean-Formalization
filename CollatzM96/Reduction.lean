import Mathlib
import CollatzM96.Constants
import CollatzM96.Farey

/-!
# The reduction layer: the `m`-cycle object and the axiom interface

This file makes the paper's trust boundary **explicit**.

`MCycle` is the standard "least-element-rotated" block model of a nontrivial
positive Collatz cycle, exactly as used by Hercher and by Simons–de Weger:
the local minima `n 1, …, n m` (rotated so `n 1` is least), the odd-state period
`K = Σ kᵢ`, and the even-step total `L = Σ ℓᵢ`.

Four facts about such a cycle are **imported as named axioms** rather than proved
from the Collatz map.  Three are *published theorems*; one is the *externally
verified computation* at the core of the paper.  These — and **only** these —
are what the audit command will reveal under the main theorem:

```bash
lake env lean audit/AxiomReport.lean
```

⚠️  **Honest scope.**  `enclosure_*`, `simons_deWeger`, `barina`, and
`finite_window_excluded` are *assumptions*, not Lean proofs.  In particular the
75-branch exact search and the certified analytic enclosures are **not
re-executed inside Lean**; they are taken as hypotheses.  See `docs/TRUST.md`.
-/

namespace CollatzM96

/-- **Block model of a nontrivial positive Collatz `m`-cycle**
(the Hercher / Simons–de Weger object).

`n i` are the `m` local minima, rotated so that `n 1` is the least; `K` is the
odd-state period `Σ kᵢ` and `L = Σ ℓᵢ`.  The deep "block decomposition" that
produces this data from the raw Collatz map is the standard published reduction
and is taken here as the modelling interface. -/
structure MCycle where
  /-- number of local minima (blocks) -/
  m : ℕ
  hm : 1 ≤ m
  /-- the local minima `n 1, …, n m`, rotated so `n 1` is least -/
  n : ℕ → ℤ
  /-- odd-state period `K = Σ kᵢ` -/
  K : ℤ
  /-- even-step total `L = Σ ℓᵢ` -/
  L : ℤ
  /-- positivity / nontriviality -/
  n1_pos : 0 < n 1
  /-- `n 1` is the least minimum -/
  n1_least : ∀ i, 1 ≤ i → i ≤ m → n 1 ≤ n i
  /-- `K > 0` -/
  K_pos : 0 < K

/-! ## The four imported facts -/

/-- **(A1) Barina (2025), `J. Supercomput.` 81:810.**
Brute-force verification of Collatz convergence below `2^71` ⇒ every element of
a nontrivial cycle is `≥ 2^71`. -/
axiom barina (C : MCycle) : X ≤ C.n 1

/-- **(A2a) First denominator lift.**  Output of the certified analytic enclosure
with `X₀ = 2^71`: the rational `(K+L)/K` lies strictly between the first-lift
Farey neighbours, in exact integer cross-inequality form.  (Encapsulates
Barina + Hercher's growth law + the suffix-balance rotation lemma.) -/
axiom enclosure_floor (C : MCycle) (hm : C.m = 96) :
    1 ≤ (C.K + C.L) * b1 - a1 * C.K ∧ 1 ≤ c1 * C.K - (C.K + C.L) * d1

/-- **(A2b) Closing denominator lift.**  The same enclosure reapplied *above the
finite window* (with `K* = K₀`, `X₀ = 29·2^71`): `(K+L)/K` lies strictly between
the closing Farey neighbours. -/
axiom enclosure_above_window (C : MCycle) (hm : C.m = 96) (h29 : 29 * X < C.n 1) :
    1 ≤ (C.K + C.L) * b2 - a2 * C.K ∧ 1 ≤ c2 * C.K - (C.K + C.L) * d2

/-- **(A3) Simons–de Weger (2005), `Acta Arith.` 117.**
`K < 1.4784·96·δ^96`, in the exact integer form obtained with `δ < 317/200`. -/
axiom simons_deWeger (C : MCycle) (hm : C.m = 96) :
    10000 * (200 : ℤ) ^ 96 * C.K < 14784 * 96 * 317 ^ 96

/-- **(A4) Finite-window certificate (the computation).**
The 75 disjoint, zero-hit branches — independently reproduced — exclude every
nontrivial `96`-cycle whose least minimum lies in `[2^71, 29·2^71]`.

This proposition stands in for the externally verified exact search; it is
**not** re-run inside Lean.  See `docs/TRUST.md` for the in-kernel discharge path. -/
axiom finite_window_excluded :
    ¬ ∃ C : MCycle, C.m = 96 ∧ X ≤ C.n 1 ∧ C.n 1 ≤ 29 * X

/-! ## Derived denominator-lift bounds (these ARE proved, via `farey_denominator_bound`) -/

/-- **First lift ⇒ `K ≥ K₀`.**  (Included for faithfulness to §11; the headline
theorem does not depend on it — see `docs/TRUST.md`.) -/
theorem K_ge_K0 (C : MCycle) (hm : C.m = 96) : K0 ≤ C.K := by
  obtain ⟨h1, h2⟩ := enclosure_floor C hm
  have hb : (0 : ℤ) < b1 := by norm_num
  have hd : (0 : ℤ) < d1 := by norm_num
  have hbound := farey_denominator_bound hb hd farey1_det h1 h2
  have hbd : b1 + d1 = K0 := farey1_mediant
  linarith

/-- **Closing lift ⇒ `K ≥ Q`** above the finite window. -/
theorem K_ge_Q (C : MCycle) (hm : C.m = 96) (h29 : 29 * X < C.n 1) : Q ≤ C.K := by
  obtain ⟨h1, h2⟩ := enclosure_above_window C hm h29
  have hb : (0 : ℤ) < b2 := by norm_num
  have hd : (0 : ℤ) < d2 := by norm_num
  have hbound := farey_denominator_bound hb hd farey2_det h1 h2
  have hbd : b2 + d2 = Q := farey2_mediant
  linarith

/-- **Simons–de Weger ⇒ `K < Q`.** -/
theorem K_lt_Q (C : MCycle) (hm : C.m = 96) : C.K < Q := by
  by_contra h
  push_neg at h                              -- h : Q ≤ C.K
  have hsdw := simons_deWeger C hm
  have hlt := sdW_surrogate_lt_Q
  have hpos : (0 : ℤ) ≤ 10000 * 200 ^ 96 := by positivity
  -- `Q ≤ K` scaled by the positive factor, chained against the two strict bounds:
  have hscaled : 10000 * (200 : ℤ) ^ 96 * Q ≤ 10000 * 200 ^ 96 * C.K :=
    mul_le_mul_of_nonneg_left h hpos
  linarith

end CollatzM96
