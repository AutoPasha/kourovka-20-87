# Independent check (without the character table library) of U6(2):
# element orders of U_6(2) from conjugacy classes of SU(6,2) acting on isotropic points.
omega := n -> Length(Set(Filtered(Factors(n), x -> x > 1)));
G := SU(6,2);
F := GF(4);
f := InvariantSesquilinearForm(G).matrix;
iso := Filtered(NormedRowVectors(F^6), v -> v * f * List(v, x -> x^2) = Zero(F));
P := Action(G, iso, OnLines);
o := Set(List(ConjugacyClasses(P), x -> Order(Representative(x))));
Print("U6(2): degree ", Length(iso), ", |image| = ", Size(P), ", max omega = ",
      Maximum(List(o, omega)), ", element orders ", o, "\n");
QUIT;
