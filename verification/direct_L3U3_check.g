# Direct check (actual groups, no character tables, no torus method) of the criterion of
# Proposition 6.4 for L3(q) and U3(q), small q.
omega := n -> Length(Set(Filtered(Factors(n), x -> x > 1)));
L3ok := function(q, e) local d; d := Gcd(3, q-e);
  return omega((q-e)/d) <= 1 and omega((q^2-1)/d) <= 2 and omega((q^2+e*q+1)/d) <= 2; end;
P2 := P -> ForAll(ConjugacyClasses(P), c -> omega(Order(Representative(c))) <= 2);
bad := 0;
for q in Filtered([2..13], IsPrimePowerInt) do
  F := GF(q);
  P := Action(SL(3,q), Set(NormedRowVectors(F^3)), OnLines);
  v := P2(P);
  if v <> L3ok(q, 1) then bad := bad + 1; fi;
  Print("L3(", q, "): direct ", v, ", criterion ", L3ok(q, 1), "\n");
  if q > 2 then
    G := SU(3,q); K := GF(q^2);
    f := InvariantSesquilinearForm(G).matrix;
    iso := Filtered(NormedRowVectors(K^3), x -> x * f * List(x, y -> y^q) = Zero(K));
    P := Action(G, iso, OnLines);
    v := P2(P);
    if v <> L3ok(q, -1) then bad := bad + 1; fi;
    Print("U3(", q, "): direct ", v, ", criterion ", L3ok(q, -1), "\n");
  fi;
od;
Print("mismatches: ", bad, "\n");
QUIT;
