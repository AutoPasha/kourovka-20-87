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

pp := Filtered([4..1000], IsPrimePowerInt);
bad := 0; cnt := 0; goodL2 := [];
for q in pp do
  cnt := cnt + 1;
  v := P2(LieP2("A", 1, q, "none"));
  if v <> L2ok(q) then bad := bad + 1; Print("MISMATCH L2(", q, ")\n"); fi;
  if v then Add(goodL2, q); fi;
od;
Print("L2(q), 4<=q<=1000: ", cnt, " cases, mismatches ", bad, "\n");
Print("  (P2) holds for q in ", goodL2, "\n");

pp := Filtered([2..200], IsPrimePowerInt);
bad := 0; cnt := 0; goodL3 := []; goodU3 := [];
for q in pp do
  cnt := cnt + 1;
  v := P2(LieP2("A", 2, q, "none"));
  if v <> L3ok(q, 1) then bad := bad + 1; Print("MISMATCH L3(", q, ")\n"); fi;
  if v then Add(goodL3, q); fi;
  if q > 2 then
    v := P2(LieP2("A", 2, q, A2inv));
    if v <> L3ok(q, -1) then bad := bad + 1; Print("MISMATCH U3(", q, ")\n"); fi;
    if v then Add(goodU3, q); fi;
  fi;
od;
Print("L3(q), U3(q), q<=200: ", cnt, " values of q, mismatches ", bad, "\n");
Print("  L3: (P2) holds for q in ", goodL3, "\n");
Print("  U3: (P2) holds for q in ", goodU3, "\n");

for q in [8, 32, 128, 512, 2048] do
  v := P2(LieP2("C", 2, q, "ree"));
  Print("Sz(", q, "): torus method ", v, ", formula ", Szok(q), "\n");
od;
for q in [27, 243, 2187] do
  v := P2(LieP2("G", 2, q, "ree"));
  Print("2G2(", q, "): torus method ", v, ", formula ", Reeok(q), "\n");
od;
QUIT;
