# Trust model and honest scope

This document states **exactly** what the Lean kernel checks and what it is asked
to take on faith. Read it before citing the artifact.

## What "sorry-free" means here

The development contains **no `sorry` and no `admit`**: every `theorem` is closed
by genuine tactic proofs that the Lean kernel verifies. The published inputs and
the external computation are introduced as **named `axiom`s** — the standard,
auditable way to formalize a result that rests on prior theorems and on a
finished computer search. `#print axioms` (run at the end of `Main.lean`) makes
the entire assumption set explicit and machine-readable.

`sorry-free` therefore means *"no holes hidden inside proofs; all assumptions are
named and visible at the top level."* It does **not** mean *"every prerequisite
was re-derived from the definition of the Collatz map inside Lean."* The next
two sections are precise about the boundary.

## What is proved in the kernel (no problem-specific axioms)

These are real theorems, verified outright:

| Result | File | How |
|---|---|---|
| **Mediant denominator bound** — Farey neighbours `a/b<c/d` ⇒ any `p/q` between them has `q ≥ b+d` | `Farey.lean` | classical identity `q = b(cq−pd)+d(pb−aq)`, via `linear_combination` + `mul_le_mul_of_nonneg_left` |
| **Affine prefix identity** `2^{S_t} x_t = 3^t x_0 + A_t` (Lemma 2.2) | `AffineIdentity.lean` | induction on `t` |
| **First-lift Farey determinant** `b₁c₁ − a₁d₁ = 1` and mediant `b₁+d₁ = K₀` | `Constants.lean` | `norm_num` |
| **Closing Farey determinant** `b₂c₂ − a₂d₂ = 1` and mediant `b₂+d₂ = Q` | `Constants.lean` | `norm_num` |
| **Simons–de Weger comparison** `14784·96·317^96 < 10000·200^96·Q` | `Constants.lean` | `norm_num` |
| **Valuation-cap soundness** `76·317^{i−1} ≤ (capᵢ+1)·200^{i−1}`, `i=1..7` | `Constants.lean` | `norm_num` |
| **Stage monotonicity** `extra₆<extra₇<extra₈`, and `X<extra₆` | `Constants.lean` | `norm_num` |
| **First lift ⇒ `K ≥ K₀`**, **closing lift ⇒ `K ≥ Q`**, **S–dW ⇒ `K < Q`** | `Reduction.lean` | the Farey bound + the arithmetic facts + `linarith` |
| **Theorem 11.3** — no nontrivial positive Collatz `96`-cycle | `Main.lean` | two-case dichotomy on `n₁` |

In particular the closing contradiction — `K ≥ Q` versus `K < Q` — is fully
mechanized: given the enclosure and Simons–de Weger as stated, Lean derives the
impossibility with no further assumptions.

## What is assumed (the four named axioms)

The headline theorem `no_nontrivial_collatz_96_cycle` depends on exactly four
problem-specific axioms (plus Lean/Mathlib's `propext`, `Classical.choice`,
`Quot.sound`):

1. **`barina`** — *Published.* Barina, *J. Supercomput.* 81:810 (2025):
   Collatz convergence verified below `2^71` ⇒ every cycle element is `≥ 2^71`.
   Verifying this computation in Lean is a separate undertaking and is **not**
   done here.

2. **`enclosure_above_window`** — *Certified analytic input (assumed).* The
   output of the certified interval enclosure, reapplied above the finite window
   (`K* = K₀`, `X₀ = 29·2^71`): the rational `(K+L)/K` lies strictly between the
   closing Farey neighbours, expressed as two exact integer cross-inequalities.
   This packages Hercher's growth law (*arXiv* 2201.00406 / *JIS* 2023), the
   suffix-balance rotation lemma (§11.1), and the rational log/continued-fraction
   enclosures. **These analytic certificates are not re-derived inside Lean.**

3. **`simons_deWeger`** — *Published.* Simons & de Weger, *Acta Arith.* 117
   (2005): `K < 1.4784·96·δ^96`, recorded in the exact integer form the paper
   obtains using `δ < 317/200`.

4. **`finite_window_excluded`** — *The computation (assumed).* The 75 disjoint,
   zero-hit branches of the exact affine-ladder search — independently
   reproduced — exclude every nontrivial `96`-cycle whose least minimum lies in
   `[2^71, 29·2^71]`. **This search is not re-executed inside the Lean kernel.**
   It is represented as a single proposition.

A fifth axiom, **`enclosure_floor`** (the *first* denominator lift, giving
`K ≥ K₀`), is included for faithfulness to §11 but does **not** appear under the
headline theorem: the finite search already absorbs the `K₀`-derived descent
stages, so the top-level proof needs only the *closing* lift. You can confirm
this from the `#print axioms` output.

## The path to discharging the assumptions in-kernel

This artifact is a **verified reduction**: it shrinks "no 96-cycle" to the four
explicit facts above. Removing each assumption is a well-defined (and
substantial) future project:

- **`finite_window_excluded`** → implement the affine-ladder search as a Lean
  function over `ℤ`/`Nat`, prove its branch partition is exhaustive, and evaluate
  the 75 branches with `Decidable` instances via `decide`/`native_decide`, or via
  verified extraction. (`native_decide` would additionally place the Lean
  *compiler* in the trusted base; kernel `decide` would not, at a performance
  cost.)
- **`enclosure_*`** → formalize the prefix-hugging inequality and the rational
  log enclosures over `ℝ`/`ℚ` so the cross-inequalities become theorems.
- **`barina`, `simons_deWeger`** → import existing/own formalizations of those
  published results.

Until then, the honest one-line summary is:

> *Conditional on Barina's verification, Hercher's growth law, the Simons–de
> Weger bound, and the externally verified 75-branch search, there is no
> nontrivial positive Collatz 96-cycle — and this implication is checked by the
> Lean kernel.*
