# Boundary cases whose character tables are not in ctbllib.
# (a) torus method for L4(8), U4(8), S6(8), 3D4(4), 3D4(8), G2(8), L4(2..3), S6(8)
# (b) explicit witnesses: elements whose order has three prime divisors in
#     SL4(8), SU4(8), Sp6(8) (centre trivial in all three), and in SL4(4), Sp6(4).
Read("torus_method.g");
A := function(n) return PermList(List([1..n], i -> n + 1 - i)); end;
tri := First(DiagramAuts(RootDatum("D", 4).C), g -> Order(g) = 3);

ReportP2("L4(8)", LieP2("A", 3, 8, "none"));
ReportP2("U4(8)", LieP2("A", 3, 8, A(3)));
ReportP2("S6(8)", LieP2("C", 3, 8, "none"));
ReportP2("3D4(4)", LieP2("D", 4, 4, tri));
ReportP2("3D4(8)", LieP2("D", 4, 8, tri));
ReportP2("G2(8)", LieP2("G", 2, 8, "none"));

# explicit element of order 126 in SL4(8):  diag(a*J2, B), a of order 7, B of order 63, det B = a^-2
F := GF(8); a := Z(8);
S := CompanionMat(MinimalPolynomial(F, Z(64)));       # Singer cycle of GL2(8), order 63
B := First(List([1..63], k -> S^k), x -> Order(x) = 63 and Determinant(x) = a^-2);
J := a * [[1,1],[0,1]] * One(F);
g := NullMat(4, 4, F);
g{[1,2]}{[1,2]} := J; g{[3,4]}{[3,4]} := B;
Print("SL4(8) witness: det = ", Determinant(g), ", order = ", Order(g), " = ", Factors(Order(g)), "\n");

# SL4(4): same construction, order 30
F := GF(4); a := Z(4);
S := CompanionMat(MinimalPolynomial(F, Z(16)));
B := First(List([1..15], k -> S^k), x -> Order(x) = 15 and Determinant(x) = a^-2);
J := a * [[1,1],[0,1]] * One(F);
g := NullMat(4, 4, F);
g{[1,2]}{[1,2]} := J; g{[3,4]}{[3,4]} := B;
Print("SL4(4) witness: det = ", Determinant(g), ", order = ", Order(g), " = ", Factors(Order(g)), "\n");

# random search in SU(4,8), Sp(6,8), Sp(6,4) for an element whose order has >= 3 prime divisors
search := function(G, name)
  local i, x, o;
  for i in [1..20000] do
    x := PseudoRandom(G); o := Order(x);
    if omega(o) >= 3 then
      Print(name, " witness found: element order ", o, " = ", Factors(o),
            " ; centre of matrix group has order ", Size(Centre(G)), "\n");
      return x;
    fi;
  od;
  Print(name, ": no witness found in 20000 random elements\n");
  return fail;
end;
search(SU(4, 8), "SU(4,8)");
search(Sp(6, 8), "Sp(6,8)");
search(Sp(6, 4), "Sp(6,4)");
QUIT;
