# Building and checking `CollatzM96`

This is a standard Lean 4 + Mathlib project built with `lake`. A full check takes
a few minutes on a laptop, almost all of which is **downloading prebuilt
Mathlib** (you do not recompile Mathlib).

> **Transparency note.** This package was authored in an environment without
> network access to the Lean toolchain servers, so `lake build` could **not** be
> executed there. The code is written against the pinned toolchain below using
> only stable, long-standing Mathlib lemmas, and every numeral asserted by a
> `norm_num`/`decide` step was independently checked with exact-integer
> arithmetic (see `docs/THEOREM_MAP.md`). Please run the build yourself with the
> commands below; the `#print axioms` output is the definitive trust statement.

## 1. Install Lean / lake (via `elan`)

If you do not already have `elan`:

```bash
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
# then restart your shell, or:  source $HOME/.elan/env
```

`elan` will read `lean-toolchain` and fetch the matching compiler automatically.

## 2. Fetch prebuilt Mathlib and build

From the project root (the directory containing `lakefile.toml`):

```bash
lake exe cache get      # downloads prebuilt Mathlib .olean files (the slow step)
lake build              # compiles this project on top of Mathlib
```

A successful build prints the axiom list for the main theorem (from the
`#print axioms` line at the bottom of `CollatzM96/Main.lean`).

## 3. Inspect the result interactively (recommended)

Open `CollatzM96/Main.lean` in VS Code with the Lean 4 extension, or run:

```bash
lake env lean CollatzM96/Main.lean
```

You should see the theorem accepted and an axiom list of the form:

```
'CollatzM96.no_nontrivial_collatz_96_cycle' depends on axioms:
 [propext, Classical.choice, Quot.sound,
  CollatzM96.barina,
  CollatzM96.enclosure_above_window,
  CollatzM96.simons_deWeger,
  CollatzM96.finite_window_excluded]
```

The first three are Lean/Mathlib's standard logical foundations. The last four
are the **only** problem-specific assumptions; they are explained in
`docs/TRUST.md`.

To confirm there are **no `sorry`s**, search the sources:

```bash
! grep -rn --include=*.lean -E '\bsorry\b|\badmit\b' CollatzM96
```

(The command prints nothing and exits 0 — there are none.)

## Version-mismatch recipe

`lean-toolchain` and the Mathlib `rev` in `lakefile.toml` are pinned to the same
release (`v4.15.0`) and must always agree. If your `lake` reports it cannot find
that Mathlib revision, or you wish to build on a newer stack:

```bash
# point lakefile.toml's [[require]] rev at a Mathlib commit/tag you want, then:
lake update mathlib
cp .lake/packages/mathlib/lean-toolchain ./lean-toolchain   # match toolchains
lake exe cache get
lake build
```

The proofs use only long-stable lemmas (`mul_le_mul_of_nonneg_left`,
`pow_add`, `pow_succ`, `linear_combination`, `norm_num`, `linarith`,
`positivity`), so they are expected to compile unchanged across recent Mathlib
versions; only the pinned revisions may need refreshing.
