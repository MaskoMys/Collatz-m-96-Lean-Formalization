import Mathlib

/-!
# The affine prefix identity (Lemma 2.2)

For an accelerated Collatz trajectory `x₀, x₁, …` obeying the per-step relation

  `2^(k t) · x_(t+1) = 3·x_t + 1`,

with partial exponent sums `S_t = k₀ + … + k_(t-1)` and the affine accumulator
`A_(t+1) = 3·A_t + 2^(S_t)`, one has, for every `t`,

  `2^(S t) · x_t = 3^t · x₀ + A_t`.

This is the algebraic backbone behind the prefix-hugging inequality and the
surplus-frontier machinery.  It is **fully verified in the Lean kernel** by a
direct induction on `t`.
-/

namespace CollatzM96

/-- **Affine prefix identity.**  `2^(S t)·x_t = 3^t·x₀ + A_t`. -/
theorem affine_prefix_identity
    (x : ℕ → ℤ) (k S : ℕ → ℕ) (A : ℕ → ℤ) (x0 : ℤ)
    (hx0 : x 0 = x0)
    (hS0 : S 0 = 0) (hSrec : ∀ t, S (t + 1) = S t + k t)
    (hA0 : A 0 = 0) (hArec : ∀ t, A (t + 1) = 3 * A t + 2 ^ (S t))
    (hstep : ∀ t, (2 : ℤ) ^ (k t) * x (t + 1) = 3 * x t + 1) :
    ∀ t, (2 : ℤ) ^ (S t) * x t = 3 ^ t * x0 + A t := by
  intro t
  induction t with
  | zero => simp [hS0, hx0, hA0]
  | succ n ih =>
      have e1 : S (n + 1) = S n + k n := hSrec n
      have e2 : (2 : ℤ) ^ (S (n + 1)) = 2 ^ (S n) * 2 ^ (k n) := by
        rw [e1, pow_add]
      calc (2 : ℤ) ^ (S (n + 1)) * x (n + 1)
          = 2 ^ (S n) * (2 ^ (k n) * x (n + 1)) := by rw [e2]; ring
        _ = 2 ^ (S n) * (3 * x n + 1) := by rw [hstep n]
        _ = 3 * (2 ^ (S n) * x n) + 2 ^ (S n) := by ring
        _ = 3 * (3 ^ n * x0 + A n) + 2 ^ (S n) := by rw [ih]
        _ = 3 ^ (n + 1) * x0 + (3 * A n + 2 ^ (S n)) := by ring
        _ = 3 ^ (n + 1) * x0 + A (n + 1) := by rw [← hArec n]

end CollatzM96
