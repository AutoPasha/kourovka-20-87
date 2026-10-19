# Independent check (not using the character table library) of some positive base cases:
# element orders computed from conjugacy classes of the actual groups, acting on
# projective points (so the image is the simple group).
omega := n -> Length(Set(Filtered(Factors(n), x -> x > 1)));
proj := function(G, F)
  local d;
  d := DimensionOfMatrixGroup(G);
  return Action(G, Set(List(NormedRowVectors(F^d), v -> v)), OnLines);
end;
cases := [ ["L4(3)", SL(4,3), GF(3)], ["L5(2)", SL(5,2), GF(2)], ["U4(3)", SU(4,3), GF(9)],
           ["U5(2)", SU(5,2), GF(4)], ["S4(4)", Sp(4,4), GF(4)], ["S6(2)", Sp(6,2), GF(2)],
           ["S4(8)", Sp(4,8), GF(8)], ["O8+(2)", Omega(+1,8,2), GF(2)], ["G2(3)?skip", fail, fail] ];
for c in cases do
  if c[2] = fail then continue; fi;
  P := proj(c[2], c[3]);
  P := Image(SmallerDegreePermutationRepresentation(P));
  o := Set(List(ConjugacyClasses(P), x -> Order(Representative(x))));
  Print(c[1], ": |T| = ", Size(P), ", max omega = ", Maximum(List(o, omega)),
        ", element orders ", o, "\n");
od;
QUIT;
