# Pips-PROLOG: Generate-and-Test Domino Puzzle Solver

Prolog solver for **Pips**, a domino-style logic puzzle: a set of dominoes (each a pair of numbers) must be placed on a board of regions so that every region's rule is satisfied — a fixed value, all-equal, all-different, or a sum that must equal/be-below/be-above a target. The solver follows a classic **generate-and-test** structure: it places every domino on two adjacent, still-free cells (Phase 1), then checks every region's constraint against the resulting board (Phase 2); if any region fails, Prolog's backtracking discards that placement and tries another, with no explicit "undo" logic needed anywhere.

The neat part is how domino rotation falls out of backtracking for free: a domino's first value is always bound to `C1` and its second to `C2`, and both cell candidates are found via two separate `pertany` (member) calls — so when a placement fails, backtracking naturally retries with `C1`/`C2` swapped, "flipping" the domino without any dedicated rotate predicate. The same mechanism lets a single domino span two different regions, since `C1` and `C2` are searched for independently, each within its own region's cell list.

## Environment

- SWI-Prolog (or any standard Prolog implementation — no non-standard extensions used).
- No external dependencies.

## Running

```prolog
?- consult('pips.pl').

% Check a known solution against a puzzle:
?- puzzle(20250818, easy, Regions, Peces, Solucio),
   solucio_pips(Regions, Peces, Solucio).

% Let the solver compute its own solution and compare it to the known one:
?- puzzle(20250818, easy, Regions, Peces, SolucioEsperada),
   solucio_pips(Regions, Peces, SolucioCalculada),
   SolucioEsperada = SolucioCalculada.

% Or call it directly without the built-in puzzle facts:
?- solucio_pips([region(empty, nil, [[0,0]]), ...], [[2,2], ...], Solucio).
```

The file ships with several `puzzle/5` facts (one per day/difficulty) as sample data and known-solution test cases.

## Architecture

Single-file solver (`pips.pl`), organized top to bottom:

- **Knowledge base** — `puzzle(Date, Difficulty, Regions, Peces, Solucio)` facts: each region is `region(Rule, Target, Cells)`, each piece is a `[Value1, Value2]` pair, and each solution entry is the `[C1, C2]` cell pair that piece occupies.
- **`solucio_pips/3`** — entry point: generate a candidate placement, then verify it.
- **Phase 1 — generate** (`generar_solucio`, `generar`, `trobar_posicio`): recursively places each piece on two adjacent, unoccupied cells (`adjacents/2`), tracking occupied cells as it goes (`afegir/3`).
- **Phase 2 — check** (`comprovar_regions`, `comprovar_una_regio`): one clause per rule type (`empty`, `equals`, `unequal`, `sum`, `less`, `greater`), each pulling the region's cell values via `valors_regio` → `obtenir_valor` → `valor_peca` (a parallel walk of the pieces list and the solution's position list to find which domino half landed in a given cell) and checking the rule.
- **Utilities** — `pertany/2` (member), `sumar/2`, `tots_iguals/1`, `tots_diferents/1` (with a `=:=`-safe `pertany_valor/2` helper), `afegir/3` (append), `adjacents/2` (orthogonal adjacency check).

## Authors

Carlos Garrido del Toro - Computer Engineering, University of the Balearic Islands.
