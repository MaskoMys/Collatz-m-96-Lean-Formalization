# Paper → Lean map, and the numeric certificate

## Section / statement correspondence

| Paper (Mghirbi 2026) | Lean declaration | Status |
|---|---|---|
| Lemma 2.2 — affine prefix identity | `affine_prefix_identity` | proved |
| §11 — Farey/Stern–Brocot mediant denominator lift | `farey_denominator_bound` | proved |
| §11 — first lift `K ≥ K₀` | `K_ge_K0` (from `enclosure_floor`) | proved from axiom |
| §11 — closing lift `K ≥ Q` | `K_ge_Q` (from `enclosure_above_window`) | proved from axiom |
| §11 / (32) — Simons–de Weger `K < 1.4784·96·δ^96` ⇒ `K < Q` | `K_lt_Q` (from `simons_deWeger` + `sdW_surrogate_lt_Q`) | proved from axiom |
| §11 — finite window `n₁∈[2^71,29·2^71]` excluded (75 branches) | `finite_window_excluded` | axiom (computation) |
| §8 — convergence floor `n_i ≥ 2^71` (Barina) | `barina` | axiom (published) |
| **Theorem 11.3** — no nontrivial positive 96-cycle | `no_nontrivial_collatz_96_cycle` | proved (modulo the 4 axioms) |
| §1 / §11 — least-element-rotated `m`-cycle data | `structure MCycle` | definition (interface) |

Sections **2–10** (prefix rigidity, the surplus frontier `A28`, the descent
covers, the `O(log N)` floor-sum oracle, the descent-closure conjecture) state
*necessary conditions* and supporting machinery; the only *complete cycle
exclusion* in the paper is the `m=96` result of §11, which is the formalization
target here. The affine identity (Lemma 2.2) is included as the shared algebraic
backbone; the remaining §2–§10 analysis supports the search engine, which enters
as `finite_window_excluded`.

## The exact constants (all independently re-checked)

Each was confirmed by exact-integer computation before being written into
`Constants.lean`.

**First denominator lift** — Farey neighbours `a₁/b₁ < (K+L)/K < c₁/d₁`:

```
a1 = 202780263237295321099
b1 = 127940101513462006853
c1 = 123139092617126647266
d1 =  77692117359936589403
b1*c1 - a1*d1 = 1          ✓   (Farey neighbours)
b1 + d1       = K0 = 205632218873398596256   ✓   (mediant denominator)
```

**Closing denominator lift** — Farey neighbours `a₂/b₂ < (K+L)/K < c₂/d₂`:

```
a2 = 12261796429850908150604
b2 =  7736332199829210068325
c2 =   325919355854421968365      ← recovered as (a2*d2 + 1)/b2
d2 =  205632218873398596256  (= K0)
b2*c2 - a2*d2 = 1          ✓
b2 + d2       = Q = 7941964418702608664581   ✓
```

> **Note on `c₂`.** The closing upper numerator is mangled in the source PDF
> (it appears concatenated with `K₀` as the 42-digit string
> `325919355854421968365` `205632218873398596256`). It is uniquely recovered
> from the Farey determinant `b₂c₂ − a₂d₂ = 1`, giving
> `c₂ = 325919355854421968365`, which is consistent with that string and with
> `a₂/b₂ < c₂/d₂ ≈ log₂3`.

**Simons–de Weger contradiction** (exact integer form of `1.4784·96·(317/200)^96 < Q`):

```
14784 * 96 * 317^96  <  10000 * 200^96 * Q        ✓
```

**Window ⇒ `k₁ ≤ 75`, and the coarse `δ` witness:**

```
29 * 2^71 < 2^76      ✓        3^200 < 2^317  (δ < 317/200)   ✓
```

**Valuation-cap soundness** `76·317^{i−1} ≤ (capᵢ+1)·200^{i−1}` with
`caps = [75,120,191,303,481,763,1210]`: all 7 hold ✓.

**Descent lower-bound stages:**

```
extra6 = 3·2^74
extra7 = 7·2^117
extra8 = ⌈93·2^189 / 50⌉ = 1459426153477403277591821040895782441743797640837888024249
2^71 < extra6 < extra7 < extra8      ✓
```
