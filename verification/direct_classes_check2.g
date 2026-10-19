# Independent check (without the character table library) of Omega_7(3) and P Omega_8^+(3):
# element orders from the conjugacy classes of the permutation action on projective points.
omega := n -> Length(Set(Filtered(Factors(n), x -> x > 1)));
for c in [ ["O7(3)", Omega(7,3), GF(3)], ["O8+(3)", Omega(+1,8,3), GF(3)] ] do
  G := c[2];
  P := Action(G, Set(NormedRowVectors(c[3]^DimensionOfMatrixGroup(G))), OnLines);
  P := Image(SmallerDegreePermutationRepresentation(P));
  o := Set(List(ConjugacyClasses(P), x -> Order(Representative(x))));
  Print(c[1], ": |T| = ", Size(P), ", max omega = ", Maximum(List(o, omega)),
        ", element orders ", o, "\n");
od;
QUIT;
