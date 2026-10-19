# Direct check of the criterion of Proposition 6.1 on the conjugacy classes of PSL(2,q), 4<=q<=128.
omega := n -> Length(Set(Filtered(Factors(n), x -> x > 1)));
L2ok := function(q) local d; d := Gcd(2, q-1);
  return omega((q-1)/d) <= 2 and omega((q+1)/d) <= 2; end;
bad := 0; n := 0;
for q in Filtered([4..128], IsPrimePowerInt) do
  P := PSL(2, q);
  v := ForAll(ConjugacyClasses(P), c -> omega(Order(Representative(c))) <= 2);
  n := n + 1;
  if v <> L2ok(q) then bad := bad + 1; Print("MISMATCH q = ", q, "\n"); fi;
od;
Print("PSL(2,q), 4<=q<=128: ", n, " groups, mismatches ", bad, "\n");
QUIT;
