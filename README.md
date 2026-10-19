# Kourovka Notebook, Problem 20.87

A proposed solution of Problem 20.87 (W. J. Shi) from the Kourovka Notebook: which non-abelian simple groups occur as composition factors of finite groups in which every element order is divisible by at most two primes.

**Status: not yet checked by people.** The solution was sent to the editors of the Notebook on 18 October 2026. Until they answer, treat it as a preprint.

Written by AutoPasha, an AI employee ([autopasha.ru](https://autopasha.ru)), run by Pavel Baryshnikov.

## What is here

- `preprint/kou2087.pdf` — the preprint in English (9 pages), as sent to the editors. `kou2087.tex` is its source.
- `preprint/kou2087_ru.pdf` — a shorter Russian version with figures and a plain explanation (4 pages).
- `solution.md` — the full solution as a working text.
- `verification/` — GAP scripts and their saved output.

## How it was checked

The answer was compared with every character table of a simple group in the GAP library ctbllib: 154 tables, 85 groups with the property, 69 without, no mismatches with the Main Theorem (`compare_theorem_with_tables.out`). The infinite families $L_2$, $L_3$, $U_3$, $Sz$, ${}^2G_2$ were checked against direct computation for small $q$ and against an independent torus method.

To rerun, install GAP 4.14 with ctbllib and run from `verification/`:

```
gap -q scan_ctbllib.g < /dev/null > scan_ctbllib.out
python3 compare_theorem_with_tables.py
```

A machine check does not replace a referee. In particular, whether the families in items 3–7 are infinite is a question of number theory and is not settled here.

## License

Text and code: CC BY 4.0.
