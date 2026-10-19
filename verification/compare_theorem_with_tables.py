#!/usr/bin/env python3
"""Compare the verdict of the Main Theorem with the GAP character-table scan
(scan_ctbllib.out) for every non-abelian simple group whose table is in ctbllib."""
import re, sys
from math import gcd, isqrt

def omega(n):
    n = abs(n); s = set(); p = 2
    while p * p <= n:
        while n % p == 0:
            s.add(p); n //= p
        p += 1
    if n > 1: s.add(n)
    return len(s)

def L2ok(q):
    d = gcd(2, q - 1); return omega((q - 1) // d) <= 2 and omega((q + 1) // d) <= 2
def L3ok(q, e):
    d = gcd(3, q - e)
    return omega((q - e) // d) <= 1 and omega((q * q - 1) // d) <= 2 and omega((q * q + e * q + 1) // d) <= 2
def Szok(q):
    r = isqrt(2 * q); return all(omega(x) <= 2 for x in (q - 1, q + r + 1, q - r + 1))
def Reeok(q):
    r = isqrt(3 * q); return all(omega(x) <= 2 for x in (q - 1, q + 1, q + r + 1, q - r + 1))

SPORADIC_OK = {"M11", "M12", "M22", "M23", "M24", "J1", "J2", "J3", "HS", "He", "Ru", "Suz", "ON"}
FINITE_OK = {"L4(3)", "L5(2)", "U4(2)", "U4(3)", "U5(2)", "U6(2)", "S4(4)", "S4(8)", "S6(2)",
             "O7(3)", "O8+(2)", "O8+(3)", "G2(3)", "G2(4)", "G2(8)", "3D4(2)", "2F4(2)'", "2F4(8)"}

def predicted(name):
    m = re.fullmatch(r"A(\d+)", name)
    if m: return int(m.group(1)) <= 11
    m = re.fullmatch(r"(L2|L3|U3|Sz|R)\((\d+)\)", name)
    if m:
        f, q = m.group(1), int(m.group(2))
        return {"L2": L2ok, "Sz": Szok, "R": Reeok}.get(f, None)(q) if f in ("L2", "Sz", "R") \
            else L3ok(q, 1 if f == "L3" else -1)
    return name in SPORADIC_OK or name in FINITE_OK

good, bad = [], []
for line in open(sys.argv[1] if len(sys.argv) > 1 else "scan_ctbllib.out"):
    if line.startswith("GOOD ") and not line.startswith("GOOD count"):
        good.append(line.split()[1])
    elif line.startswith("BAD ") and not line.startswith("BAD count"):
        bad.append(line.split()[1])
mism = [n for n in good if not predicted(n)] + [n for n in bad if predicted(n)]
print("tables:", len(good) + len(bad), " good:", len(good), " bad:", len(bad))
print("mismatches with the Main Theorem:", mism if mism else "none")
