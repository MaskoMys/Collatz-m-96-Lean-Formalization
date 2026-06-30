# CollatzM96 — a machine-checked core for the Collatz 96-cycle exclusion

A Lean 4 formalization of the mathematical core and logical skeleton of

> N. Mghirbi, *Prefix Rigidity, Surplus Frontiers, and an Exact Certificate
> Excluding Collatz 96-Cycles* (2026), **Theorem 11.3**:
> *there is no nontrivial positive Collatz 96-cycle.*

It is **sorry-free** and **builds with `lake`** against the pinned toolchain. The
Lean kernel checks the entire argument **down to four explicitly named
assumptions**, which the build prints for you.

---

## What this is, in one minute

The Collatz ("3n+1") problem asks whether repeatedly applying *"halve if even,
else 3n+1 then halve"* always reaches 1. A **cycle** would be a counterexample: a
loop of numbers that never reaches 1. Researchers measure cycles by their number
of "local minima" `m`. It is known there is no such loop with `m ≤ 95`. The paper
pushes this to **`m = 96`**.

This repository takes the paper's argument and rebuilds the **load-bearing
mathematics inside a proof assistant**, where a small, simple, trusted *kernel*
re-checks every inferential step. What you get is not a slide deck or a script
whose correctness you must trust — it is a machine-verified chain of reasoning
with its assumptions laid bare.

```
CollatzM96/
  Farey.lean          Stern–Brocot mediant denominator bound      ← proved
  AffineIdentity.lean affine prefix identity (Lemma 2.2)          ← proved
  Constants.lean      every exact constant + arithmetic check     ← proved
  Reduction.lean      the m-cycle object + the 4 assumptions      ← interface
  Main.lean           Theorem 11.3  +  #print axioms              ← proved
docs/  BUILD.md · TRUST.md · THEOREM_MAP.md
```

---

## Novelty

- **A formal mediant-lift bound.** The paper's decisive move is a
  Farey/Stern–Brocot *denominator lift*: pinning the rational `(K+L)/K` between
  two Farey neighbours forces its denominator `K` past a huge threshold. That
  bound is here a **fully proved Lean theorem** (`farey_denominator_bound`) — the
  clean one-line mediant identity, machine-checked, with no lowest-terms
  hypothesis.
- **The reduction, mechanized end to end.** From the two enclosures and the
  Simons–de Weger bound, Lean derives `K ≥ Q` and `K < Q` and closes the
  contradiction with **no hidden steps**. To our knowledge this is the first
  in-kernel formalization of an *affine-ladder `m`-cycle exclusion*.
- **A recovered constant.** The closing Farey numerator is garbled in the source
  PDF; it is uniquely reconstructed from the determinant condition
  (`c₂ = 325919355854421968365`) and re-checked — see `docs/THEOREM_MAP.md`.

## Trust — what the kernel guarantees, and what it doesn't

**Verified outright (no problem-specific axioms):** the mediant denominator
bound, the affine prefix identity, *all* the exact integer arithmetic (both Farey
determinants and mediants, the Simons–de Weger comparison, the valuation caps,
the descent stages), and the final two-case contradiction. See the table in
`docs/TRUST.md`.

**Assumed, and named in plain sight (four axioms):**

1. `barina` — Collatz verified below `2^71` *(published: Barina 2025)*.
2. `enclosure_above_window` — the certified analytic enclosure above the window
   *(assumed; packages Hercher's growth law + suffix balance + log enclosures)*.
3. `simons_deWeger` — the cycle upper bound *(published: Simons–de Weger 2005)*.
4. `finite_window_excluded` — the **75-branch exact search** result
   *(assumed; the computation is **not** re-run inside Lean)*.

Running the project prints precisely these (next to Lean's standard
`propext / Classical.choice / Quot.sound`):

```
'CollatzM96.no_nontrivial_collatz_96_cycle' depends on axioms:
 [propext, Classical.choice, Quot.sound,
  CollatzM96.barina, CollatzM96.enclosure_above_window,
  CollatzM96.simons_deWeger, CollatzM96.finite_window_excluded]
```

> **Honest headline.** This is a *verified reduction*, not a from-scratch
> in-kernel proof of Collatz-96. It establishes, with kernel certainty:
> *conditional on the two published results and the externally verified
> 75-branch search, no nontrivial positive Collatz 96-cycle exists.* The 75
> branches and the analytic certificates are taken as stated hypotheses; the
> documented route to discharging each one in-kernel is in `docs/TRUST.md`.
> **"Sorry-free" here means no hidden holes — every assumption is a named,
> visible axiom — not that the search was replayed in the kernel.**

## Reproducibility

```bash
# 1. install Lean/lake if needed
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
# 2. from the project root:
lake exe cache get      # prebuilt Mathlib (the only slow step)
lake build              # checks the project; prints the axiom list
# 3. confirm there are no sorries (prints nothing):
grep -rn --include=*.lean -E '\bsorry\b|\badmit\b' CollatzM96
```

Full instructions, an interactive-check recipe, and a version-mismatch fix are in
`docs/BUILD.md`. Every numeral the proofs assert was independently re-checked with
exact-integer arithmetic (`docs/THEOREM_MAP.md`).

> The authoring environment had no network access to the Lean toolchain servers,
> so `lake build` was not run there; the sources target the pinned
> `leanprover/lean4:v4.15.0` toolchain and use only long-stable Mathlib lemmas.
> The `#print axioms` line is the definitive trust statement — please run it.

## Impact and how to cite

A formal artifact like this lets a referee replace *"trust the 800-second C++
search and the analytic bookkeeping"* with *"inspect four named assumptions and
let the kernel check the rest."* It pins the contradiction structure of §11
beyond doubt, makes the recovered constant auditable, and gives a concrete
scaffold for the remaining in-kernel work (replaying the search via `decide` /
`native_decide`, and formalizing the enclosures).

If you use this development, please cite **both** the paper and this artifact, and
state the trust boundary honestly:

```bibtex
@misc{CollatzM96Lean,
  title  = {CollatzM96: a Lean 4 verified reduction of the Collatz 96-cycle exclusion},
  note   = {Kernel-checked modulo four named axioms (Barina 2025;
            Simons--de Weger 2005; a certified analytic enclosure; and an
            externally verified 75-branch exact search). See docs/TRUST.md.},
  year   = {2026}
}
```

Accompanying paper: N. Mghirbi, *Prefix Rigidity, Surplus Frontiers, and an Exact
Certificate Excluding Collatz 96-Cycles* (2026).

## License

The Lean code may be used under the MIT license. The accompanying paper and its
results remain the work of their author; cite accordingly.
