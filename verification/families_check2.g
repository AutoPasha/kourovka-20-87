# Extension of families_check.g to L2(q), 1000<q<=2000.
# Cross-check of the closed-form criteria (Theorem, families (3)-(7)) against the
# torus method (torus_method.g) for many q.
Read("torus_method.g");

om := n -> omega(n);    # omega(1) = 0
L2ok := function(q) local d; d := Gcd(2, q-1);
  return om((q-1)/d) <= 2 and om((q+1)/d) <= 2; end;
L3ok := function(q, e) local d; d := Gcd(3, q-e);
  return om((q-e)/d) <= 1 and om((q^2-1)/d) <= 2 and om((q^2+e*q+1)/d) <= 2; end;
Szok := function(q) local r; r := RootInt(2*q, 2);
  return om(q-1) <= 2 and om(q+r+1) <= 2 and om(q-r+1) <= 2; end;
Reeok := function(q) local r; r := RootInt(3*q, 2);
  return om(q-1) <= 2 and om(q+1) <= 2 and om(q+r+1) <= 2 and om(q-r+1) <= 2; end;

P2 := R -> R.maxss <= 2 and R.maxmix <= 1;
A2inv := PermList([2,1]);

pp := Filtered([1001..2000], IsPrimePowerInt);
bad := 0; cnt := 0; goodL2 := [];
for q in pp do
  cnt := cnt + 1;
  v := P2(LieP2("A", 1, q, "none"));
  if v <> L2ok(q) then bad := bad + 1; Print("MISMATCH L2(", q, ")\n"); fi;
  if v then Add(goodL2, q); fi;
od;
Print("L2(q), 1000<q<=2000: ", cnt, " cases, mismatches ", bad, "\n");
Print("  (P2) holds for q in ", goodL2, "\n");

QUIT;
